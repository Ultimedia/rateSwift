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

    // applicationModel
    let applicationModel = ApplicationData.sharedModel()
    
    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var menuButton:UIButton?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get the screensize
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        
        // Do any additional setup after loading the view.
        var ui:UIImage = UIImage(named: "menuBackground")!
        
        // change the visuals of the menubar
       /* self.navigationBar.shadowImage = ui
        self.navigationBar.clipsToBounds = true
        self.edgesForExtendedLayout = UIRectEdge.All
        self.navigationBar.setBackgroundImage(ui,  forBarMetrics: .Default)
        self.navigationBar.translucent = true;
        self.view.backgroundColor = UIColor.clearColor()
        self.navigationItem.hidesBackButton = true
        self.navigationBar.hidden = true
        self.interactivePopGestureRecognizer.enabled = false*/

        
        // Menu image button
        let menuImage = UIImage(named: "hamburger-ico") as UIImage?
            menuButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
            menuButton?.addTarget(self, action: "showMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            menuButton?.setTitle("", forState: UIControlState.Normal)
            menuButton?.titleLabel?.textAlignment = .Left
            menuButton?.frame = CGRectMake(20, 20, 40, 30)
            menuButton?.setImage(menuImage, forState: .Normal)
            menuButton?.alpha = 0
        view.addSubview(menuButton!)
        
        
        // Help image button
        let helpIcon = UIImage(named: "help-ico") as UIImage?
        var helpButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
            helpButton.addTarget(self, action: "showHelp:", forControlEvents: UIControlEvents.TouchUpInside)
            helpButton.setTitle("", forState: UIControlState.Normal)
            helpButton.frame = CGRect(x: screenSize.width - 40, y: 20, width: 30, height: 30)
            helpButton.titleLabel?.textAlignment = .Right
            helpButton.setImage(helpIcon, forState: .Normal)
        view.addSubview(helpButton)
        
        
        // Bind custom events to handle page flow from this controller
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleMenu:", name:"HideNavigation", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuBackgroundToggle:", name:"BackgroundMenu", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideMenuButton:", name:"HideMenuButton", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMenuButton:", name:"ShowMenuButton", object: nil)
    }
   
    
    func hideMenuButton(notification:NSNotification){
        menuButton?.alpha = 0
    }
    
    func showMenuButton(notification:NSNotification){
        UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
            self.menuButton?.alpha = 100
            return
            }, completion: { finished in
                
        })
    }
    
    
    func toggleMenu(notification: NSNotification){
        
        if let info = notification.userInfo {
            println(notification.userInfo)
            
            var viewy = self.menuViewController?.view
            
            UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
                viewy!.alpha = 100
                viewy?.frame = CGRect(x:0, y:-viewy!.frame.height, width:self.screenSize.width, height:322)
                }, completion: { finished in
                    self.menuViewController?.removeFromParentViewController()
                    self.menuViewController?.view.removeFromSuperview()
            
                    UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
                        self.menuButton?.alpha = 100
                        return
                        }, completion: { finished in

                    })
            
            })
            
        
            var myTarget: String = (info["menu"] as String)
            eventData["menu"] = myTarget

            NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
        }
    }
    
    
    func menuBackgroundToggle(notification: NSNotification){
        println("toggle menu background")
        
        if let toggle = notification.userInfo {
            var myTarget:Bool = (toggle["toggle"] as Bool)
            
            if(myTarget == true){

            }else{
                
            }
        }
    }

    
    /** 
    * Adds a background to the menu
    */
    func toggleMenuBackground(visible: Bool){
        println("in gebruik")
        
        if(visible){
            view.backgroundColor = UIColor.blackColor()
        }else{
            
        }
    }
    
    
    internal func toggleM(){
        
    }
    
    
    /**
    * Handle navigation
    */
    func menuCloseHandler(notification: NSNotification){
        println("closing menu")
        
        var myView = view
        UIView.animateWithDuration(0.4, animations: {
            myView.alpha = 100
    
            },
            completion: { finished in if(finished) {
    
            }
        })
    }

    
    func showMenu(sender:UIBarButtonItem){
        
        menuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        self.addChildViewController(menuViewController!)
        self.view.addSubview(menuViewController!.view)
        var myView = menuViewController?.view
            myView?.frame = CGRect(x:0, y:(-screenSize.height), width:screenSize.width, height:322)

        UIView.animateWithDuration(0.3, delay: 0, options: nil, animations: {
            myView!.alpha = 100
            myView?.frame = CGRect(x:0, y:0, width:self.screenSize.width, height:322)
        }, completion: { finished in
                println("Basket doors opened!")
        })
        
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
