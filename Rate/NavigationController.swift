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
    var helpButton:UIButton?
    var barView:UIView?
    var menuLabel:UILabel?
    var barLabel: UILabel?

    
    func toggle(){
        
    }
    
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

        // Bar background
        barView = UIView()
        barView?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 64)
        barView?.backgroundColor = UIColor.whiteColor()
        barView?.alpha = 0.96
        
        var border = CALayer()
        var width = CGFloat(1)
        border.borderColor = applicationModel.UIColorFromRGB(0xbdbeb8).CGColor
        border.frame = CGRect(x: 0, y: barView!.frame.size.height - width, width:  barView!.frame.size.width, height: barView!.frame.size.height)

        border.borderWidth = width
        barView!.layer.addSublayer(border)
        barView!.layer.masksToBounds = true
        barLabel = UILabel(frame: CGRect(x: 0, y: 7, width: screenSize.width, height: 64))
        barLabel!.numberOfLines = 1
        barLabel!.text = "Exhibit"
        barLabel!.font =  UIFont (name: "AvenirNext-DemiBold", size: 18)
        barLabel!.textColor = UIColor.whiteColor()
        barLabel?.textAlignment = NSTextAlignment.Center
        barLabel?.alpha = 0

        view.addSubview(barView!)
        barView?.addSubview(barLabel!)

    
        // Menu image button
        let menuImage = UIImage(named: "hamburger-ico") as UIImage?
            menuButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
            menuButton?.addTarget(self, action: "showMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            menuButton?.setTitle("", forState: UIControlState.Normal)
            menuButton?.titleLabel?.textAlignment = .Left
            menuButton?.frame = CGRectMake(10, 22, 40, 30)
            menuButton?.setImage(menuImage, forState: .Normal)
            menuButton?.alpha = 0
        view.addSubview(menuButton!)
        
        
    
        /*
        let menuImage = UIImage(named: "hamburger-ico") as UIImage?
        menuButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        menuButton?.addTarget(self, action: "showMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        menuButton?.setTitle("", forState: UIControlState.Normal)
        menuButton?.titleLabel?.textAlignment = .Left
        menuButton?.frame = CGRectMake(20, 20, 40, 30)
        menuButton?.setImage(menuImage, forState: .Normal)
        menuButton?.alpha = 0
        view.addSubview(menuButton!)
        */
    
        
        
        // Help image button
        let helpIcon = UIImage(named: "help-ico") as UIImage?
            helpButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
            helpButton?.addTarget(self, action: "showHelp:", forControlEvents: UIControlEvents.TouchUpInside)
            helpButton?.setTitle("", forState: UIControlState.Normal)
            helpButton?.frame = CGRect(x: screenSize.width - 40, y: 20, width: 30, height: 30)
            helpButton?.titleLabel?.textAlignment = .Right
            helpButton?.setImage(helpIcon, forState: .Normal)
            helpButton?.alpha = 0
        view.addSubview(helpButton!)
        
        
        // Bind custom events to handle page flow from this controller
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleMenu:", name:"HideNavigation", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuBackgroundToggle:", name:"BackgroundMenu", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideMenuButton:", name:"HideMenuButton", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMenuButton:", name:"ShowMenuButton", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showBar:", name:"ShowBar", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideBar:", name:"HideBar", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleBar:", name:"ToggleBar", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setTitleFunc:", name:"SetTitle", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuIcon:", name:"MenuIcon", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rightIcon:", name:"RightIcon", object: nil)
    }
   
    func hideMenuButton(notification:NSNotification){
        menuButton?.alpha = 0
        helpButton?.alpha = 0
    }
    
    func showMenuButton(notification:NSNotification){
        UIView.animateWithDuration(0.4, delay: 0.2, options: nil, animations: {
            self.menuButton?.alpha = 100
            self.helpButton?.alpha = 100

            return
            }, completion: { finished in
        })
    }
    
    
    func showBar(notif:NSNotification){
        barView?.alpha = 1
    }
    
    func hideBar(notif:NSNotification){
        println("verberg de bar")
        
        
        helpButton?.hidden = true
        barView?.hidden = true
        menuButton?.hidden = true
    }
    
    func rightIcon(notif:NSNotification){
        helpButton?.hidden = false
        barView?.hidden = false
        menuButton?.hidden = false
        
        
        if let toggle = notif.userInfo {
            var target:String = (toggle["icon"] as! String)
            
            switch(target){
                
                case "hidden":
                    helpButton?.hidden = true
                break;
                
                case "exhibitGrid":
                    let exhibitGridImage = UIImage(named: "exhibitGrid") as UIImage?
                    helpButton?.setImage(exhibitGridImage, forState: .Normal)
                    helpButton?.tag = 2
                    helpButton?.hidden = false
                    
                break;
                
                
            case "settings":
                let helpIcon = UIImage(named: "help-ico") as UIImage?
                helpButton!.setImage(helpIcon, forState: .Normal)
                helpButton!.hidden = false
                helpButton!.tag = 1
                
                break;
                
            case "list":
                let listIcon = UIImage(named: "list-icon") as UIImage?
                helpButton!.setImage(listIcon, forState: .Normal)
                helpButton!.hidden = false
                helpButton!.tag = 4
                
                
                
                break;
                
            
            default:
                //
                break;
            }
            //
        }
    }
    
    

    
    
    
    
    func menuIcon(notif:NSNotification){
        helpButton?.hidden = false
        barView?.hidden = false
        menuButton?.hidden = false
        
        
        if let toggle = notif.userInfo {
            var target:String = (toggle["icon"] as! String)
            
            switch(target){
                case "logout":
                    let backImage = UIImage(named: "back-button") as UIImage?
                        menuButton?.setImage(backImage, forState: .Normal)
                        menuButton?.tag = 1
                        menuButton?.hidden = false
                break;
            
                case "teaser":
                    
                    let homeImage = UIImage(named: "homeButton") as UIImage?
                    menuButton?.setImage(homeImage, forState: .Normal)
                    menuButton?.tag = 2
                    menuButton?.hidden = false
                break;
                
                case "exhibit":
                    
                    let exhibitImage = UIImage(named: "list-icon") as UIImage?
                    menuButton?.setImage(exhibitImage, forState: .Normal)
                    menuButton?.tag = 3
                    menuButton?.hidden = false
                    
                    
                break;
                
                case "hidden":
                    menuButton?.hidden = true
                break;
                
                default:
                    //
                break;
            }
            //
        }
    }
    
    
    /**
    * Show the menu background
    */
    //func showBar(notification:NSNotification){
        /*if let info = notification.userInfo {
            var eventInfo: String = (info["showToolBar"] as String)
            var exhibit:String = (info["menuTitle"] as String)
            var exhibitTitle:String = (info["menuTitleString"] as String)
            
            println(exhibitTitle)
            
            if(eventInfo == "true" && self.barView?.frame.origin.y < 0){
                
                if(exhibit == "true"){
                    barLabel!.alpha = 1
                    barLabel!.text = exhibitTitle
                }else{
                    
                    barLabel!.alpha = 1
                }
                
                self.barView?.frame = CGRect(x: 0, y: -70, width: screenSize.width, height: 70)

                UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: {
                    self.barView?.frame = CGRect(x: 0, y: 0, width: self.screenSize.width, height: 70)
                    
                    return
                    }, completion: { finished in
                })
            }else if(eventInfo == "false"){
                
                UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: {
                    self.barView?.frame = CGRect(x: 0, y: -70, width: self.screenSize.width, height: 70)
                    
                    return
                    }, completion: { finished in
                        
                })
            }
        }*/
    //}
    
    
    func toggleMenu(notification: NSNotification){
        
        if let info = notification.userInfo {
            println(notification.userInfo)
            
            var viewy = self.menuViewController?.view
            
            UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
                viewy!.alpha = 100
                viewy?.frame = CGRect(x:0, y:-viewy!.frame.height, width:self.screenSize.width, height:212)
                }, completion: { finished in
                    self.menuViewController?.removeFromParentViewController()
                    self.menuViewController?.view.removeFromSuperview()
            
                    UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
                        self.menuButton?.alpha = 100
                        return
                        }, completion: { finished in

                    })
            })
            
        
            var myTarget: String = (info["menu"] as! String)
            eventData["menu"] = myTarget

            NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
        }
    }
    
    
    func menuBackgroundToggle(notification: NSNotification){
        println("toggle menu background")
        
        if let toggle = notification.userInfo {
            var myTarget:Bool = (toggle["toggle"] as! Bool)
            
            if(myTarget == true){

            }else{
                
            }
        }
    }
    
    func hideMenu(){
       println("yes")
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
        
        
        
        
        switch(sender.tag){
            
            case 1:
            
                eventData["menu"] = "sign"
                NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
                
            break;
            
            
            case 2:
                
                eventData["menu"] = "teaser"
                NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
            break;
            
            case 3:
            
                
                eventData["menu"] = "overview"
                NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
                
            break;
            
            
            default:
            
                menuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
                self.addChildViewController(menuViewController!)
                self.view.addSubview(menuViewController!.view)
                var myView = menuViewController?.view
                myView?.frame = CGRect(x:0, y:(-screenSize.height), width:screenSize.width, height:212)
                
                UIView.animateWithDuration(0.3, delay: 0, options: nil, animations: {
                    myView!.alpha = 100
                    myView?.frame = CGRect(x:0, y:64, width:self.screenSize.width, height:212)
                    }, completion: { finished in
                        println("Basket doors opened!")
                })
                
                NSNotificationCenter.defaultCenter().postNotificationName("ShowMenuHandler", object: nil)

                
            break;
        
        }
        

    }
    
    
    func setTitleFunc(noti:NSNotification){
     
        if let text = noti.userInfo {
            var title:String = (text["title"] as! String)
            
            barLabel?.text = title
            barLabel?.alpha = 1
            barLabel?.textColor = applicationModel.UIColorFromRGB(0x999999)
            
        }
    
    }
    

    func showHelp(sender:UIBarButtonItem){

        switch(sender.tag){
            case 1:
            
                eventData["menu"] = "settings"
                NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
            
            break;
            case 2:
            
                NSNotificationCenter.defaultCenter().postNotificationName("GridToggle", object: nil, userInfo:  nil)
            break;
            

            
            default:

                println("default")
                break;
        }
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
