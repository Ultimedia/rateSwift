//
//  TeaserViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 19/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class TeaserViewController: UIViewController, UIScrollViewDelegate {
    
    // scrollview
    var scrollView: UIScrollView?
    
    // labels
    var logoLabel: UILabel?
    var subtitleLabel: UILabel?
    var descriptionLabel: UILabel?
    
    // background
    var overlay:UIImageView?
    var image:UIImage?
    var imageView: UIImageView?
    var gradient:GradientView?
    var exhibitHolder:UIView?
    var exhibitHolderTitle:UILabel?
    var twitterButton:UIButton?
    var facebookButton:UIButton?
    var exhibitList:UITableView?
    
    // active exhibits
    var activeExibition:TeaserThumbViewController?
    var exhibitThumbs = Array<TeaserThumbViewController>()
    
    // subviews
    var teaserData:TeaserSubViewController?
    var compassView:CompassViewController?
    var teaserHelpView:HelpPopupView?
    
    var spinner:UIActivityIndicatorView?
    
    
    var compasFooter:UIView?
    var infoPanel:InfoPanelViewController?
    
    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // buttons
    var scrollButton:UIButton?
    let buttonImage = UIImage(named: "name") as UIImage?
    
    // Location Services
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()

    // applicationModel
    let applicationModel = ApplicationData.sharedModel()
    
    // Location Services
    let locationServices = LocationSevices.locationServices()
    
    var eventData = Dictionary<String, String>()
    var museumList = Array<MuseumListComponentViewController>()
    var toTop:UIButton?
    var infoView:UIView?
    var compassButton:UIButton?
    
    // Effects
    var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
    
    
    @IBOutlet weak var ff: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.whiteColor()

        // Menu animations
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMenu:", name:"ShowMenuHandler", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "nearestMusuemChanged:", name:"NearestMusuemChanged", object: nil)
                
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "museumListUpdated:", name:"MuseumListCompletedHandler", object: nil)

        drawUI()
    }
    
    /*
    override func prefersStatusBarHidden() -> Bool {
        return true
    }*/
    
    // add the ui Elements
    func drawUI(){
        // bugfix
        view.backgroundColor = UIColor.blackColor()
        
    
        // create the scrollview
        scrollView = UIScrollView()
        scrollView!.contentSize = CGSize(width:screenSize.width, height: screenSize.height*2)
        scrollView!.frame = CGRect(x: 0, y: 240, width: screenSize.width, height: screenSize.height - 240)
        scrollView!.bounces = false
        scrollView!.backgroundColor = UIColor.clearColor()
        scrollView!.pagingEnabled = true
        scrollView!.delegate = self
        
        if(deviceFunctionService.deviceType == "ipad"){
            scrollView!.frame = CGRect(x: 0, y: 320, width: screenSize.width, height: screenSize.height - 240)
        }else{
            scrollView!.frame = CGRect(x: 0, y: 240, width: screenSize.width, height: screenSize.height - 240)
        }
        
        infoView = UIView()
        infoView!.backgroundColor = UIColor.whiteColor()
        infoView!.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        infoView!.hidden = true
        
        logoLabel = UILabel(frame: CGRect(x: 20, y: 150, width: 80, height: 60))
        logoLabel!.text = "MUSEA IN JOUW BUURT"
        logoLabel!.font = UIFont.boldSystemFontOfSize(33)
        logoLabel!.textColor = applicationModel.UIColorFromRGB(0x242424)
        logoLabel!.font =  UIFont (name: "DINAlternate-Bold", size: 18)
        logoLabel!.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
        logoLabel!.sizeToFit()
        
        image = UIImage(named: "loginBackground")
        imageView = UIImageView(frame: view.bounds)
        imageView?.image = image
        imageView?.center = view.center
        imageView?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        
    
        subtitleLabel = UILabel(frame: CGRect(x: 20, y: 220, width: screenSize.width - 40, height: 100))
        subtitleLabel!.numberOfLines = 4
        subtitleLabel!.lineBreakMode = .ByWordWrapping
        subtitleLabel!.text = "Wij zoeken momenteel naar het dichtstbijzijnde museum"
        subtitleLabel!.font =  UIFont (name: "HelveticaNeue-Light", size: 23)
        subtitleLabel!.textColor = UIColor.whiteColor()
        
        descriptionLabel = UILabel(frame: CGRect(x: 20, y: 240, width: screenSize.width - 40, height: 100))
        descriptionLabel!.numberOfLines = 3
        descriptionLabel!.lineBreakMode = .ByWordWrapping
        descriptionLabel!.text = "Zodra je in de ruimte bent zal deze app je automatisch naar het startscherm brengen"
        descriptionLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
        descriptionLabel!.textColor = UIColor()
        
        overlay = UIImageView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height));
        overlay!.backgroundColor = UIColor.blackColor()
        overlay!.alpha = 0.7;
        
        
        exhibitHolder = UIView(frame: CGRect(x: 0, y: screenSize.height-220, width: screenSize.width, height: 150))
        exhibitHolderTitle = UILabel(frame: CGRect(x: 20, y: 0, width: screenSize.width - 40, height: 40))
        exhibitHolderTitle!.numberOfLines = 1
        exhibitHolderTitle!.lineBreakMode = .ByWordWrapping
        exhibitHolderTitle!.text = "We hebben 1 actieve exhibitie gevonden"
        exhibitHolderTitle!.font =  UIFont (name: "HelveticaNeue-Light", size: 23)
        exhibitHolderTitle!.textColor = UIColor.whiteColor()
        exhibitHolderTitle!.textAlignment = .Center;
        exhibitHolderTitle?.backgroundColor = UIColor.redColor()
        exhibitHolderTitle?.hidden = true
    
        
        compasFooter = UIView()
        compasFooter?.frame = CGRect(x: 0, y: screenSize.height-130, width: screenSize.width, height: 130)
        compasFooter!.backgroundColor = applicationModel.UIColorFromRGB(0x5225d3)
        compasFooter?.alpha = 0.9
        
        
        scrollButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        scrollButton?.tintColor = UIColor.whiteColor()
        scrollButton!.setTitle(" Info", forState: UIControlState.Normal)
        scrollButton!.frame = CGRectMake(0, screenSize.height - 90, 130, 50)
        scrollButton!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        subtitleLabel!.font =  UIFont (name: "AvenirNext-Medium", size: 23)

        scrollButton!.titleLabel?.textAlignment = NSTextAlignment.Left;

        
        scrollButton!.backgroundColor = UIColor.clearColor()
        let scrollImage = UIImage(named: "ScrollDown") as UIImage?
        
        scrollButton?.setImage(scrollImage, forState: .Normal)
        
        
        twitterButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        facebookButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        twitterButton!.layer.cornerRadius = 25
        facebookButton!.layer.cornerRadius = 25
        
        var twitterImage = UIImage(named: "TwitterIcon") as UIImage?
        twitterButton?.setImage(twitterImage, forState: .Normal)
        twitterButton!.addTarget(self, action: "skip:", forControlEvents: UIControlEvents.TouchUpInside)

        twitterButton!.frame = CGRect(x: screenSize.width - 130, y: screenSize.height - compasFooter!.frame.height + 40, width: 50, height: 50)
        twitterButton!.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
        twitterButton!.imageView?.contentMode = UIViewContentMode.ScaleToFill;

        
        
        let facebookImage = UIImage(named: "FacebookIcon") as UIImage?
        facebookButton?.setImage(facebookImage, forState: .Normal)
        facebookButton!.frame = CGRect(x: screenSize.width - 70, y: screenSize.height - compasFooter!.frame.height + 40, width: 50, height: 50)
        facebookButton?.backgroundColor = UIColor.redColor()
        facebookButton!.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
        
    
        infoPanel = InfoPanelViewController(nibName: "InfoPanelViewController", bundle: nil)
        infoPanel?.view.frame = CGRect(x: 0, y: 60, width: screenSize.width, height: 133)
        
        var border = CALayer()
        var width = CGFloat(1)
        border.borderColor = applicationModel.UIColorFromRGB(0xc3c4bc).CGColor
        border.frame = CGRect(x: 0, y: infoPanel!.view.frame.size.height - width, width:  infoPanel!.view.frame.size.width, height: infoPanel!.view.frame.size.height)
        border.borderWidth = width
        infoPanel!.view.layer.addSublayer(border)
        infoPanel!.view.layer.masksToBounds = true
        
        
        // subview (additional content)
        teaserData = TeaserSubViewController(nibName: "TeaserSubViewController", bundle: nil)
        teaserData?.view.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height)

        self.addChildViewController(teaserData!)
        
        
        // compass
        compassView = CompassViewController(nibName: "CompassViewController", bundle: nil)
        compassView?.view.frame = CGRect(x: (screenSize.width/2)-(150/2), y: screenSize.height-122, width: 150, height: 150)
        compassView?.view.hidden = false
        
        
        // alternative layout for ipad
        if(deviceFunctionService.deviceType == "ipad"){
            logoLabel?.frame =  CGRect(x: 100, y: 280, width: 210, height: 40)
            logoLabel?.textAlignment = NSTextAlignment.Center
            
            subtitleLabel?.frame = CGRect(x: (screenSize.width-350)/2, y: 230, width: 350, height: 180)
            subtitleLabel?.textAlignment = NSTextAlignment.Center
        }else{
            logoLabel?.frame = CGRect(x: 10, y: 204, width: screenSize.width - 20, height: 34)
            logoLabel!.textAlignment = NSTextAlignment.Center;

            
            teaserData?.view.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height)
        }
        

        
        
        // add the components
        view.addSubview(imageView!)
        view.addSubview(overlay!)
        //scrollView.addSubview(visualEffectView)
        view.addSubview(logoLabel!)
        //scrollView.addSubview(subtitleLabel!)
        view.addSubview(exhibitHolder!)
        view.addSubview(teaserData!.view)
        view.addSubview(scrollView!)
        view.addSubview(infoPanel!.view)

        view.addSubview(infoView!)

        view.addSubview(compasFooter!)
        view.addSubview(compassView!.view)
        view.addSubview(twitterButton!)
        view.addSubview(facebookButton!)
        view.addSubview(scrollButton!)
        
        // load spinner
        spinner = UIActivityIndicatorView()
        spinner?.startAnimating()
        view.addSubview(spinner!)
        
        spinner!.frame = CGRect(x: screenSize.width/2, y: screenSize.height/2, width: 40, height: 40)
        //spinner!.center = view.center
        spinner!.hidesWhenStopped = true
        spinner!.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(spinner!)
        spinner!.startAnimating()
        
        
        exhibitHolder?.addSubview(exhibitHolderTitle!)

        eventData["icon"] = "hidden"
        NSNotificationCenter.defaultCenter().postNotificationName("MenuIcon", object: nil, userInfo:  eventData)
        
        // resetting when we load the page
        applicationModel.localExhibitSelected = false
        NSNotificationCenter.defaultCenter().postNotificationName("ShowBar", object: nil, userInfo:  nil)
        
        eventData["title"] = "ONTDEK MUSEA"
        NSNotificationCenter.defaultCenter().postNotificationName("SetTitle", object: nil, userInfo:  eventData)
        
        toTop = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        toTop!.tintColor = UIColor.whiteColor()
        toTop!.setTitle("Overzicht", forState: UIControlState.Normal)
        toTop!.frame = CGRectMake(0, 60, screenSize.width, 50)
        toTop!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        toTop!.backgroundColor = applicationModel.UIColorFromRGB(0xc6823a)
        toTop!.titleLabel?.textAlignment = NSTextAlignment.Left;
        toTop!.hidden = true
        view.addSubview(toTop!)
        

        
    
        compassButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        compassButton!.tintColor = UIColor.whiteColor()
        compassButton!.setTitle("", forState: UIControlState.Normal)
        compassButton!.frame = CGRectMake(compassView!.view.frame.origin.x, compassView!.view.frame.origin.y, compassView!.view.frame.width, compassView!.view.frame.height)
        compassButton!.addTarget(self, action: "compassTouch:", forControlEvents: UIControlEvents.TouchUpInside)
        compassButton!.backgroundColor = UIColor.clearColor()
        compassButton!.titleLabel?.textAlignment = NSTextAlignment.Left;
        view.addSubview(compassButton!)
        
    }

    /**
    * Create the UI
    */
    func compassTouch(sender:UIButton!)
    {
        NSNotificationCenter.defaultCenter().postNotificationName("ShowMapPopup", object: nil, userInfo:  nil)

    }
    
    
    
    func museumListUpdated(notification:NSNotification){
     
        println("updated the musuem list")
        
        // now render the list
        
        // add museum list
        var counter = 0
        var yPos:CGFloat = 0
        // if mobile
        if(deviceFunctionService.deviceType == "ipad"){
            yPos = 30
        }else{
            yPos = 0
        }

        
        // hide the spinner
        spinner!.stopAnimating()
        spinner!.hidden = true
        
        
        var muCount:Int = 0
        for musuemd in locationServices.musArray{
            
            // println("index is \(index)")
            if(muCount < 9){
                var museum:MuseumListComponentViewController = MuseumListComponentViewController(nibName: "MuseumListComponentViewController", bundle: nil)
                
                
                if(deviceFunctionService.deviceType == "ipad"){
                    museum.view.frame = CGRect(x: 100, y: yPos, width: (screenSize.width) - 200, height: 95)
                }else{
                    museum.view.frame = CGRect(x: 100, y: yPos, width: (screenSize.width/100) * 80, height: 95)
                }
                

                
                museum.titleField?.text = musuemd.museum_title
                museum.listCount.text = String(muCount + 1)
                museum.view.tag = muCount
                museum.museumModel = musuemd
                museum.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleGestureTouch:"))
                
                museumList.append(museum)
                
                var distance = round(musuemd.museum_dis!)
                if(distance < locationServices.distanceVar){
                    
                    museum.activeDot?.hidden = false
                    
                    
                }
                
                let name: String = distance.description
                museum.distanceField.text = name
                
                // if mobile
                if(deviceFunctionService.deviceType == "ipad"){
                    
                }else{
                    museum.view.frame = CGRect(x: 0, y: yPos, width: screenSize.width, height: 95)

                }
                
                scrollView!.addSubview(museum.view)
                
                yPos = yPos + museum.view.frame.height
                muCount++
            }
        }
        
    }
    

    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        /*
        if(scrollView.contentOffset.y >= screenSize.height){
            eventData["showToolBar"] = "true"
            eventData["menuTitle"] = "true"
            eventData["menuTitleString"] = "Beschikbare Musea"
            
            NSNotificationCenter.defaultCenter().postNotificationName("ToggleMenuBar", object: nil, userInfo:  eventData)
            
            toTop!.hidden = false
            
            // scroll to point
            scrollView.setContentOffset(CGPointMake(0, screenSize.height), animated: true)
            
            var scrollImage:UIImage = UIImage(named: "ScrollUp") as UIImage!
            scrollButton?.setImage(scrollImage, forState: .Normal)
            toTop!.hidden = false
        }else{
            eventData["showToolBar"] = "true"
            eventData["menuTitle"] = "false"
            eventData["menuTitleString"] = ""
            
            NSNotificationCenter.defaultCenter().postNotificationName("ToggleMenuBar", object: nil, userInfo:  eventData)
            
            toTop!.hidden = true
        }*/
    }
    

    func getNearestMuseum(){
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
    }
    
    func handleGestureTouch(gestureRecognizer: UITapGestureRecognizer){

        // handle the taps
        println("taaaaaaggggg")
        println(gestureRecognizer.view?.tag)
        
        var selectedMuseum:MuseumListComponentViewController = museumList[gestureRecognizer.view!.tag]
            println(selectedMuseum.museumModel?.exhibitData)
        
            applicationModel.selectedMuseum = selectedMuseum.museumModel
       
        
            eventData["title"] = selectedMuseum.museumModel?.museum_title
        NSNotificationCenter.defaultCenter().postNotificationName("SetTitle", object: nil, userInfo:  eventData)
        
            selectedMuseum.activeDot?.hidden = false
            eventData["menu"] = "overview"
        NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
        
            eventData["icon"] = "teaser"
        NSNotificationCenter.defaultCenter().postNotificationName("MenuIcon", object: nil, userInfo:  eventData)
        
            eventData["icon"] = "hidden"
        NSNotificationCenter.defaultCenter().postNotificationName("RightIcon", object: nil, userInfo:  eventData)
        
        //
        applicationModel.localExhibitSelected = false
        locationServices.beaconSearching = true
    
    }

    /**
    * Create the UI
    */
    func buttonAction(sender:UIButton!)
    {
        var scrollImage:UIImage
        
        
        
        if(scrollView!.contentOffset.y > 0){
            // scroll to point
            scrollView!.setContentOffset(CGPointMake(0, 0), animated: true)

            scrollImage = UIImage(named: "ScrollDown") as UIImage!
            scrollButton?.setImage(scrollImage, forState: .Normal)
            toTop!.hidden = true

            
            
            UIView.animateWithDuration(0.3, delay: 0, options: nil, animations: {
                self.infoView!.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: self.screenSize.height)
                
                return
                }, completion: { finished in
                    self.infoView!.hidden = true
            })

        }else{
            // scroll to point
            scrollView!.setContentOffset(CGPointMake(0, screenSize.height), animated: true)

            scrollImage = UIImage(named: "ScrollUp") as UIImage!
            scrollButton?.setImage(scrollImage, forState: .Normal)
            toTop!.hidden = false
            infoView?.hidden = false

            infoView!.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height)
            toTop!.alpha = 0
            toTop?.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)

            UIView.animateWithDuration(0.3, delay: 0, options: nil, animations: {
                self.infoView!.frame = CGRect(x: 0, y: 0, width: self.screenSize.width, height: self.screenSize.height)
                self.toTop!.alpha = 1
                return
                }, completion: { finished in
                    println("Basket doors opened!")
            })
            
        }
    }
    
    func skip(sender:UIButton!)
    {
        // scroll to point
        eventData["menu"] = "exhibit"
        NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
        
    }
    
    
    
    /// super super hero I'm in cafe nero
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
    * Menu animation
    */
    func nearestMusuemChanged(ns: NSNotification){
        
        println("ik ben hier")
    
        var conversion = applicationModel.nearestMuseum!.museum_dis?.format(".2")
        var string = NSString(string: conversion!)
        
        //logoLabel?.text = applicationModel.nearestMuseum?.museum_title
        subtitleLabel?.text = "Je bent op " + (string as String) + "Km van " + applicationModel.nearestMuseum!.museum_title + ", zodra je in het museum bent zal de app je begeleiden"
        
        compassView?.compasLabel.text = (string as String) + "Km"
        compassView?.updateMapkit()
        compassView?.view.hidden = false
        
        if(applicationModel.nearestMuseum!.museum_dis < locationServices.distanceVar){
            
            let url = NSURL(string: ( applicationModel.nearestMuseum!.museum_cover))
            
            if((url) != nil && url != ""){
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            
            //visualEffectView.alpha = 1
            UIView.animateWithDuration(2, delay: 0, options: nil, animations: {
                // Place the UIViews we want to animate here (use x, y, width, height, alpha)
                //self.visualEffectView.alpha = 0

                return
                }, completion: { finished in
                // the animation is complete
               // self.visualEffectView.removeFromSuperview()
            })
            
                
            imageView?.image = UIImage(data: data!)
            imageView?.contentMode = .ScaleAspectFit
            imageView?.frame = view.bounds
            imageView?.center = view.center
            imageView?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height-140)
            imageView?.center = view.center
            imageView?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
            imageView?.contentMode = UIViewContentMode.ScaleAspectFill
            }
            
        }else{
            
            println("het is kleiner")
            
        }
        
        println(applicationModel.nearestMuseum!.museum_dis)
        println(locationServices.distanceVar)

        // add exhibition thumbs
        var xPos:Int = 0
        var count:Int = 0
        var tWidth:Int = 0
        for exhibition in applicationModel.nearestMuseum!.exhibitData{
            
            if(count == 0){
                // add cover (if image present)
            }
        
            count++
        }
        
        if(applicationModel.nearestMuseum!.exhibitData.count > 1){
            exhibitHolderTitle?.text = "Er werden " + String(count) + " exhibities gevonden"
        }else if(applicationModel.nearestMuseum!.exhibitData.count == 1){
            exhibitHolderTitle?.text = "Er werd " + String(count) + " exhibitie gevonden"
        }else{
            exhibitHolderTitle?.text = "Er werden geen exhibities gevonden"

        }
    }


    
    
    /**
    * Menu animation
    */
    func showMenu(notification: NSNotification){
        var myView = self.view

        /*UIView.animateWithDuration(0.7, delay: 0, options: nil, animations: {
            myView.frame = CGRect(x:0, y:self.screenSize.height-100, width:self.screenSize.width, height:self.screenSize.height)
            return
            }, completion: { finished in
                println("Basket doors opened!")
        })*/
    }

    func toggleMenu(notification: NSNotification){

    }
    
    /**
    * Hide status bar
    */
/*    override func prefersStatusBarHidden() -> Bool {
        return true
    }*/
}

extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}



