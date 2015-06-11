//
//  ViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 19/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//
import CoreLocation
import UIKit
import CoreData
import CoreBluetooth


class MainController: UIViewController, CLLocationManagerDelegate, UIPageViewControllerDelegate, UIScrollViewDelegate, CBPeripheralManagerDelegate {
    
    // Class specific data
    var firstRun:Bool = true
    var eventData = Dictionary<String, String>()
    var current:UIViewController?
    var currentMenu:UIViewController?
    var helpCreated:Bool = false
    
    // Data services
    let dataServices = DataManager.dataManager()
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()
    let locationServices = LocationSevices.locationServices()
    let applicationModel = ApplicationData.sharedModel()

    // Screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // Views
    var exhibitViewController:ExhibitViewController?
    var helpViewController:HelpViewController?
    var teaserViewController:TeaserViewController?
    var favouritesViewController:FavouritesViewController?
    var settingsViewController:SettingsViewController?
    var signOnViewController:SignOnScreenViewController?
    var welcomeViewController:WelcomeViewController?
    var loadingViewControler:LoadingViewController?
    var museumOverviewController:MuseumOverviewViewController?
    var menuViewController:UIViewController?
    var connectionFound = false
    var targetController:UIViewController?
    var map:DIrectionsOverlayViewController?

    var manager: CBPeripheralManager?
    var socialOverview:UIScrollView?
    var socialOverviewCreated:Bool = false
    var mediaOverview:UIScrollView?
    var medialOverviewCreated:Bool = false

    var helpPopup:UIView?
    var helpOverlay:UIView?
    var imagePicker: UIImagePickerController!
    var commentViewController:CommentsPanellViewController?

    
    // Effects
    var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.manager = CBPeripheralManager()

        
        // detect our device type
        deviceFunctionService.detectDevice()
        
        // get locally stored data
        applicationModel.getStoredData()
        
        //initiate viewControllers
        helpViewController = HelpViewController(nibName: "HelpViewController", bundle: nil)
        exhibitViewController = ExhibitViewController(nibName: "ExhibitViewController", bundle: nil)
        favouritesViewController = FavouritesViewController(nibName: "FavouritesViewController", bundle: nil)
        signOnViewController = SignOnScreenViewController(nibName: "SignOnScreenViewController", bundle: nil)
        loadingViewControler = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        map = DIrectionsOverlayViewController(nibName: "DIrectionsOverlayViewController", bundle: nil)
        welcomeViewController = WelcomeViewController(nibName: "WelcomeViewController", bundle: nil)

        
        // show loading screen
        navigationController?.pushViewController(loadingViewControler!, animated: false)
        
        // Check connection in a timed function
        var dataTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("checkDataConnection"), userInfo: nil, repeats: true)
        
        var nearestMuseumTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: Selector("cheackNearestMuseum"), userInfo: nil, repeats: true)
        
        // Bind custom events to handle page flow from this controller
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuChangedHandler:", name:"MenuChangedHandler", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMenu:", name:"ShowMenuHandler", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeMenu:", name:"CloseMenuFromNavigation", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "museumFoundHandler:", name:"MuseumFound", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "helpPopupHandler:", name:"ShowHelpPopup", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeHelpPopupHandler:", name:"CloseHelpPopup", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMapPopupHandler:", name:"ShowMapPopup", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeMapView:", name:"CloseNavigationView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "errorDialog:", name:"ErrorDialog", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "socialPopupToggle:", name:"SocialPopup", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "mediaPopupToggle:", name:"MediaPopup", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showHelpCarousel:", name:"ShowHelpCarousel", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "socialCameraToggle:", name:"SocialCamera", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openCommentPanel:", name:"OpenCommentPanel", object: nil)

        
        
        // get locationServices
        locationServices.initLocationServices()
        
        
        self.manager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func socialCameraToggle(ns:NSNotification){
        
        
        // camera
        imagePicker =  UIImagePickerController()
        imagePicker.sourceType = .Camera
        targetController!.view.addSubview(imagePicker.view)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {

        imagePicker.removeFromParentViewController()
        imagePicker.view.removeFromSuperview()
    }
    
    

    func socialPopupToggle(ns:NSNotification){
        
        if(socialOverviewCreated == false){
        
            socialOverview = UIScrollView()
            socialOverview!.frame = CGRect(x: 0, y: 64, width: screenSize.width, height: screenSize.height)
            //184
            socialOverview!.backgroundColor = UIColor(white: 1, alpha: 0.9)
            socialOverview!.alpha = 0
            socialOverviewCreated = true

            targetController!.view.addSubview(socialOverview!)

            // now add the selectedItem
            var socialItem:SocialGridItemViewController = SocialGridItemViewController()
                socialItem.socialModel = applicationModel.activeSocialItem
               //socialItem.view.layer.transform = CATransform3DConcat(CATransform3DMakeScale(0.8, 0.8, 0.8),  CATransform3DMakeRotation(45 * CGFloat(M_PI/180), 0, 0, 1))
                socialItem.view.frame = CGRect(x: 190, y: 200, width: screenSize.width / 2, height: screenSize.width / 2)
                socialItem.view.backgroundColor = applicationModel.activeSocialItemColor
                socialItem.itemWidth = screenSize.width / 2
                socialItem.itemHeight = screenSize.height / 2
                socialOverview!.addSubview(socialItem.view)
            
            let image = UIImage(named: "close-white") as UIImage?
            var socialClose:UIButton = UIButton()
                socialClose.frame = CGRect(x: socialItem.view.frame.origin.x + socialItem.view.frame.width - 190, y: socialItem.view.frame.origin.y - 40, width: 50, height: 50)
                socialClose.backgroundColor = applicationModel.UIColorFromRGB(0x4d28b3)
                //socialClose.layer.transform = CATransform3DConcat(CATransform3DMakeScale(1, 1, 1),  CATransform3DMakeRotation(45 * CGFloat(M_PI/180), 0, 0, 1))
                socialClose.addTarget(self, action: "socialClose:", forControlEvents: UIControlEvents.TouchUpInside)
                socialClose.setImage(image, forState: .Normal)

            
            
            if(deviceFunctionService.deviceType != "ipad"){
                socialItem.view.frame = CGRect(x: 20, y: 20, width: screenSize.width - 40, height: screenSize.height - 110)
                socialItem.itemWidth = screenSize.width - 40
                socialItem.itemHeight = screenSize.height - 110
                
                socialClose.frame = CGRect(x:screenSize.width - 70, y: 20, width: 50, height: 50)
                
                if(helpPopup != nil){
                    helpPopup!.frame = CGRect(x: screenSize.width - 20 , y: 76, width: screenSize.width - 40, height: screenSize.height - 76)
                }
            }
            
            
            socialItem.createFullView()
            socialOverview!.addSubview(socialClose)
            
            UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
                self.socialOverview!.alpha = 1
                
                return
                }, completion: { finished in
            })
            socialOverviewCreated = true
            
            
        }else{
    
            UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
                self.socialOverview!.alpha = 0
                
                return
                }, completion: { finished in
                    
                self.socialOverview!.removeFromSuperview()
                self.socialOverviewCreated = false
                self.applicationModel.socialPopup = false
            })
        }
    }
    
    
    func socialClose(sender:UIButton){
        NSNotificationCenter.defaultCenter().postNotificationName("SocialPopup", object: nil, userInfo:  nil)
    }
    
    
    func mediaClose(sender:UIButton){
        NSNotificationCenter.defaultCenter().postNotificationName("MediaPopup", object: nil, userInfo:  nil)
    }
    
    
    func mediaPopupToggle(ns:NSNotification){
        
        if(medialOverviewCreated == false){
            
            mediaOverview = UIScrollView()
            mediaOverview!.frame = CGRect(x: 0, y: 64, width: screenSize.width, height: screenSize.height)
            mediaOverview!.backgroundColor = UIColor(white: 1, alpha: 0.9)
            mediaOverview!.alpha = 0
            medialOverviewCreated = true
            targetController!.view.addSubview(mediaOverview!)
            
            
            // now add the selectedItem
            var mediaItem:MediaTileViewController = MediaTileViewController()
                mediaItem.mediaModel = applicationModel.activeMediaItem
                mediaItem.view.frame = CGRect(x: 190, y: 200, width: screenSize.width / 2, height: screenSize.width / 2)
                mediaItem.view.backgroundColor = applicationModel.activeSocialItemColor
                mediaItem.viewWidth = Int(screenSize.width / 2)
                mediaItem.viewHeight = Int(screenSize.height / 2)
                mediaOverview!.addSubview(mediaItem.view)
                mediaItem.createView()
            
            var mediaClose:UIButton = UIButton()
                mediaClose.frame = CGRect(x: mediaItem.view.frame.origin.x + mediaItem.view.frame.width - 30 , y: mediaItem.view.frame.origin.y - 70, width: 50, height: 50)
                mediaClose.backgroundColor = applicationModel.UIColorFromRGB(0x653dc9)
                mediaClose.addTarget(self, action: "mediaClose:", forControlEvents: UIControlEvents.TouchUpInside)
            
            let image = UIImage(named: "close-white") as UIImage?
                mediaClose.setImage(image, forState: .Normal)

            
            if(mediaItem.mediaModel!.mercury_room_media_type == "video"){
                mediaItem.player?.playFromBeginning()
            }
            
            
            if(deviceFunctionService.deviceType != "ipad"){
                
                mediaItem.view.frame = CGRect(x: 20, y: 42, width: screenSize.width - 40, height: screenSize.height - 100)
                mediaClose.frame = CGRect(x: screenSize.width - 70 , y: 18, width: 50, height: 50)
            }
            

            mediaOverview!.addSubview(mediaClose)

            
            UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
                self.mediaOverview!.alpha = 1
                
                return
                }, completion: { finished in
            })
            
            medialOverviewCreated = true
            
            
        }else{
            
            UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
                self.mediaOverview!.alpha = 0
                
                return
                }, completion: { finished in
                    
                    self.mediaOverview!.removeFromSuperview()
                    self.medialOverviewCreated = false
                    self.applicationModel.mediaPopup = false
            })
        }

    }
    
    

    func errorDialog(ns:NSNotification){

        
        var errorMessage:String = ""
        if let info = ns.userInfo {
            errorMessage =  info["errorString"] as! String
        }
        
        var alert = UIAlertController(title: "Fout", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Sluit", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    /**
    * Detect bluetooth
    */
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        
        if peripheral.state == CBPeripheralManagerState.PoweredOn {
            println("bluetooth")
            applicationModel.bluetooth = true
            
        NSNotificationCenter.defaultCenter().postNotificationName("BluetoothOnline", object: nil, userInfo:  nil)

        }
        else if peripheral.state == CBPeripheralManagerState.PoweredOff {
           // self.manager.stopAdvertising()
            applicationModel.bluetooth = false
            
            NSNotificationCenter.defaultCenter().postNotificationName("BluetoothOffline", object: nil, userInfo:  nil)
            
            eventData["menu"] = "error"
            NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
        }
    }
    
    
    /**
    * Beacons have found a museum
    */
    func museumFoundHandler(notification: NSNotification){
        
        if(applicationModel.pushEnabled){
        
            // show info to the user
            let notification = UILocalNotification()
        
            /* Time and timezone settings */
            notification.fireDate = NSDate(timeIntervalSinceNow: 10.0)
            notification.timeZone = NSCalendar.currentCalendar().timeZone
            notification.alertBody = "Je bent nu in de buurt van " + self.applicationModel.nearestMuseum!.museum_title
        
            /* Action settings */
            notification.hasAction = true
            notification.alertAction = "View"
        
            /* Schedule the notification */
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
    
        }
    }

    
    /**
    * Handle navigation
    */
    func menuChangedHandler(notification: NSNotification){
        var createViewController:Bool = false
        var initialSetup:Bool = false
        
        if let info = notification.userInfo {
            println(notification.userInfo)
            
            if((info["menu"] as! String) != "error"){
                applicationModel.lastPage = info["menu"] as? String
            }
            
            if(applicationModel.currentTarget != info["menu"] as? String){
            if(targetController == exhibitViewController){
                exhibitViewController?.removeFromParentViewController()
                exhibitViewController?.view.removeFromSuperview()
                exhibitViewController!.dismissViewControllerAnimated(true, completion: {});

            }
                
            var myTarget: String = (info["menu"] as! String)
            applicationModel.currentTarget = myTarget
                
            applicationModel.localExhibitSelected = false;

            var isPopup:Bool = false
            switch myTarget
            {
                case "teaser":
                    teaserViewController = TeaserViewController(nibName: "TeaserViewController", bundle: nil)
                    targetController = teaserViewController
                    locationServices.getNearestMuseum()
                    applicationModel.localExhibitSelected = false
                
                    eventData["icon"] = "help"
                    NSNotificationCenter.defaultCenter().postNotificationName("MenuIcon", object: nil, userInfo:  eventData)

                    eventData["icon"] = "settings"
                    NSNotificationCenter.defaultCenter().postNotificationName("RightIcon", object: nil, userInfo:  eventData)


                    println("pusing teaser");
                
                
                case "overview":
                    
                    museumOverviewController = MuseumOverviewViewController(nibName: "MuseumOverviewViewController", bundle: nil)

                    targetController = museumOverviewController
                    applicationModel.localExhibitSelected = false
                
                    eventData["icon"] = "teaser"
                    NSNotificationCenter.defaultCenter().postNotificationName("MenuIcon", object: nil, userInfo:  eventData)
                
                    eventData["icon"] = "beacons"
                    NSNotificationCenter.defaultCenter().postNotificationName("RightIcon", object: nil, userInfo:  eventData)
                
                
                case "exhibit":
                    exhibitViewController = ExhibitViewController(nibName: "ExhibitViewController", bundle: nil)

                    targetController = exhibitViewController
                    
                    eventData["icon"] = "exhibitGrid"
                    NSNotificationCenter.defaultCenter().postNotificationName("RightIcon", object: nil, userInfo:  eventData)
                
                    eventData["icon"] = "exhibit"
                    NSNotificationCenter.defaultCenter().postNotificationName("MenuIcon", object: nil, userInfo:  eventData)
                
                    applicationModel.localExhibitSelected = true;
                
                case "favourites":
                    targetController = favouritesViewController
        
                case "settings":
                    settingsViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
                    targetController = settingsViewController
                
                case "error":
                    
                NSNotificationCenter.defaultCenter().postNotificationName("HideBar", object: nil, userInfo:  nil)

                    targetController = welcomeViewController
                
                case "sign":
                    targetController = signOnViewController
                    NSNotificationCenter.defaultCenter().postNotificationName("HideBar", object: nil, userInfo:  nil)

                    initialSetup = true
                default:
                    println("none")
            }
            
                for (index, viewController) in enumerate(navigationController!.viewControllers) {
                    if(targetController == viewController as? UIViewController){
                        createViewController = true
                    }
                }
                
            var tar = targetController?.view
            if(!createViewController){
                navigationController?.pushViewController(targetController!, animated: false)
                
            }else{
                navigationController?.popToViewController(targetController!, animated: false)
            }

                

            /**
            * Animation: Position the content
            */
            var yPos = screenSize.height - 212
            tar?.frame = CGRect(x: 0, y: +self.screenSize.height-yPos, width: screenSize.width, height: screenSize.height)
            tar?.alpha = 0.5

            /**
            * Animation: Scroll the content frame up
            */
            
            // outro to go back to the intro screen
            if(initialSetup){
                
                UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
                    tar?.frame = CGRect(x:0, y:0, width:self.screenSize.width, height:self.screenSize.height)
                    tar?.alpha = 1
                    return
                    }, completion: { finished in
                        self.menuViewController?.removeFromParentViewController()
                        self.menuViewController?.view.removeFromSuperview()
                })
                
            NSNotificationCenter.defaultCenter().postNotificationName("ShowMenuButton", object: nil, userInfo:  nil)

            }else{
            
                UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
                    tar?.frame = CGRect(x:0, y:0, width:self.screenSize.width, height:self.screenSize.height)
                    tar?.alpha = 1
                    return
                    }, completion: { finished in
                        self.menuViewController?.removeFromParentViewController()
                        self.menuViewController?.view.removeFromSuperview()
                })
            
            NSNotificationCenter.defaultCenter().postNotificationName("ShowMenuButton", object: nil, userInfo:  nil)
            }
            
            }
            
        } else {
            println("no valid data")
        }
    }
    
    
    /** 
    * Show help popup
    */
    func showHelpCarousel(notification:NSNotification){
        
        // show help stuff
            helpOverlay = UIView()
            helpOverlay!.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
            helpOverlay!.backgroundColor = UIColor.blackColor()
            helpOverlay!.alpha = 0.4
            targetController!.view.addSubview(helpOverlay!)
        
        
            helpPopup = UIView()
            helpPopup!.alpha = 0.5
            helpPopup!.backgroundColor = UIColor.whiteColor()
            helpPopup!.frame = CGRect(x: (screenSize.width/2) - (280) , y: (screenSize.height/2) - (200), width: 560, height: 400)
        
        if(deviceFunctionService.deviceType != "ipad"){
        
            helpPopup!.frame = CGRect(x: 20 , y: 76, width: screenSize.width - 40, height: screenSize.height - 76)
        }
    
        var helpLabel = UILabel(frame: CGRect(x: 0, y: 40, width: helpPopup!.frame.width, height: 30))
        helpLabel.numberOfLines = 0
        helpLabel.lineBreakMode = .ByWordWrapping
        helpLabel.text = "DEZE APP GEBRUIKEN"
        helpLabel.font =  UIFont (name: "AvenirNext-DemiBold", size: 18)
        helpLabel.textColor = applicationModel.UIColorFromRGB(0x838383)
        helpLabel.textAlignment = NSTextAlignment.Center
        helpPopup!.addSubview(helpLabel)

        targetController!.view.addSubview(helpPopup!)
        
        var closeIcon:UIImage = UIImage(named: "close-icon")!
        var helpPopupClose:UIButton = UIButton()
            helpPopupClose.frame = CGRect(x: 510, y: 0, width: 50, height: 50)
            helpPopupClose.backgroundColor = UIColor.clearColor()
            helpPopupClose.addTarget(self, action: "helpClose:", forControlEvents: UIControlEvents.TouchUpInside)
            helpPopupClose.setImage(closeIcon, forState: UIControlState.Normal)
    
            helpPopup!.addSubview(helpPopupClose)
        
        
        
        if(deviceFunctionService.deviceType != "ipad"){
            
            helpPopupClose.frame = CGRect(x: helpPopup!.frame.width - 50, y: 0, width: 50, height: 50)
        }
        
        UIView.animateWithDuration(0.4, delay: 0.2, options: nil, animations: {
            
            self.helpOverlay!.alpha = 0.8
            
            return
            }, completion: { finished in
                
                return
        })
        
        
        UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {

            self.helpPopup!.alpha = 1
            
            return
            }, completion: { finished in
                
                return
        })
        
        
    }
    
    
    /**
    * Closing the help
    */
    func helpClose(sender:UIButton){
        
        helpPopup?.removeFromSuperview()
        helpOverlay?.removeFromSuperview()
    
    }
    
    
    func showMapPopupHandler(notification:NSNotification){
        
        visualEffectView.frame = view.bounds
        targetController?.view.addSubview(visualEffectView)
        
        // dispatch event
        
        map = DIrectionsOverlayViewController(nibName: "DIrectionsOverlayViewController", bundle: nil)
        map?.view.frame = CGRect(x: 5, y: 70, width: screenSize.width - 10, height: screenSize.height-77)
        
        map!.view.layer.shadowColor = UIColor.blackColor().CGColor
        map!.view.layer.shadowOffset = CGSizeMake(5, 5)
        map!.view.layer.shadowRadius = 5
        
        targetController!.addChildViewController(map!)
        targetController!.view.addSubview(map!.view)
        
        map!.view.frame = CGRect(x: 5, y: screenSize.height, width: screenSize.width - 10, height: screenSize.height-77)

        UIView.animateWithDuration(0.3, delay: 0, options: nil, animations: {
            self.map!.view.frame = CGRect(x: 5, y: 70, width: self.screenSize.width - 10, height: self.screenSize.height-77)
            
            return
            }, completion: { finished in

        })
        
    }

    
    func closeMapView(notification:NSNotification){
        map?.view.removeFromSuperview()
        map?.removeFromParentViewController()
        visualEffectView.removeFromSuperview()
    }
    
    
    /**
    * Show the het  function
    */
    func helpPopupHandler(notification:NSNotification){
        
        if(!helpCreated){
            helpCreated = true
            visualEffectView.frame = view.bounds
            targetController?.view.addSubview(visualEffectView)
            targetController!.view.addSubview(helpViewController!.view)
            
            helpViewController?.view.frame = CGRect(x: (screenSize.width-helpViewController!.view.frame.width)/2, y: (screenSize.height-helpViewController!.view.frame.height)/2, width: helpViewController!.view.frame.width, height: helpViewController!.view.frame.height)
        
            targetController!.addChildViewController(helpViewController!)
        }else{
            helpViewController?.view.removeFromSuperview()
            helpViewController?.removeFromParentViewController()
            visualEffectView.removeFromSuperview()
            
            helpCreated = false
        }
    }
    
    /**
    * Close the help popup
    */
    func closeHelpPopupHandler(notification:NSNotification){
        helpViewController?.view.removeFromSuperview()
        helpViewController?.removeFromParentViewController()
        visualEffectView.removeFromSuperview()
    }
    
    
    /**
    * Animation: Scroll the content frame down when opening the menu
    */
    func showMenu(notification: NSNotification){
        
        var myView = targetController?.view
        var yPos = screenSize.height - 212

        UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
            myView?.frame = CGRect(x:0, y:+self.screenSize.height-yPos, width:self.screenSize.width, height:self.screenSize.height)
            myView?.alpha = 0.5
            return
        }, completion: { finished in

            return
        })
    }
    
    
    /**
    * Animation: Bring the target frame back up
    */
    func closeMenu(notification:NSNotification){
        var myView = targetController?.view
        
        UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
            myView?.frame = CGRect(x:0, y:0, width:self.screenSize.width, height:self.screenSize.height)
            myView?.alpha = 1
            return
            }, completion: { finished in

        })
    }
    
    
    /**
    * Show alerts
    */
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    
    func locationPermission(ns:NSNotification){
    /*    println("ja")
        
        var alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)*/
    }
    
    
    /**
    * Check network connection
    */
    func checkDataConnection(){
        
        //println("local data")
        //println(applicationModel.firstLogin)
        
        // first check if we have a connection
        if Reachability.isConnectedToNetwork() {
            applicationModel.networkConnection = true
        NSNotificationCenter.defaultCenter().postNotificationName("DataConnectionOnline", object: nil, userInfo:  nil)

            if(!connectionFound){
                connectionFound = true
                
                // load data
                dataServices.loadData()
            }
            
            // show views once data has loaded
            if(dataServices.dataLoaded && firstRun){
                
                // toggle the first run
                firstRun = false
                
                if(applicationModel.firstLogin == true){
                    
                    println("pushing signonviewcontroller")
        
                    // pushing signon viewController to the navigation stack
                    navigationController?.pushViewController(signOnViewController!, animated: false)
    
                }else{
                    
                    eventData["menu"] = "teaser"
                NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
                NSNotificationCenter.defaultCenter().postNotificationName("ShowMenuButton", object: nil, userInfo:  nil)
                }
                
                targetController = navigationController?.visibleViewController
            }else{

            }
            
        } else {
            applicationModel.networkConnection = false
            println("Netwerkverbinding: \(applicationModel.networkConnection)")
        
            eventData["menu"] = "error"
            NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
            
            NSNotificationCenter.defaultCenter().postNotificationName("DataConnectionOffline", object: nil, userInfo:  nil)
        }
    }
    
    
    func cheackNearestMuseum(){
        println("check")
        
        
        locationServices.getNearestMuseum()
    }
    
    func openCommentPanel(notification:NSNotification){
        
        
        /*
        if let toggle = notification.userInfo {
            
            var myTarget: String = (toggle["target"] as! String)
            println(myTarget)
            
            commentViewController = CommentsPanellViewController()
            commentViewController!.view.frame = CGRect(x: 0, y: 200, width: screenSize.width, height: 300)
            commentViewController!.view.backgroundColor = UIColor.redColor()
            view.addSubview(commentViewController!.view)
            
        }*/
        
    }
    
    /**
    * Hide status bar
    */
    /*
    override func prefersStatusBarHidden() -> Bool {
        return true
    }*/
}