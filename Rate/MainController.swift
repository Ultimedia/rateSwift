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


    // Effects
    var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager = CBPeripheralManager()

        
        println("app running")
        
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

        
        // get locationServices
        locationServices.initLocationServices()
        
        
        self.manager = CBPeripheralManager(delegate: self, queue: nil)


    }


    func errorDialog(ns:NSNotification){

        println("hier")
        
        var errorMessage:String = ""
        if let info = ns.userInfo {
            errorMessage =  info["errorString"] as String
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
        /*println("found the museum " + applicationModel.activeMuseum!.museum_title)
        */
        // show info to the user
        let notification = UILocalNotification()
        
        /* Time and timezone settings */
        notification.fireDate = NSDate(timeIntervalSinceNow: 10.0)
        notification.timeZone = NSCalendar.currentCalendar().timeZone
        notification.alertBody = "Je bent nu in het " + applicationModel.activeMuseum!.museum_title
        
        /* Action settings */
        notification.hasAction = true
        notification.alertAction = "View"
        
        /* Badge settings */
        notification.userInfo = ["Key 1" : "Value 1", "Key 2" : "Value 2"]
        
        /* Schedule the notification */
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    
    /**
    * Handle navigation
    */
    func menuChangedHandler(notification: NSNotification){
        var createViewController:Bool = false
        var initialSetup:Bool = false
        
        if let info = notification.userInfo {
            println(notification.userInfo)
            
            if((info["menu"] as String) != "error"){
                applicationModel.lastPage = info["menu"] as? String
            }
            
            
            if(applicationModel.currentTarget != info["menu"] as? String){
            
            var myTarget: String = (info["menu"] as String)
            applicationModel.currentTarget = myTarget

            var isPopup:Bool = false
            
            
            switch myTarget
            {
                case "teaser":
                    teaserViewController = TeaserViewController(nibName: "TeaserViewController", bundle: nil)
                    targetController = teaserViewController
                    locationServices.getNearestMuseum()
                    applicationModel.localExhibitSelected = false
                
                    eventData["icon"] = "teaser"
                    NSNotificationCenter.defaultCenter().postNotificationName("MenuIcon", object: nil, userInfo:  eventData)

                    eventData["icon"] = "settings"
                    NSNotificationCenter.defaultCenter().postNotificationName("RightIcon", object: nil, userInfo:  eventData)


                
                case "overview":
                    museumOverviewController = MuseumOverviewViewController(nibName: "MuseumOverviewViewController", bundle: nil)

                    targetController = museumOverviewController
                    applicationModel.localExhibitSelected = false
                
                    eventData["icon"] = "teaser"
                    NSNotificationCenter.defaultCenter().postNotificationName("MenuIcon", object: nil, userInfo:  eventData)
                
                    
                    eventData["icon"] = "hidden"
                    NSNotificationCenter.defaultCenter().postNotificationName("RightIcon", object: nil, userInfo:  eventData)
                

                
                
                case "exhibit":
                    targetController = exhibitViewController
                    
                    eventData["icon"] = "exhibitGrid"
                    NSNotificationCenter.defaultCenter().postNotificationName("RightIcon", object: nil, userInfo:  eventData)
                
                    eventData["icon"] = "exhibit"
                    NSNotificationCenter.defaultCenter().postNotificationName("MenuIcon", object: nil, userInfo:  eventData)
                
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
    
    
    func showMapPopupHandler(notification:NSNotification){
        
        visualEffectView.frame = view.bounds
        targetController?.view.addSubview(visualEffectView)
        
        // dispatch event
        
        map = DIrectionsOverlayViewController(nibName: "DIrectionsOverlayViewController", bundle: nil)
        map?.view.frame = CGRect(x: 20, y: 70, width: screenSize.width-40, height: screenSize.height-100)
        
        map!.view.layer.shadowColor = UIColor.blackColor().CGColor
        map!.view.layer.shadowOffset = CGSizeMake(5, 5)
        map!.view.layer.shadowRadius = 5
        
        targetController!.addChildViewController(map!)
        targetController!.view.addSubview(map!.view)
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
                    
                    println("eeeee")
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
    
    /**
    * Hide status bar
    */
    /*
    override func prefersStatusBarHidden() -> Bool {
        return true
    }*/
}