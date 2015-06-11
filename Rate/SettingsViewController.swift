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
        headerBackground?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 270)
        headerBackground?.backgroundColor = applicationModel.UIColorFromRGB(0xe9eae2)
        view.addSubview(headerBackground!)
        
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 270, width: screenSize.width, height: screenSize.height - headerBackground!.frame.height))
        scrollView?.backgroundColor = applicationModel.UIColorFromRGB(0xddded6)
        scrollView?.contentSize = CGSize(width:screenSize.width, height: 600)

        view.addSubview(scrollView!)
        

        avatar = UIImageView()
        avatar?.frame = CGRect(x: (screenSize.width / 2) - (50), y: 100, width: 100, height: 100)
        avatar?.backgroundColor = UIColor.blackColor()
        avatar?.layer.cornerRadius = 50
        avatar?.clipsToBounds = true
        avatar?.layer.borderWidth = 2
        avatar?.layer.borderColor = applicationModel.UIColorFromRGB(0x868875).CGColor
        
        view.addSubview(avatar!)
        
    
        userLabel = UILabel()
        userLabel?.frame = CGRect(x: 0, y: headerBackground!.frame.height - 90, width: screenSize.width, height: 100)
        userLabel?.font = UIFont (name: "HelveticaNeue-Light", size: 28)
        userLabel?.text = "Anonieme Gebruiker"
        userLabel?.textColor = UIColor.blackColor()
        userLabel?.textAlignment = .Center;
        view.addSubview(userLabel!)
        
        
        var infoLine:UIView = UIView()
        infoLine.frame = CGRect(x: 0, y: 270, width: screenSize.width, height: 1)
        infoLine.backgroundColor = applicationModel.UIColorFromRGB(0xbdbeb8)
        view.addSubview(infoLine)

        
        var yPos:CGFloat = 0
        for var index = 0; index < 3; ++index {
            

            var switchView:UIViewController = UIViewController()
                switchView.view.frame =  CGRect(x: 0, y: yPos, width: screenSize.width, height: 96)
                switchView.view.backgroundColor = applicationModel.UIColorFromRGB(0xf2f3eb)
                scrollView!.addSubview(switchView.view)
                addChildViewController(switchView)
            
            var sw:UISwitch = UISwitch()
                sw.center = view.center
                sw.frame = CGRect(x: screenSize.width - sw.frame.width - 20, y:  yPos + 30, width: screenSize.width, height: 30)
                sw.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
            
            scrollView!.addSubview(sw)
            
            var infoLabel:UILabel = UILabel()
                infoLabel.frame = CGRect(x: 20, y: 18, width: screenSize.width - 80, height: 40)
                infoLabel.font = UIFont (name: "Avenir-Book", size: 22)
                switchView.view.addSubview(infoLabel)
            
            var infoSub:UILabel = UILabel()
            infoSub.frame = CGRect(x: 20, y: 40, width: screenSize.width - 80, height: 50)
            infoSub.font = UIFont (name: "Avenir-Book", size: 14)
            infoSub.numberOfLines = 2
            switchView.view.addSubview(infoSub)
            
            
            var infoLine:UIView = UIView()
                infoLine.frame = CGRect(x: 0, y: 96, width: screenSize.width, height: 1)
                infoLine.backgroundColor = applicationModel.UIColorFromRGB(0xbdbeb8)
                switchView.view.addSubview(infoLine)
            
            
            //  settingsListView.create()
            switch(index){
                case 0:
                    infoLabel.text = "Notificaties"
                    infoSub.text = "Ontvang status berichten"
                    
                    if(applicationModel.pushEnabled == true){
                        sw.setOn(true, animated: false)
                    }
                    
                    sw.tag = 0
                break;
                
                case 1:
                    infoLabel.text = "Facebook"
                    infoSub.text = "Deel mijn data op Facebook"
                    
                    if(applicationModel.facebookEnabled == true){
                        sw.setOn(true, animated: false)
                    }
                    
                    sw.tag = 1
                break;
                
                case 2:
                    infoLabel.text = "iBeacons"
                    infoSub.text = "Gebruik iBeacon navigatie"
                    
                    if(applicationModel.iBeaconEnabled == true){
                        sw.setOn(true, animated: false)
                    }
                    
                    sw.tag = 2
                    break;
                
                default:
                    println("nope")
                break;
                
            }
            
            //scrollView!.addSubview(settingsListView.view)
            
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
        
        
        var avatarImage = UIImage(named: "avatar")
        avatar?.image = avatarImage
        avatar?.contentMode = .ScaleAspectFit

        
        // dynamic data?
        println(applicationModel.activeUser?.user_image)
        
        if(applicationModel.activeUser != nil){
            
            println("we hebben een actieve gebruiker")
        
            if(applicationModel.activeUser?.user_id != "0"){
            
                
                let request: NSURLRequest = NSURLRequest(URL: NSURL(string: applicationModel.activeUser!.user_image)!)
                let mainQueue = NSOperationQueue.mainQueue()
                NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                    if error == nil {
                        // Convert the downloaded data in to a UIImage object
                        let image = UIImage(data: data)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            // add cover image
                            self.avatar?.image = UIImage(data: data!)
                            self.avatar?.contentMode = .ScaleAspectFit
                        })
                    }
                    else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
                
                userLabel!.text = applicationModel.activeUser!.user_name
                
            }
        }else{
        
        }
    }
    
    func stateChanged(switchState: UISwitch) {
        switch(switchState.tag){
            case 0:
                println("case")
                
                if switchState.on {
                    applicationModel.pushEnabled = true
                } else {
                    applicationModel.pushEnabled = false
                }
                
                applicationModel.defaults.setObject(applicationModel.pushEnabled, forKey: "pushEnabled")

                
            break;
            
            case 1:
            
                if switchState.on {
                    applicationModel.facebookEnabled = true
                } else {
                    applicationModel.facebookEnabled = false
                }
                
                applicationModel.defaults.setObject(applicationModel.facebookEnabled, forKey: "facebookEnabled")

                
            break;
            
            case 2:
            
                if switchState.on {
                    applicationModel.iBeaconEnabled = true
                } else {
                    applicationModel.iBeaconEnabled = false
                }
                
                applicationModel.defaults.setObject(applicationModel.iBeaconEnabled , forKey: "iBeaconEnabled")

            break;
            
            default:
                println("niets")
            break;
        }
        
        

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
