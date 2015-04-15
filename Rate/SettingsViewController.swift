//
//  SettingsViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 21/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    // Data services
    let dataServices = DataManager.dataManager()
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()
    let locationServices = LocationSevices.locationServices()
    let applicationModel = ApplicationData.sharedModel()
    var eventData = Dictionary<String, String>()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    var headerBackground:UIImageView?
    var avatar:UIImageView?
    var userLabel:UILabel?
    
    var scrollView: UIScrollView?
    var signoutButton:UIButton?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = applicationModel.UIColorFromRGB(0xe9eae2)
        
        
        // UI
        headerBackground = UIImageView()
        headerBackground?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 300)
        headerBackground?.backgroundColor = applicationModel.UIColorFromRGB(0xe9eae2)
        view.addSubview(headerBackground!)
        
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 300, width: screenSize.width, height: screenSize.height - headerBackground!.frame.height))
        scrollView?.backgroundColor = applicationModel.UIColorFromRGB(0xddded6)
        view.addSubview(scrollView!)
        
        scrollView?.contentSize = CGSize(width:screenSize.width, height: screenSize.height)


        avatar = UIImageView()
        avatar?.frame = CGRect(x: (screenSize.width / 2) - (50), y: 100, width: 100, height: 100)
        avatar?.backgroundColor = UIColor.redColor()
        avatar?.layer.cornerRadius = 30
        avatar?.clipsToBounds = true
        view.addSubview(avatar!)
        
    
        userLabel = UILabel()
        userLabel?.frame = CGRect(x: 0, y: headerBackground!.frame.height - 100, width: screenSize.width, height: 100)
        userLabel?.font = UIFont (name: "HelveticaNeue-Light", size: 30)
        userLabel?.text = "Maarten Bressinck"
        userLabel?.textColor = UIColor.blackColor()
        userLabel?.textAlignment = .Center;
        view.addSubview(userLabel!)
        
        
        
        
        var yPos:CGFloat = 0
        for var index = 0; index < 3; ++index {

            var settingsListView:SettingsListViewController = SettingsListViewController()
                settingsListView.view.backgroundColor = UIColor.whiteColor()
                settingsListView.view.frame = CGRect(x: 0, y: yPos, width: screenSize.width, height: 80)
            
            switch(index){
                case 0:
                    settingsListView.infoLabel?.text = "Notificaties"
                break;
                
                case 1:
                    settingsListView.infoLabel?.text = "Facebook"
                break;
                
                case 2:
                    settingsListView.infoLabel?.text = "Twitter"
                break;
                
                default:
                    println("nope")
                break;
                
            }
            
            scrollView!.addSubview(settingsListView.view)
            
            yPos += 81
        }
        
        
        eventData["title"] = "INSTELLINGEN"
        NSNotificationCenter.defaultCenter().postNotificationName("SetTitle", object: nil, userInfo:  eventData)
        
        
        eventData["icon"] = "teaser"
        NSNotificationCenter.defaultCenter().postNotificationName("MenuIcon", object: nil, userInfo:  eventData)
        
        
        eventData["icon"] = "hidden"
        NSNotificationCenter.defaultCenter().postNotificationName("RightIcon", object: nil, userInfo:  eventData)
        
        
        signoutButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        signoutButton?.tintColor = UIColor.whiteColor()
        signoutButton!.setTitle("Afmelden", forState: UIControlState.Normal)
        signoutButton!.frame = CGRect(x: 0, y: screenSize.height - 70, width: screenSize.width, height: 70)
        signoutButton?.backgroundColor = applicationModel.UIColorFromRGB(0x5225d3)
        signoutButton!.addTarget(self, action: "signout:", forControlEvents: UIControlEvents.TouchUpInside)
        signoutButton!.titleLabel?.textAlignment = NSTextAlignment.Left;
        view.addSubview(signoutButton!)
    }
    
    
    
    func signout(sender:UIButton!)
    {
            applicationModel.localAccount = false
            applicationModel.activeUser = nil
            
            var theFBSession = FBSession.activeSession()
            var check = FBSession.closeAndClearTokenInformation(theFBSession)
            println(theFBSession.closeAndClearTokenInformation())
            
            // Reset NSdata settings
            applicationModel.defaults.setObject(true, forKey: "firstLogin")
            applicationModel.defaults.setObject(false, forKey: "localAccount")
            
            
            // go back to the initial screen
            eventData["menu"] = "sign"
            
            NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
            self.dismissViewControllerAnimated(false, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
    * Hide status bar
    */
    /*
    override func prefersStatusBarHidden() -> Bool {
        return true
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
