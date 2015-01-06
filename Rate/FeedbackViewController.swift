//
//  FeedbackViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 8/12/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    var closeButton:UIButton?
    var scrollView:UIScrollView?
    var viewTitle:UILabel?
    var infoTitle:UILabel?
    var textField: UITextField?
    var descriptionLabel: UILabel?
    
    // data objects
    var exhibitModel:ExhibitModel? = nil
    var roomModel:RoomModel? = nil
    
    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // Singleton Models
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()
    
    // Input views
    var twitterInputViewController:TwitterInputViewController?
    var facebookInputViewController:FacebookInputViewController?
    var instaGramInputViewController:InstagramInputViewController?
    var cameraInputViewController:CameraInputViewController?
    var textInputViewController:TextInputViewController?
    
    var activeView:UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Views
        twitterInputViewController = TwitterInputViewController(nibName: "TwitterInputViewController", bundle: nil)
        facebookInputViewController = FacebookInputViewController(nibName: "FacebookInputViewController", bundle: nil)
        instaGramInputViewController = InstagramInputViewController(nibName: "InstagramInputViewController", bundle: nil)
        cameraInputViewController = CameraInputViewController(nibName: "CameraInputViewController", bundle: nil)
        textInputViewController = TextInputViewController(nibName: "TextInputViewController", bundle: nil)
        
        // Do any additional setup after loading the view.
        createUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func createUI(){
        
        // scrollview
        scrollView = UIScrollView()
        scrollView?.frame = CGRect(x: 0, y: 0, width:384, height: self.view.frame.height)
        scrollView?.contentSize = CGSize(width: 384, height: 2000)
        scrollView?.bounces = false
        scrollView?.backgroundColor = UIColor.whiteColor()
    
        // close button
        closeButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        closeButton?.setTitle("X", forState: UIControlState.Normal)
        closeButton?.frame = CGRect(x: 344, y: 0, width: 40, height: 40)
        closeButton?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        closeButton?.backgroundColor = UIColor.whiteColor()
        closeButton!.addTarget(self, action: "closeView:", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton?.titleLabel?.textColor = UIColor.blackColor()
        
        // exhibit title
        viewTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 384, height: 60))
        viewTitle?.numberOfLines = 1
        viewTitle?.lineBreakMode = .ByWordWrapping
        viewTitle?.text = exhibitModel?.exhibit_title
        viewTitle?.font =  UIFont (name: "HelveticaNeue-Light", size: 16)
        viewTitle?.textColor = UIColor.blackColor()
        viewTitle?.textAlignment = NSTextAlignment.Center

        // exhibit title
        infoTitle = UILabel(frame: CGRect(x: 0, y: 40, width: 384, height: 60))
        infoTitle?.numberOfLines = 1
        infoTitle?.lineBreakMode = .ByWordWrapping
        infoTitle?.text = "Mijn mening"
        infoTitle?.font =  UIFont (name: "HelveticaNeue-Light", size: 24)
        infoTitle?.textColor = UIColor.blackColor()
        infoTitle?.textAlignment = NSTextAlignment.Center
        
        descriptionLabel = UILabel(frame: CGRect(x: 0, y: 160, width: screenSize.width, height: 100))
        descriptionLabel!.numberOfLines = 8
        descriptionLabel!.lineBreakMode = .ByWordWrapping
        descriptionLabel!.text = roomModel?.mercury_room_description
        descriptionLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
        descriptionLabel!.textColor = UIColor.blackColor()
        descriptionLabel!.textAlignment = NSTextAlignment.Center
        
        // add views
        view.addSubview(scrollView!)
        view.addSubview(closeButton!)
        view.addSubview(viewTitle!)
        view.addSubview(infoTitle!)
        view.addSubview(descriptionLabel!)
        
        // buttons
        var twButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        var fbButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        var inButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        var cmButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        var wrButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton

        twButton.frame = CGRect(x: 45, y: 100, width: 50, height: 50)
        fbButton.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        inButton.frame = CGRect(x: 155, y: 100, width: 50, height: 50)
        cmButton.frame = CGRect(x: 210, y: 100, width: 50, height: 50)
        wrButton.frame = CGRect(x: 265, y: 100, width: 50, height: 50)
        
        twButton.tag = 1
        fbButton.tag = 2
        inButton.tag = 3
        cmButton.tag = 4
        wrButton.tag = 5
        
        twButton.backgroundColor = UIColor.blackColor()
        fbButton.backgroundColor = UIColor.blackColor()
        inButton.backgroundColor = UIColor.blackColor()
        cmButton.backgroundColor = UIColor.blackColor()
        wrButton.backgroundColor = UIColor.blackColor()

        twButton.addTarget(self, action: "commentView:", forControlEvents: UIControlEvents.TouchUpInside)
        fbButton.addTarget(self, action: "commentView:", forControlEvents: UIControlEvents.TouchUpInside)
        inButton.addTarget(self, action: "commentView:", forControlEvents: UIControlEvents.TouchUpInside)
        cmButton.addTarget(self, action: "commentView:", forControlEvents: UIControlEvents.TouchUpInside)
        wrButton.addTarget(self, action: "commentView:", forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(twButton)
        view.addSubview(fbButton)
        view.addSubview(inButton)
        view.addSubview(cmButton)
        view.addSubview(wrButton)
        

    }
    
    
    func commentView(sender:UIButton){
        
        // remove view if it already exists
        if((activeView) != nil){
            activeView?.removeFromParentViewController()
            activeView?.view.removeFromSuperview()
        }
        
        switch sender.tag{
            case 1:
                    self.addChildViewController(twitterInputViewController!)
                    twitterInputViewController?.view.frame = CGRect(x: 0, y: 180, width: view.frame.width, height: 420)
                    view.addSubview(twitterInputViewController!.view)
                    
                    activeView = twitterInputViewController
            break;
        
            case 2:
                    self.addChildViewController(facebookInputViewController!)
                    facebookInputViewController?.view.frame = CGRect(x: 0, y: 180, width: view.frame.width, height: 420)
                    view.addSubview(facebookInputViewController!.view)
                    
                    activeView = facebookInputViewController
            break;
        
            case 3:
                    self.addChildViewController(instaGramInputViewController!)
                    instaGramInputViewController?.view.frame = CGRect(x: 0, y: 180, width: view.frame.width, height: 420)
                    view.addSubview(instaGramInputViewController!.view)
                    
                    activeView = instaGramInputViewController
            break;
        
            case 4:
                    self.addChildViewController(cameraInputViewController!)
                    cameraInputViewController?.view.frame = CGRect(x: 0, y: 180, width: view.frame.width, height: 420)
                    view.addSubview(cameraInputViewController!.view)
                
                    activeView = cameraInputViewController
            break;
        
            case 5:
                    self.addChildViewController(textInputViewController!)
                    textInputViewController?.view.frame = CGRect(x: 0, y: 180, width: view.frame.width, height: 420)
                    view.addSubview(textInputViewController!.view)
                    
                    activeView = textInputViewController
            break;
        
            default:
                println("no")
        }
    }
    
    func closeView(sender:UIButton){
        println("close view")
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
        NSNotificationCenter.defaultCenter().postNotificationName("CloseFeedbackPanel", object: nil, userInfo:  nil)

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
