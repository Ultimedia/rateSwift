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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeMenu:", name:"CloseMenuFromNavigation", object: nil)

        // get locationServices
        locationServices.initLocationServices()
    }
    

    /**
    * Handle navigation
    */
    func menuChangedHandler(notification: NSNotification){
        var createViewController:Bool = false
        var initialSetup:Bool = false
        
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
                case "sign":
                    targetController = signOnViewController
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
            applicationModel.currentViewController = targetController
            
            var yPos = screenSize.height - 322
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
            
        } else {
            println("no valid data")
        }
    }
    
    /**
    * Animation: Scroll the content frame down when opening the menu
    */
    func showMenu(notification: NSNotification){
        println("showing menu")
        
        var myView = targetController?.view
        var yPos = screenSize.height - 322
        
        UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
            myView?.frame = CGRect(x:0, y:+self.screenSize.height-yPos, width:self.screenSize.width, height:self.screenSize.height)
            myView?.alpha = 0.5
            return
        }, completion: { finished in

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
                    NSNotificationCenter.defaultCenter().postNotificationName("HideMenuButton", object: nil, userInfo:  eventData)

                }else{
                    navigationController?.pushViewController(teaserViewController!, animated: false)
                }
                
                targetController = navigationController?.visibleViewController
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