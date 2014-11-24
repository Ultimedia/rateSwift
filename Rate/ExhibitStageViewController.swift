//
//  ExhibitStageViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 19/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class ExhibitStageViewController: UIViewController {

    
    // use this to pass on the model
    var exhibitionModel: ExhibitionModel? = nil
    
    
    // data?
    var dataObject: Dictionary<String, String> = Dictionary()
    var label: UILabel?
    
    
    // cover image (intro slide)
    var overlay:UIImageView?
    var coverImage:UIImage?
    var coverImageView: UIImageView?
    
    
    // Labels
    var museumLabel: UILabel?
    var exhibitionTitleLabel: UILabel?
    var descriptionLabel: UILabel?
    var tes: UILabel?

    
    // buttons
    var twitterButton:UIButton?
    var facebookButton:UIButton?
    
    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        // make it black
        view.backgroundColor = UIColor.redColor()
        
        /**
        * Intro
        */
        if(dataObject["type"] == "intro"){
        
            
            // create cover background
            overlay = UIImageView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height));
            overlay!.backgroundColor = UIColor.blackColor()
            overlay!.alpha = 0.5;
            
            
            // add cover image
            coverImage = UIImage(named:"cover")
            coverImageView =  UIImageView(frame: view.bounds)
            coverImageView!.image = coverImage
            coverImageView!.center = view.center

            
            // logo label
            museumLabel = UILabel(frame: CGRect(x: 20, y: 60, width: screenSize.width - 40, height: 60))
            museumLabel!.text = exhibitionModel?.museumTitle
            museumLabel!.font = UIFont.boldSystemFontOfSize(44)
            museumLabel!.textColor = UIColor.whiteColor()
            
            
            // subtitle
            exhibitionTitleLabel = UILabel(frame: CGRect(x: 20, y: 80, width: screenSize.width - 40, height: 100))
            exhibitionTitleLabel!.numberOfLines = 3
            exhibitionTitleLabel!.lineBreakMode = .ByWordWrapping
            exhibitionTitleLabel!.text = exhibitionModel?.exhibitonTitle
            exhibitionTitleLabel!.font =  UIFont (name: "HelveticaNeue-Light", size: 23)
            exhibitionTitleLabel!.textColor = UIColor.whiteColor()
            
            
            // description
            descriptionLabel = UILabel(frame: CGRect(x: 20, y: 240, width: screenSize.width - 40, height: screenSize.height - 200))
            descriptionLabel!.numberOfLines = 8
            descriptionLabel!.lineBreakMode = .ByWordWrapping
            descriptionLabel!.text = exhibitionModel?.exhibitionDescription
            descriptionLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
            descriptionLabel!.textColor = UIColor.whiteColor()
            descriptionLabel!.sizeToFit()
            
            
            // add images
            view.addSubview(coverImageView!)
            view.addSubview(overlay!)
            view.addSubview(museumLabel!)
            view.addSubview(exhibitionTitleLabel!)
            view.addSubview(descriptionLabel!)
            
            
            /**
            * Social media content
            */
            if(exhibitionModel?.twitterEnabled == true){
                
                // Twitter button
                twitterButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
                twitterButton!.setTitle("Twitter", forState: UIControlState.Normal)
                twitterButton!.frame = CGRectMake(20, screenSize.height - 70, 100, 30)
                twitterButton!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                twitterButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                twitterButton?.backgroundColor = UIColor.blueColor()
                
                view.addSubview(twitterButton!)
            }
            
            
            if(exhibitionModel?.facebookEnabled == true){
                facebookButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
                facebookButton!.setTitle("Facebook", forState: UIControlState.Normal)
                
                if(exhibitionModel?.twitterEnabled == true){
                    facebookButton!.frame = CGRectMake(140, screenSize.height - 70, 100, 30)
                }else{
                    twitterButton!.frame = CGRectMake(20, screenSize.height - 70, 100, 30)
                }
                facebookButton!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                facebookButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                facebookButton?.backgroundColor = UIColor.blueColor()
                
                view.addSubview(facebookButton!)
            }
            
            
        }else if(dataObject["type"] == "room"){
            println("room")
            
            // description
            tes = UILabel(frame: CGRect(x: 20, y: 240, width: screenSize.width - 40, height: screenSize.height - 200))
            tes!.numberOfLines = 8
            tes!.lineBreakMode = .ByWordWrapping
            tes!.text = exhibitionModel?.exhibitionDescription
            tes!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
            tes!.textColor = UIColor.whiteColor()
            tes!.sizeToFit()
            view.addSubview(tes!)

            
        }else if(dataObject["type"] == "exit"){
            println("exit")
        }
    }
}

