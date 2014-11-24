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
    
    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // buttons
    var scrollButton:UIButton?
    
    @IBOutlet weak var ff: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.whiteColor()
        
        drawUI()
    }
    
    /*
    override func prefersStatusBarHidden() -> Bool {
        return true
    }*/
    
    // add the ui Elements
    func drawUI(){
    
        
        // create the scrollview
        scrollView.contentSize = CGSize(width:screenSize.width, height: 2000)
        scrollView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.blackColor()
        
        
        logoLabel = UILabel(frame: CGRect(x: 20, y: 60, width: screenSize.width - 40, height: 60))
        logoLabel!.text = "Prototype"
        logoLabel!.font = UIFont.boldSystemFontOfSize(44)
        logoLabel!.textColor = UIColor.whiteColor()
        
        
        image = UIImage(named: "cover")
        imageView = UIImageView(frame: view.bounds)
        imageView?.image = image
        imageView?.center = view.center
    
        
        subtitleLabel = UILabel(frame: CGRect(x: 20, y: 120, width: screenSize.width - 40, height: 100))
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
        
        
        overlay = UIImageView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height));
        overlay!.backgroundColor = UIColor.redColor()
        overlay!.alpha = 0.2;
        
        
        scrollButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        scrollButton!.setTitle("Bekijk de beschikbare musea", forState: UIControlState.Normal)
        scrollButton!.frame = CGRectMake(0, screenSize.height - 70, screenSize.width, 50)
        scrollButton!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        

        // subview (additional content)
        teaserData = TeaserSubViewController(nibName: "TeaserSubViewController", bundle: nil)
        teaserData?.view.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 800)
        self.addChildViewController(teaserData!)
        
        
        // add the components
        scrollView.addSubview(imageView!)
        scrollView.addSubview(overlay!)
        scrollView.addSubview(logoLabel!)
        scrollView.addSubview(subtitleLabel!)
        scrollView.addSubview(descriptionLabel!)
        scrollView.addSubview(scrollButton!)
        scrollView.addSubview(teaserData!.view)
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


}
