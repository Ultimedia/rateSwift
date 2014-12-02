//
//  TeaserViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 19/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class TeaserViewController: UIViewController {
    
    // scrollview
    @IBOutlet weak var scrollView: UIScrollView!
    
    // labels
    var logoLabel: UILabel?
    var subtitleLabel: UILabel?
    var descriptionLabel: UILabel?
    
    // background
    var overlay:UIImageView?
    var image:UIImage?
    var imageView: UIImageView?
    
    // subviews
    var teaserData:TeaserSubViewController?
    var compassView:CompassViewController?
    
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
    
    
    @IBOutlet weak var ff: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.whiteColor()

        // Menu animations
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMenu:", name:"ShowMenuHandler", object: nil)

        
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
        scrollView.contentSize = CGSize(width:screenSize.width, height: screenSize.height*2)
        scrollView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.pagingEnabled = true
        
        logoLabel = UILabel(frame: CGRect(x: 20, y: 120, width: screenSize.width - 40, height: 60))
        logoLabel!.text = "Prototype"
        logoLabel!.font = UIFont.boldSystemFontOfSize(44)
        logoLabel!.textColor = UIColor.whiteColor()
        
        image = UIImage(named: "cover")
        imageView = UIImageView(frame: view.bounds)
        imageView?.image = image
        imageView?.center = view.center
        imageView?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height-100)
    
        subtitleLabel = UILabel(frame: CGRect(x: 20, y: 180, width: screenSize.width - 40, height: 100))
        subtitleLabel!.numberOfLines = 3
        subtitleLabel!.lineBreakMode = .ByWordWrapping
        subtitleLabel!.text = "Bezoek een van de ondersteunende musea om deze app te gebruiken"
        subtitleLabel!.font =  UIFont (name: "HelveticaNeue-Light", size: 23)
        subtitleLabel!.textColor = UIColor.whiteColor()
        
        descriptionLabel = UILabel(frame: CGRect(x: 20, y: 240, width: screenSize.width - 40, height: 100))
        descriptionLabel!.numberOfLines = 3
        descriptionLabel!.lineBreakMode = .ByWordWrapping
        descriptionLabel!.text = "Zodra je in de ruimte bent zal deze app je automatisch naar het startscherm brengen"
        descriptionLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
        descriptionLabel!.textColor = UIColor.whiteColor()
        
        overlay = UIImageView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height-110));
        overlay!.backgroundColor = UIColor.redColor()
        overlay!.alpha = 0.2;
        
        scrollButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        scrollButton!.setTitle("Bekijk de beschikbare musea", forState: UIControlState.Normal)
        scrollButton!.frame = CGRectMake(0, screenSize.height - 50, screenSize.width, 50)
        scrollButton!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        

        
        // subview (additional content)
        teaserData = TeaserSubViewController(nibName: "TeaserSubViewController", bundle: nil)
        teaserData?.view.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height)
        self.addChildViewController(teaserData!)
        
        
        
        // compass
        compassView = CompassViewController(nibName: "CompassViewController", bundle: nil)
        compassView?.view.frame = CGRect(x: (screenSize.width/2)-(150/2), y: screenSize.height-180, width: 150, height: 150)
        
        
        
        
        // alternative layout for ipad
        if(deviceFunctionService.deviceType == "ipad"){
            subtitleLabel?.frame = CGRect(x: 20, y: 180, width: screenSize.width/2, height: 100)
            subtitleLabel?.numberOfLines = 2
            subtitleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        }
        
        
        // add the components
        scrollView.addSubview(imageView!)
        scrollView.addSubview(overlay!)
        scrollView.addSubview(logoLabel!)
        scrollView.addSubview(subtitleLabel!)
        scrollView.addSubview(descriptionLabel!)
        scrollView.addSubview(scrollButton!)
        scrollView.addSubview(teaserData!.view)
        scrollView.addSubview(compassView!.view)
    }

    
    func getNearestMuseum(){
        
    }
    
    
    /**
    * Create the UI
    */
    func buttonAction(sender:UIButton!)
    {
        // scroll to point
        scrollView.setContentOffset(CGPointMake(0, screenSize.height), animated: true)
    }
    
    
    /// super super hero I'm in cafe nero
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    

}
