//
//  SignOnScreenViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 21/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit
import Accounts
import Social

class SignOnScreenViewController: UIViewController, FBLoginViewDelegate, FBSDKLoginButtonDelegate {

    //var swifter: Swifter
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
    
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    private var currentAccessToken: String!

    
    // Effects
    var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
    
    var userModel:UserModel?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
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
       self.fbl.readPermissions = ["email", "public_profile"]
        
        // update the interface
        createUI()
        
        SwiftSpinner.hide()
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            currentAccessToken = self.returnFacebookAccessToken()
            println("\(currentAccessToken)")
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil) {
            println("Error")
        }
        else if result.isCancelled {
            println("Cancel")
        }
        else {
            println("User Logged In")
            currentAccessToken = self.returnFacebookAccessToken()
            println("\(currentAccessToken)")
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    func returnFacebookAccessToken() -> String {
        return FBSDKAccessToken.currentAccessToken().tokenString
    }
    
    func goToStoryStoryboard() {

    }


    func createUI(){

        NSNotificationCenter.defaultCenter().postNotificationName("HideBar", object: nil, userInfo:  nil)
        
        var tileView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        
        // description
        welcomeLabel = UILabel()
        welcomeLabel!.frame = CGRect(x: 0, y: 100, width: tileView.frame.width, height: 120)
        welcomeLabel!.numberOfLines = 1
        welcomeLabel!.lineBreakMode = .ByWordWrapping
        welcomeLabel!.text = "Welkom"
        welcomeLabel!.font =  UIFont (name: "AvenirNext-DemiBold", size: 50)
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
        }else{
            fbl.frame = CGRectMake(0, screenSize.height - 240,  screenSize.width, 80);
        }

        var facebookLabel:UILabel = UILabel()

        for dd in fbl.subviews
        {
            if (dd.isKindOfClass(UIButton)){
                println("button")
                
                var fbButton = dd as! UIButton
                    fbButton.backgroundColor = applicationModel.UIColorFromRGB(0x4acec5)
            }
            if (dd.isKindOfClass(UILabel)){
                println("button")
                
                var uiLabel = dd as! UILabel
                    uiLabel.backgroundColor = applicationModel.UIColorFromRGB(0x4acec5)
                    uiLabel.textColor = UIColor.whiteColor()
                    uiLabel.text = ""
                    uiLabel.layer.shadowOpacity = 0
                    uiLabel.layer.shadowRadius = 0
                
                
                    facebookLabel.backgroundColor = applicationModel.UIColorFromRGB(0x4acec5)
                    facebookLabel.textColor = UIColor.whiteColor()
                    facebookLabel.text = "Aanmelden met Facebook"
                    facebookLabel.textAlignment = NSTextAlignment.Center
                    facebookLabel.userInteractionEnabled = false
                
                if(deviceFunctionService.deviceType == "ipad"){
                    uiLabel.frame = CGRectMake(0, 0,  400, 50);
                }else{
                    uiLabel.frame = CGRectMake(0, 0,  screenSize.width, 80);
                }
                
            }
        }
        

        
        
        backgroundImage = UIImage(named: "loginBackground")
        backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView?.image = backgroundImage
        backgroundImageView?.center = view.center
        backgroundImageView?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        backgroundImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        if(deviceFunctionService.deviceType == "ipad"){
            
            tileView.frame = CGRect(x: (screenSize.width - 400)/2, y: (screenSize.height-500)/2, width: 400, height: 500)
            tileView.alpha = 0
            
            welcomeLabel!.frame = CGRect(x: 0, y: 40, width: tileView.frame.width, height: 120)
            signButton!.frame = CGRect(x: 0, y: screenSize.height - 80, width:screenSize.width, height: 80)
            twitterButton!.frame = CGRect(x: 0, y: tileView.frame.height - 150, width: tileView.frame.width, height: 50)
            descriptionLabel!.frame = CGRect(x: (screenSize.width - 500)/2, y:335, width: 500, height: 200)
            facebookLabel.frame = CGRectMake(0, 280,  400, 50);

        }else{
            signButton!.frame = CGRect(x: 0, y: screenSize.height - 80, width:screenSize.width, height: 80)
            
            twitterButton!.frame = CGRect(x: 0, y: screenSize.height - 160, width: screenSize.width, height: 80)
            
            descriptionLabel!.frame = CGRect(x: 0, y:welcomeLabel!.frame.origin.y + 60, width: screenSize.width, height: 140)

            descriptionLabel!.textAlignment = NSTextAlignment.Center
            facebookLabel.frame = CGRectMake(0, screenSize.height - 240,  screenSize.width, 80);


        }
        
        view.addSubview(backgroundImageView!)

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
        tileView.addSubview(facebookLabel)

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
        var user_email:String = ""
        var user_id:String = ""
        
        FBRequestConnection.startForMeWithCompletionHandler { (connection, user, error) -> Void in
            if (error == nil){

                if let id = user.objectForKey("id") as? String {
                    // If we get here, we know "id" exists in the dictionary, and we know that we
                    // got the type right.
                    user_id = id
                }
                
                if let email = user.objectForKey("email") as? String {
                    // If we get here, we know "id" exists in the dictionary, and we know that we
                    // got the type right.
                    user_email = email
                }
                

                
                // save in the userModel
                self.userModel = UserModel(user_id: user_id, user_name: user.first_name + " " + user.last_name, user_image: "https://graph.facebook.com/" + user_id + "/picture?type=large" , user_twitterhandle: "Tweet", user_facebookid: user_id, user_active: "1")
                
                
                self.loginComplete()
            }
        }
        
        println("fetched stuff")
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    func handleError(loginView: FBLoginView?, error: NSError?) {
        var alertTitle: NSString?
        var alertMessage: NSString?
        // You need to override loginView:handleError in order to handle possible errors that can occur during login
        
        if (FBErrorUtility.shouldNotifyUserForError(error)) {
            alertTitle = "Facebook error"
            alertMessage = FBErrorUtility.userMessageForError(error)
            
        } else if (FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.AuthenticationReopenSession) {
            
            alertTitle = "Session Error"
            alertMessage = "Your current session is no longer valid. Please log in again."
            
            // If the user has cancelled a login, we will do nothing.
            // You can also choose to show the user a message if cancelling login will result in
            // the user not being able to complete a task they had initiated in your app
            // (like accessing FB-stored information or posting to Facebook)
        } else if (FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.UserCancelled) {
            NSLog("user cancelled login")
            
            // For simplicity, this sample handles other errors with a generic message
            // You can checkout our error handling guide for more detailed information
            // https://developers.facebook.com/docs/ios/errors
        } else {
            alertTitle  = "Something went wrong"
            alertMessage = "Please try again later."
            NSLog("Unexpected error:%@", error!)
        }
        

        
    }



    /**
    * Twitter Login
    */
    func twitterAction(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Opgelet", message:
            "Twitter is momenteel niet beschikbaar, probeer aan te melden via Facebook of meld aan zonder account", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Sluit", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    
    /**
    * Login complete handler
    */
    func loginComplete(){
        
        // Did the user use social media or just a temporary account?
        
        // Generate a temporary account
        if(applicationModel.localAccount){
            // lets generate a temporary user
            userModel = UserModel(user_id: "0", user_name: "Gebruiker", user_image: "Image", user_twitterhandle: "Tweet", user_facebookid: "0", user_active: "1")
            
            applicationModel.defaults.setObject(true, forKey: "localAccount")
        }else{
            // add credentials to the database
            //dataServices.postUserData(userModel!)
            
            // user authenticated, hide the login screen from now on
            applicationModel.defaults.setObject(false, forKey: "firstLogin")
            applicationModel.defaults.setObject(false, forKey: "localAccount")
            
            applicationModel.defaults.setObject(userModel?.user_name, forKey: "user_name")
            applicationModel.defaults.setObject(userModel?.user_image, forKey: "user_image")
            applicationModel.defaults.setObject(userModel?.user_id, forKey: "user_id")
            applicationModel.defaults.setObject(userModel?.user_facebookid, forKey: "user_id")

            
        }
        
        // Store the model of our current user
        applicationModel.activeUser = userModel

        
        
        // Update default data storage
        applicationModel.defaults.synchronize()

        
        visualEffectView.alpha = 0
        visualEffectView.frame = view.bounds
        view.addSubview(visualEffectView)
        
        println("next screen")
        
        
        UIView.animateWithDuration(0.5, delay: 0, options: nil, animations: {
            // Place the UIViews we want to animate here (use x, y, width, height, alpha)
            self.visualEffectView.alpha = 1
            
            return
            }, completion: { finished in
                // the animation is complete
                
                // Go the the intro screen
                self.eventData["menu"] = "teaser"
                NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  self.eventData)
                self.dismissViewControllerAnimated(false, completion: nil)
                self.visualEffectView.removeFromSuperview()
        })

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
