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

    // Facebook view
    var fbl: FBLoginView = FBLoginView()


    
    // Services
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()
    let applicationModel = ApplicationData.sharedModel()
    let dataServices = DataManager.dataManager()

    // Screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds

    var descriptionLabel: UILabel?
    var welcomeLabel: UILabel?
    var signButton:UIButton?
    var twitterButton:UIButton?
    var backgroundImage:UIImage?
    var backgroundImageView:UIImageView?
    var overlay:UIImageView?
    var footer:UIImageView?
    

    
    var userModel:UserModel?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.swifter = Swifter(consumerKey: "htbga9HzSGVe82aUd1DUA07wx", consumerSecret: "pYnAob3OJYVpPK8CNnnN6ZC917if1vqIEURY74xkXaVvPnrbnh")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // detect our device type
        deviceFunctionService.detectDevice()
        
        // Do any additional setup after loading the view.
       self.fbl.delegate = self
       self.fbl.readPermissions = ["public_profile", "email", "user_friends"]
        
        // update the interface
        createUI()
    }


    func createUI(){

        var tileView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        
        // description
        welcomeLabel = UILabel()
        welcomeLabel!.frame = CGRect(x: 0, y: 100, width: tileView.frame.width, height: 120)
        welcomeLabel!.numberOfLines = 1
        welcomeLabel!.lineBreakMode = .ByWordWrapping
        welcomeLabel!.text = "Welkom"
        welcomeLabel!.font =  UIFont (name: "Avenir-Black", size: 70)
        welcomeLabel!.textColor = UIColor.whiteColor()
        welcomeLabel!.textAlignment = NSTextAlignment.Center

        // description
        descriptionLabel = UILabel()
        descriptionLabel!.frame = CGRect(x: 0, y: 240, width: tileView.frame.width, height: 80)
        descriptionLabel!.numberOfLines = 8
        descriptionLabel!.lineBreakMode = .ByWordWrapping
        descriptionLabel!.text = "Om de functionaliteiten optimaal te benutten is het aan te raden om in te loggen via Twitter of Facebook"
        descriptionLabel!.font = UIFont (name: "HelveticaNeue-Medium", size: 20)
        descriptionLabel!.textColor = applicationModel.UIColorFromRGB(0xcccccc)
        
        // signbutton
        signButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        signButton!.setTitle("Aanmelden zonder account", forState: UIControlState.Normal)
        signButton!.frame = CGRectMake(0, screenSize.height - 80, screenSize.width, 80)
        signButton!.addTarget(self, action: "signUpAction:", forControlEvents: UIControlEvents.TouchUpInside)
        signButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        signButton!.titleLabel?.textAlignment = NSTextAlignment.Center
        
        // signbutton
        twitterButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        twitterButton!.setTitle("Aanmelden met Twitter", forState: UIControlState.Normal)
        twitterButton!.frame = CGRectMake(0, screenSize.height - 100, screenSize.width, 50)
        twitterButton!.addTarget(self, action: "twitterAction:", forControlEvents: UIControlEvents.TouchUpInside)
        twitterButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        twitterButton!.titleLabel?.textAlignment = NSTextAlignment.Center
        twitterButton!.backgroundColor = applicationModel.UIColorFromRGB(0xd14f53)
        
        // add a holder view
        if(deviceFunctionService.deviceType == "ipad"){
            fbl.frame = CGRectMake(0, 280,  400, 50);
        }

        
        for dd in fbl.subviews
        {
            if (dd.isKindOfClass(UIButton)){
                println("button")
                
                var fbButton = dd as UIButton
                    fbButton.backgroundColor = applicationModel.UIColorFromRGB(0x4acec5)
            }
            if (dd.isKindOfClass(UILabel)){
                println("button")
                
                var uiLabel = dd as UILabel
                    uiLabel.backgroundColor = applicationModel.UIColorFromRGB(0x4acec5)
                    uiLabel.textColor = UIColor.whiteColor()
                    uiLabel.text = "Aanmelden met Facebook"
                    uiLabel.layer.shadowOpacity = 0
                    uiLabel.layer.shadowRadius = 0
                
                if(deviceFunctionService.deviceType == "ipad"){
                    uiLabel.frame = CGRectMake(0, 0,  400, 50);
                }
            }
        }
        
        
        if(deviceFunctionService.deviceType == "ipad"){
            
            tileView.frame = CGRect(x: (screenSize.width - 400)/2, y: (screenSize.height-500)/2, width: 400, height: 500)
            tileView.alpha = 0
            
            welcomeLabel!.frame = CGRect(x: 0, y: 40, width: tileView.frame.width, height: 120)
            signButton!.frame = CGRect(x: 0, y: screenSize.height - 80, width:screenSize.width, height: 80)
            twitterButton!.frame = CGRect(x: 0, y: tileView.frame.height - 150, width: tileView.frame.width, height: 50)
            descriptionLabel!.frame = CGRect(x: (screenSize.width - 500)/2, y:335, width: 500, height: 200)

            
            backgroundImage = UIImage(named: "loginBackground")
            backgroundImageView = UIImageView(frame: view.bounds)
            backgroundImageView?.image = backgroundImage
            backgroundImageView?.center = view.center
            backgroundImageView?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
            backgroundImageView?.contentMode = UIViewContentMode.ScaleAspectFill

            
            //fbl.frame = CGRect(x:(tileView.frame.width-218)/2, y: 250, width: 218, height: 50)
            
            view.addSubview(backgroundImageView!)
    
        }

        overlay = UIImageView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height-80))
        overlay!.backgroundColor = UIColor.blackColor()
        overlay!.alpha = 0.4
        
        footer = UIImageView(frame: CGRectMake(0, screenSize.height-80, screenSize.width, 80))
        footer!.backgroundColor = UIColor.blackColor()
        footer!.alpha = 0.8
        
        view.addSubview(overlay!)
        view.addSubview(footer!)
        view.addSubview(tileView)
        tileView.addSubview(welcomeLabel!)
        view.addSubview(descriptionLabel!)
        view.addSubview(signButton!)
        tileView.addSubview(twitterButton!)
        tileView.addSubview(fbl)
        
        tileView.alpha = 0
        UIView.animateWithDuration(0.8, delay: 0, options: .CurveEaseInOut, animations: {
            tileView.alpha = 1
            println("ja")
            
            return
            }, completion: { finished in
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /**
    * Facebook Login
    */
    func signUpAction(sender: AnyObject) {
        
        applicationModel.localAccount = true
        loginComplete()
    }
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        // now go to the next screen
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
        userModel = UserModel(user_id: "0", user_name: user.first_name + " " + user.last_name, user_image: "Image", user_twitterhandle: "Tweet", user_facebookid: user.objectID, user_active: "1")
        loginComplete()
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
    func twitterAction(sender: AnyObject) {
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

                        
                        self.userModel = UserModel(user_id: "0", user_name:twitterAccount.userFullName, user_image: "Image", user_twitterhandle: twitterAccount.username, user_facebookid: "", user_active: "1")

                        
                        // create user object
                        self.loginComplete()
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
        
        // Did the user use social media or just a temporary account?
        
        // Generate a temporary account
        if(applicationModel.localAccount){
            // lets generate a temporary user
            userModel = UserModel(user_id: "0", user_name: "Gebruiker", user_image: "Image", user_twitterhandle: "Tweet", user_facebookid: "FB", user_active: "1")
            
            applicationModel.defaults.setObject(true, forKey: "localAccount")
        }else{
            // add credentials to the database
            dataServices.postUserData(userModel!)
            
            // user authenticated, hide the login screen from now on
            applicationModel.defaults.setObject(false, forKey: "firstLogin")
            applicationModel.defaults.setObject(false, forKey: "localAccount")
        }
        
        // Store the model of our current user
        applicationModel.activeUser = userModel
        
        // Update default data storage
        applicationModel.defaults.synchronize()

        
        // Go the the intro screen
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

    
    /**
    * Hide status bar
    */
    override func prefersStatusBarHidden() -> Bool {
        return true
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
