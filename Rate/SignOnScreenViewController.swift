//
//  SignOnScreenViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 21/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit
import SwifteriOS
import Accounts
import Social


class SignOnScreenViewController: UIViewController, FBLoginViewDelegate {

    var swifter: Swifter
    var eventData = Dictionary<String, String>()
    let useACAccount = true

    @IBOutlet weak var facebookLoginView: FBLoginView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.swifter = Swifter(consumerKey: "htbga9HzSGVe82aUd1DUA07wx", consumerSecret: "pYnAob3OJYVpPK8CNnnN6ZC917if1vqIEURY74xkXaVvPnrbnh")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
       self.facebookLoginView.delegate = self
       self.facebookLoginView.readPermissions = ["public_profile", "email", "user_friends"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /**
    * Facebook Login
    */
    @IBAction func facebookSignOnButton(sender: AnyObject) {
    
    }
    
    @IBAction func skipSignOnbutton(sender: AnyObject) {
        var registerViewController:ManualLoginViewController = ManualLoginViewController(nibName: "ManualLoginViewController", bundle: nil)
        navigationController?.pushViewController(registerViewController, animated:true)
    }
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        println("This is where you perform a segue.")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
        println(user.username)
        println(user.first_name)
        println(user.last_name)
        println(user.objectID)
        
        //loginComplete()
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    
    /**
    * Twitter Login
    */
    @IBAction func twitterLoginButton(sender: AnyObject) {
        let failureHandler: ((NSError) -> Void) = {
            error in
            self.alertWithTitle("Error", message: error.localizedDescription)
        }
        
        if useACAccount {
            let accountStore = ACAccountStore()
            let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            
            // Prompt the user for permission to their twitter account stored in the phone's settings
            accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
                granted, error in
                
                if granted {
                    let twitterAccounts = accountStore.accountsWithAccountType(accountType)
                    
                    if twitterAccounts?.count == 0
                    {
                        self.alertWithTitle("Error", message: "There are no Twitter accounts configured. You can add or create a Twitter account in Settings.")
                    }else {
                        let twitterAccount = twitterAccounts[0] as ACAccount
                        self.swifter = Swifter(account: twitterAccount)

                        
                        // get username
                        //println(twitterAccount.username)
                        
                        
                        // create user object
                        
                        
                        // now go to the mainscreen
                        
                        //loginComplete()
                    }
                }
                else {
                    self.alertWithTitle("Error", message: error.localizedDescription)
                }
            }
        }
        else {
            swifter.authorizeWithCallbackURL(NSURL(string: "swifter://success")!, success: {
                accessToken, response in
                
                println("ingelogd")
                
                },failure: failureHandler
            )
        }
    }

    
    /**
    * Login complete handler
    */
    func loginComplete(){
        eventData["menu"] = "teaser"
        NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    /**
    * Present an alert in case something goes wrong
    */
    func alertWithTitle(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
