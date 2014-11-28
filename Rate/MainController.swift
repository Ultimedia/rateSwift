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
    
    // Class specific data
    var firstRun:Bool = true
    var eventData = Dictionary<String, String>()
    var current:UIViewController?
    var currentMenu:UIViewController?
    
    // applicationModel
    let applicationModel = ApplicationData.sharedModel()
    
    // Location Services
    let locationServices = LocationSevices.locationServices()
    
    // Data services
    let dataServices = DataManager.dataManager()
    
    // Location Services
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()
    
    // Screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // Views
    var exhibitViewController:ExhibitViewController?
    var helpViewController:HelpViewController?
    var teaserViewController:TeaserViewController?
    var favouritesViewController:FavouritesViewController?
    var settingsViewController:SettingsViewController?
    var signOnViewController:SignOnScreenViewController?
    var loadingViewControler:LoadingViewController?
    var menuViewController:UIViewController?
    var connectionFound = false
    var targetController:UIViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // detect our device type
        deviceFunctionService.detectDevice()
        
        //initiate viewControllers
        helpViewController = HelpViewController(nibName: "HelpViewController", bundle: nil)
        exhibitViewController = ExhibitViewController(nibName: "ExhibitViewController", bundle: nil)
        teaserViewController = TeaserViewController(nibName: "TeaserViewController", bundle: nil)
        favouritesViewController = FavouritesViewController(nibName: "FavouritesViewController", bundle: nil)
        settingsViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        signOnViewController = SignOnScreenViewController(nibName: "SignOnScreenViewController", bundle: nil)
        loadingViewControler = LoadingViewController(nibName: "LoadingViewController", bundle: nil)

        // show loading screen
        navigationController?.pushViewController(loadingViewControler!, animated: false)
        
        // Check connection in a timed function
        var dataTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("checkDataConnection"), userInfo: nil, repeats: true)
        
        // Bind custom events to handle page flow from this controller
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuChangedHandler:", name:"MenuChangedHandler", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMenu:", name:"ShowMenuHandler", object: nil)

        
        // get locationServices
        locationServices.initLocationServices()
    }
    

    /**
    * Handle navigation
    */
    func menuChangedHandler(notification: NSNotification){
        var createViewController:Bool = false
        
        if let info = notification.userInfo {
            println(notification.userInfo)
            
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
                navigationController?.pushViewController(targetController!, animated: false)
            }else{
                navigationController?.popToViewController(targetController!, animated: false)
            }
            
            applicationModel.currentViewController = targetController
            
        } else {
            println("no valid data")
        }
    }
    
    
    func showMenu(notification: NSNotification){
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
    
    
    /**
    * Check network connection
    */
    func checkDataConnection(){
        
        // first check if we have a connection
        if Reachability.isConnectedToNetwork() {
            applicationModel.networkConnection = true
        
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
                
                    navigationController?.pushViewController(signOnViewController!, animated: false)
                
                    eventData["show"] = "true"
                    NSNotificationCenter.defaultCenter().postNotificationName("HideNavigation", object: nil, userInfo:  eventData)
                
                }else{
                    navigationController?.pushViewController(teaserViewController!, animated: false)
                }
            }
            
        } else {
            applicationModel.networkConnection = false
            println("Netwerkverbinding: \(applicationModel.networkConnection)")
        }
    }
    
    /**
    * Hide status bar
    */
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}