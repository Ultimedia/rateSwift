//
//  NavigationController.swift
//  Rate
//
//  Created by Maarten Bressinck on 19/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    var eventData = Dictionary<String, String>()
    var menuViewController:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get the screensize
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        
        // Do any additional setup after loading the view.
        var ui:UIImage = UIImage(named: "menuBackground")!
        
        // change the visuals of the menubar
        self.navigationBar.shadowImage = ui
        self.navigationBar.clipsToBounds = false
        self.edgesForExtendedLayout = UIRectEdge.All
        self.navigationBar.setBackgroundImage(ui,  forBarMetrics: .Default)
        self.navigationBar.translucent = true;
        self.view.backgroundColor = UIColor.clearColor()
        self.navigationItem.hidesBackButton = true
        self.navigationBar.hidden = true
        self.interactivePopGestureRecognizer.enabled = false;

        
        // Menu image button
        let menuImage = UIImage(named: "hamburger-ico") as UIImage?
        var menuButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
            menuButton.addTarget(self, action: "showMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            menuButton.setTitle("", forState: UIControlState.Normal)
            menuButton.titleLabel?.textAlignment = .Left
            menuButton.frame = CGRectMake(20, 30, 40, 30)
            menuButton.setImage(menuImage, forState: .Normal)
        view.addSubview(menuButton)
        
        
        // Help image button
        let helpIcon = UIImage(named: "help-ico") as UIImage?
        var helpButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
            helpButton.addTarget(self, action: "showHelp:", forControlEvents: UIControlEvents.TouchUpInside)
            helpButton.setTitle("", forState: UIControlState.Normal)
            helpButton.frame = CGRect(x: screenSize.width - 40, y: 30, width: 30, height: 30)
            helpButton.titleLabel?.textAlignment = .Right
            helpButton.setImage(helpIcon, forState: .Normal)
        view.addSubview(helpButton)
        
        

        // Bind custom events to handle page flow from this controller
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleMenu:", name:"HideNavigation", object: nil)

    }
   
    func toggleMenu(notification: NSNotification){
        if let info = notification.userInfo {
            var myTarget: String = (info["show"] as String)
        
            if(myTarget == "true"){
                //view.alpha = 0
            }else{
                //view.alpha = 100
            }
        }
    }
    
        
    
    
    /**
    * Handle navigation
    */
    func menuCloseHandler(notification: NSNotification){
        var myView = view
        UIView.animateWithDuration(0.3, animations: {
            myView.alpha = 100
    
            },
            completion: { finished in if(finished) {
    
            }
        })
    }

    
    func showMenu(sender:UIBarButtonItem){
        
        menuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        
        var myView = menuViewController?.view
        
        
        //myView?.backgroundColor = UIColor.clearColor()
        self.presentViewController(menuViewController!, animated: false, completion: nil)

        /*
        UIView.animateWithDuration(0.2, animations: {
                myView.alpha = 0
            },
            completion: { finished in if(finished) {
                let menuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
                menuViewController.view.alpha = 0
                
                self.presentViewController(menuViewController, animated: false, completion: { (Bool)  in

                    UIView.animateWithDuration(0.2, animations: {
                            menuViewController.view.alpha = 100
                        },
                        completion: { finished in if(finished) {
                            //dismissViewControllerAnimated(false, completion: nil)
                        }
                    })
                })
            }
        })*/
        
        NSNotificationCenter.defaultCenter().postNotificationName("ShowMenuHandler", object: nil)

    }
    

    func showHelp(sender:UIBarButtonItem){
        
        
        eventData["menu"] = "help"
        NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
