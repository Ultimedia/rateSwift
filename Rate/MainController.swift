//
//  ViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 19/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//
import CoreLocation
import UIKit

class MainController: UIViewController, CLLocationManagerDelegate, UIPageViewControllerDelegate, UIScrollViewDelegate {

    // An instance of a core location manager
    let locationManager = CLLocationManager()
    
    // Your beacon uuid and identifier
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"), identifier: "Estimotes")
    
    // First bool
    var firstRun:Bool = true
    var eventData = Dictionary<String, String>()

    
    // Create our model
    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController()
        }
        return _modelController!
    }
    
    var current:UIViewController?
    var currentMenu:UIViewController?
    
    // Model Controller
    var _modelController: ModelController? = nil
    
    // Screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // Views
    var exhibitViewController:ExhibitViewController?
    var helpViewController:HelpViewController?
    var teaserViewController:TeaserViewController?
    var favouritesViewController:FavouritesViewController?
    var settingsViewController:SettingsViewController?
    var signOnViewController:SignOnScreenViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // initiate viewControllers
        helpViewController = HelpViewController(nibName: "HelpViewController", bundle: nil)
        exhibitViewController = ExhibitViewController(nibName: "ExhibitViewController", bundle: nil)
        teaserViewController = TeaserViewController(nibName: "TeaserViewController", bundle: nil)
        favouritesViewController = FavouritesViewController(nibName: "FavouritesViewController", bundle: nil)
        settingsViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        signOnViewController = SignOnScreenViewController(nibName: "SignOnScreenViewController", bundle: nil)


        // Check connection in a timed function
        var connectionTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("checkConnection"), userInfo: nil, repeats: true)
        
        // Bind custom events to handle page flow from this controller
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuChangedHandler:", name:"MenuChangedHandler", object: nil)
    }
    
    
    
    /**
    * Handle navigation
    */
    func menuChangedHandler(notification: NSNotification){
        var targetController:UIViewController?
        var createViewController:Bool = false
        
        if let info = notification.userInfo {
            var myTarget: String = (info["menu"] as String)
            
            switch myTarget
            {
                case "teaser":
                    targetController = teaserViewController
                case "exhibit":
                    targetController = exhibitViewController
                case "help":
                    targetController = helpViewController
                case "favourites":
                    targetController = favouritesViewController
                case "settings":
                    targetController = settingsViewController
                default:
                    println("none")
            }
            
            for (index, viewController) in enumerate(navigationController!.viewControllers) {
                if(targetController == viewController as? UIViewController){
                    createViewController = true
                }
            }
            
            // do we need to push or pop?
            if(!createViewController){
                navigationController?.pushViewController(targetController!, animated: true)
            }else{
                navigationController?.popToViewController(targetController!, animated: true)
            }
            
            
        } else {
            println("no valid data")
        }
    }
    
    
    
    /**
    * Check network connection
    */
    func checkConnection(){
        
        if Reachability.isConnectedToNetwork() {
            modelController.networkConnection = true
        } else {
            modelController.networkConnection = false
            println("Netwerkverbinding: \(modelController.networkConnection)")
        }
        
        if(firstRun){
            firstRun = false
         
            
            if(modelController.firstLogin == true){
                
                navigationController?.pushViewController(signOnViewController!, animated: false)
                
                eventData["show"] = "true"
                NSNotificationCenter.defaultCenter().postNotificationName("HideNavigation", object: nil, userInfo:  eventData)
                
            }else{
                navigationController?.pushViewController(teaserViewController!, animated: false)
            }
            
            
            /*
            // create the first page
            navigationController?.pushViewController(teaserViewController!, animated: false)*/
            /*
            var v = teaserViewController?.view
            addChildViewController(teaserViewController!)
            view.addSubview(v!)
            current = teaserViewController*/
        }
    }
    
    
    /**
    * Setup beacons
    */
    func initBeacons(){
        
        // Let our locationManager know that this View Controller should be its delegate (so it should deliver its messages here)
        locationManager.delegate = self;
        
        // Ask user permission and check if the permission has been granted
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            println("no beacon permission :(")
            modelController.beaconPermission = false
            locationManager.requestWhenInUseAuthorization()
        }else{
            modelController.beaconPermission = true
        }
        
        // Start monitoring the beacon region
        locationManager.startRangingBeaconsInRegion(region)
    }
    
    
    /**
    * Handle iBeacon events
    */
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        // show all beacons
        println(beacons)
        
        // strip the beacons that have an unknown proximity
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        
        // proceed if we have beacons in range
        // first element in array is the closest beacon
        if (knownBeacons.count > 0) {
            
            //get closest beacon
            let closestBeacon = knownBeacons[0] as CLBeacon
            
            // gotoArtwork
            var minor:Int = Int(closestBeacon.minor)
            var te:String = String(minor)
            
        }
    }
    
    
}

