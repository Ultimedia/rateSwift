//
//  TeaserViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 19/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit
import Social

class TeaserViewController: UIViewController, UIScrollViewDelegate {
    
    // scrollview
    var scrollView: UIScrollView?
    
    // labels
    var logoLabel: UILabel?
    var subtitleLabel: UILabel?
    var descriptionLabel: UILabel?
    
    var infoLabel1: UILabel?
    var infoLabel2: UILabel?
    var infoLabel3: UILabel?

    
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
    var museumArray = Array<MuseumListComponentViewController>()
    
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
    var infoView:UIScrollView?
    var infoTitle:UILabel?
    var compassButton:UIButton?
    var scrollImage:UIImage?
    
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
        
        
        println("drawing UI")
    
        // create the scrollview
        scrollView = UIScrollView()
        scrollView!.contentSize = CGSize(width:screenSize.width, height: screenSize.height*2)
        scrollView!.frame = CGRect(x: 0, y: 240, width: screenSize.width, height: screenSize.height - 240)
        scrollView!.bounces = true
        scrollView!.backgroundColor = UIColor.clearColor()
        scrollView!.pagingEnabled = true
        scrollView!.delegate = self
        
        if(deviceFunctionService.deviceType == "ipad"){
            scrollView!.frame = CGRect(x: 0, y: 320, width: screenSize.width, height: screenSize.height - 240)
        }else{
            scrollView!.frame = CGRect(x: 0, y: 240, width: screenSize.width, height: screenSize.height - 240)
        }
        
        infoView = UIScrollView()
        infoView!.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)

        infoView!.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        infoView!.contentSize = CGSize(width: screenSize.width, height: screenSize.height * 2)
        infoView!.hidden = true
        
        infoTitle = UILabel(frame: CGRect(x: 20, y: 150, width: 80, height: 60))
        infoTitle!.text = "Test test"
        infoTitle!.font = UIFont.boldSystemFontOfSize(33)
        infoTitle!.textColor = applicationModel.UIColorFromRGB(0x242424)
        infoTitle!.font =  UIFont (name: "DINAlternate-Bold", size: 18)
        //infoView!.addSubview(infoTitle!)
        
        var logoLabelTitle:UILabel
            logoLabelTitle = UILabel(frame: CGRect(x: 0, y: 80, width: screenSize.width, height: 60))
            logoLabelTitle.text = "Info"
            logoLabelTitle.font = UIFont.boldSystemFontOfSize(44)
            logoLabelTitle.textColor = applicationModel.UIColorFromRGB(0x222222)
            logoLabelTitle.font =  UIFont (name: "Futura-Medium", size: 30)
            logoLabelTitle.textAlignment = NSTextAlignment.Center
        
        infoView!.addSubview(logoLabelTitle)
        
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 12
        
        var attrString = NSMutableAttributedString(string: "De app gaat via GPS opzoek naar verschillende musea in de buurt.")
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        var attrString2 = NSMutableAttributedString(string: "In deze musea hebben wij sensoren aangebracht die door middel van Bluetooth verbinding maken met uw toestel.")
        attrString2.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString2.length))
        
        var attrString3 = NSMutableAttributedString(string: "Wanneer uw toestel de signalen van de sensoren opvangt zal deze mobiele app u automatisch begeleiden en extra informatie aanbieden.")
        attrString3.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString3.length))

        
        logoLabel = UILabel(frame: CGRect(x: 20, y: 150, width: 80, height: 60))
        logoLabel!.text = "MUSEA IN JOUW BUURT"
        logoLabel!.font = UIFont.boldSystemFontOfSize(33)
        logoLabel!.textColor = applicationModel.UIColorFromRGB(0x242424)
        logoLabel!.font =  UIFont (name: "DINAlternate-Bold", size: 18)
        logoLabel!.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
        logoLabel!.sizeToFit()
        
        
        var borderTop:UIView?
        var borderTop2:UIView?
        var borderTop3:UIView?

        
        var infoCircle1:UIView = UIView(frame: CGRect(x: (screenSize.width / 2) - (50 / 2), y: 150, width: 50, height: 50))
            infoCircle1.backgroundColor = UIColor.blackColor()
            infoCircle1.layer.cornerRadius = 25
        
        var infoCircleLabel:UILabel = UILabel(frame: CGRect(x: (screenSize.width / 2) - (50 / 2), y: 150, width: 50, height: 50))
            infoCircleLabel.text = "1"
            infoCircleLabel.textColor = UIColor.whiteColor()
            infoCircleLabel.textAlignment = NSTextAlignment.Center
            infoCircleLabel.font =  UIFont (name: "Georgia-Italic", size: 30)

        infoLabel1 = UILabel(frame: CGRect(x: 40, y: infoCircle1.frame.origin.y + infoCircle1.frame.height - 10, width: screenSize.width - 80, height: 140))
        infoLabel1!.numberOfLines = 4
        infoLabel1!.text = ""
        infoLabel1!.font =  UIFont (name: "Georgia-Italic", size: 23)
        infoLabel1!.textColor = applicationModel.UIColorFromRGB(0x222222)
        infoLabel1?.attributedText = attrString
        infoView!.addSubview(infoLabel1!)

        
        var infoCircle2:UIView = UIView(frame: CGRect(x: (screenSize.width / 2) - (50 / 2), y: 350, width: 50, height: 50))
        infoCircle2.backgroundColor = UIColor.blackColor()
        infoCircle2.layer.cornerRadius = 25
        
        var infoCircleLabel2:UILabel = UILabel(frame: CGRect(x: (screenSize.width / 2) - (50 / 2), y: 350, width: 50, height: 50))
        infoCircleLabel2.text = "2"
        infoCircleLabel2.textColor = UIColor.whiteColor()
        infoCircleLabel2.textAlignment = NSTextAlignment.Center
        infoCircleLabel2.font =  UIFont (name: "Georgia-Italic", size: 30)
        
        
        infoLabel2 = UILabel(frame: CGRect(x: 40, y: infoCircle2.frame.origin.y + infoCircle2.frame.height, width: screenSize.width - 80, height: 200))
        infoLabel2!.numberOfLines = 5
        infoLabel2!.text = ""
        infoLabel2!.font =  UIFont (name: "Georgia-Italic", size: 23)
        infoLabel2!.textColor = applicationModel.UIColorFromRGB(0x222222)
        infoLabel2?.attributedText = attrString2
        infoView!.addSubview(infoLabel2!)
        
        
        
        var infoCircle3:UIView = UIView(frame: CGRect(x: (screenSize.width / 2) - (50 / 2), y: 630, width: 50, height: 50))
        infoCircle3.backgroundColor = UIColor.blackColor()
        infoCircle3.layer.cornerRadius = 25
        
        var infoCircleLabel3:UILabel = UILabel(frame: CGRect(x: (screenSize.width / 2) - (50 / 2), y: 630, width: 50, height: 50))
        infoCircleLabel3.text = "3"
        infoCircleLabel3.textColor = UIColor.whiteColor()
        infoCircleLabel3.textAlignment = NSTextAlignment.Center
        infoCircleLabel3.font =  UIFont (name: "Georgia-Italic", size: 28)
        
        
        infoLabel3 = UILabel(frame: CGRect(x: 40, y: infoCircle3.frame.origin.y + infoCircle3.frame.height - 10, width: screenSize.width - 80, height: 250))
        infoLabel3!.numberOfLines = 10
        infoLabel3!.text = ""
        infoLabel3!.font =  UIFont (name: "Georgia-Italic", size: 23)
        infoLabel3!.textColor = applicationModel.UIColorFromRGB(0x222222)
        infoLabel3?.attributedText = attrString3
        infoView!.addSubview(infoLabel3!)
        
        borderTop = UIView(frame: CGRect(x: infoLabel1!.frame.origin.x, y: infoLabel1!.frame.origin.y - 10, width: infoLabel1!.frame.width, height: 1))
        borderTop?.backgroundColor = applicationModel.UIColorFromRGB(0x222222)

        borderTop2 = UIView(frame: CGRect(x: infoLabel1!.frame.origin.x, y: infoLabel2!.frame.origin.y - 20, width: infoLabel2!.frame.width, height: 1))
        borderTop2?.backgroundColor = applicationModel.UIColorFromRGB(0x222222)
        
        borderTop3 = UIView(frame: CGRect(x: infoLabel3!.frame.origin.x, y: infoLabel3!.frame.origin.y - 10, width: infoLabel3!.frame.width, height: 1))
        borderTop3?.backgroundColor = applicationModel.UIColorFromRGB(0x222222)

        
        if(deviceFunctionService.deviceType == "ipad"){

            infoLabel1!.frame = CGRect(x: 40, y: infoCircle1.frame.origin.y + infoCircle1.frame.height - 10, width: screenSize.width - 400, height: 100)
            
            infoLabel2!.frame = CGRect(x: 40, y: infoCircle2.frame.origin.y + infoCircle2.frame.height - 10, width: screenSize.width - 400, height: 200)

            infoLabel3!.frame = CGRect(x: 40, y: infoCircle3.frame.origin.y + infoCircle3.frame.height - 10, width: screenSize.width - 400, height: 200)
            
        }
        
        
        infoView!.addSubview(borderTop!)
        infoView!.addSubview(infoCircle1)
        infoView!.addSubview(infoCircleLabel)

        infoView!.addSubview(borderTop2!)
        infoView!.addSubview(infoCircle2)
        infoView!.addSubview(infoCircleLabel2)
        
        infoView!.addSubview(borderTop3!)
        infoView!.addSubview(infoCircle3)
        infoView!.addSubview(infoCircleLabel3)
        
        image = UIImage(named: "loginBackground")
        if(deviceFunctionService.deviceType != "ipad"){
            image = UIImage(named: "loginBackgroundMobile")
        }
        
        imageView = UIImageView(frame: view.bounds)
        imageView?.image = image
        imageView?.center = view.center
        imageView?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        imageView?.contentMode = UIViewContentMode.ScaleToFill
    
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
        scrollImage = UIImage(named: "ScrollDown") as UIImage!
        scrollButton?.setImage(scrollImage, forState: .Normal)
        
        
        twitterButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        facebookButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        twitterButton!.layer.cornerRadius = 25
        facebookButton!.layer.cornerRadius = 25
        
        var twitterImage = UIImage(named: "TwitterIcon") as UIImage?
        twitterButton?.setImage(twitterImage, forState: .Normal)
        twitterButton!.addTarget(self, action: "shareTwitter:", forControlEvents: UIControlEvents.TouchUpInside)

        twitterButton!.frame = CGRect(x: screenSize.width - 130, y: screenSize.height - compasFooter!.frame.height + 40, width: 50, height: 50)
        twitterButton!.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
        twitterButton!.imageView?.contentMode = UIViewContentMode.ScaleToFill;
        
        
        let facebookImage = UIImage(named: "FacebookIcon") as UIImage?
        facebookButton?.setImage(facebookImage, forState: .Normal)
        facebookButton!.frame = CGRect(x: screenSize.width - 70, y: screenSize.height - compasFooter!.frame.height + 40, width: 50, height: 50)
        facebookButton!.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
        facebookButton!.addTarget(self, action: "shareFacebook:", forControlEvents: UIControlEvents.TouchUpInside)
    
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
        

        SwiftSpinner.show("Musea ophalen")
        exhibitHolder?.addSubview(exhibitHolderTitle!)

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
        
        
        // reset if needed
        if(museumArray.count > 0){
            for ms in museumArray{
                ms.removeFromParentViewController()
                ms.view.removeFromSuperview()
            }
        }
        
        museumArray.removeAll(keepCapacity: true)
        
        
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
        //spinner!.stopAnimating()
        //spinner!.hidden = true
        SwiftSpinner.hide()

        
        var starting:Bool = true
        var muCount:Int = 0
        for musuemd in locationServices.musArray{
            
            // println("index is \(index)")
            if(muCount < 9){
        
                var museum:MuseumListComponentViewController = MuseumListComponentViewController(nibName: "MuseumListComponentViewController", bundle: nil)
                
                
                if(deviceFunctionService.deviceType == "ipad"){
                    museum.view.frame = CGRect(x: 100, y: yPos, width: (screenSize.width) - 200, height: 95)
                    museum.listWidth = (screenSize.width) - 200
                }else{
                    museum.view.frame = CGRect(x: 10, y: yPos, width: screenSize.width - 20, height: 95)
                    museum.listWidth = screenSize.width - 20
                }
                
                museum.titleField?.text = musuemd.museum_title
                museum.listCount.text = String(muCount + 1)
                museum.view.tag = muCount
                museum.museumModel = musuemd
                museum.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleGestureTouch:"))
                
                museumList.append(museum)
        
                if(starting){
                    starting = false
                    museum.starting = true
                }
                
                
                var distance = round(musuemd.museum_dis!)
                let name: String = distance.description
                museum.distanceField.text = name + "Km"

                
                if(distance < locationServices.distanceVar){
                    museum.activeDot?.hidden = false
                    println("show activedots")
                    
                }else{
                    museum.view.alpha = 0.4
                }
                
                if(distance == 0){
                    museum.distanceField.text =  "120m"
                }else if(distance < locationServices.distanceVar){
                    museum.distanceField.text = name + "Km"
                }
                
                // if mobile
                if(deviceFunctionService.deviceType == "ipad"){
                    
                }else{
                    museum.view.frame = CGRect(x: 0, y: yPos, width: screenSize.width, height: 95)

                }
                
                scrollView!.addSubview(museum.view)
                
                // add to array
                museumArray.append(museum)
                
                yPos = yPos + museum.view.frame.height
                muCount++
                
                museum.reposition()
            }
            
            scrollView!.contentSize = CGSize(width:screenSize.width, height: CGFloat(95 * muCount) + 200)
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
        var selectedMuseum:MuseumListComponentViewController = museumList[gestureRecognizer.view!.tag]
            println(selectedMuseum.museumModel?.exhibitData)
        
            applicationModel.selectedMuseum = selectedMuseum.museumModel
        
        
        if(selectedMuseum.activeDot?.hidden == false){
            eventData["title"] = selectedMuseum.museumModel?.museum_title
        NSNotificationCenter.defaultCenter().postNotificationName("SetTitle", object: nil, userInfo:  eventData)
        
            selectedMuseum.activeDot?.hidden = false
            eventData["menu"] = "overview"
        NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
        
            eventData["icon"] = "teaser"
        NSNotificationCenter.defaultCenter().postNotificationName("MenuIcon", object: nil, userInfo:  eventData)
        
            /*
            eventData["icon"] = "hidden"
        NSNotificationCenter.defaultCenter().postNotificationName("RightIcon", object: nil, userInfo:  eventData)*/
        
        //
        applicationModel.localExhibitSelected = false
        locationServices.beaconSearching = true
        }
    }

    /**
    * Create the UI
    */
    func buttonAction(sender:UIButton!)
    {
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
            toTop!.hidden = true
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
    
    func shareFacebook(sender:UIButton){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
                fbShare.setInitialText("Ik heb " + String(museumArray.count) + " museums gevonden met de MuseumTracker app")

            
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func shareTwitter(sender:UIButton){
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            
            var tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
                tweetShare.setInitialText("Ik heb " + String(museumArray.count) + " museums gevonden met de MuseumTracker app")
            
            self.presentViewController(tweetShare, animated: true, completion: nil)
            
        } else {
            
            var alert = UIAlertController(title: "Geen Account", message: "Ga naar instellingen en meld je aan om te Tweeten", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
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
        
        var conversion = applicationModel.nearestMuseum!.museum_dis?.format(".2")
        var string = NSString(string: conversion!)
        
        //logoLabel?.text = applicationModel.nearestMuseum?.museum_title
        subtitleLabel?.text = "Je bent op " + (string as String) + "Km van " + applicationModel.nearestMuseum!.museum_title + ", zodra je in het museum bent zal de app je begeleiden"
        
        compassView?.compasLabel.text = (string as String) + "Km"
        compassView?.updateMapkit()
        compassView?.view.hidden = false
        
        // don't need this feature
        if(applicationModel.nearestMuseum!.museum_dis < locationServices.distanceVar){
            /*
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
            
            }*/
            
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



