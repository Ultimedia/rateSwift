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
    var roomModel:RoomModel? = nil
    var exhibitModel:ExhibitModel? = nil
    
    // data?
    var label: UILabel?
    
    // cover image (intro slide)
    var overlay:UIImageView?
    var coverImage:UIImage?
    var coverImageView: UIImageView?
    
    // Labels
    var museumLabel: UILabel?
    var exhibitionTitleLabel: UILabel?
    var descriptionLabel: UILabel?
    var roomTitle: UILabel?
    var commentButton: UIButton?


    // buttons
    var twitterButton:UIButton?
    var facebookButton:UIButton?
    var closeButton:UIButton?

    
    
    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds

    // Singleton Models
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()
    
    // Feedback viewController
    var feedbackViewController:FeedbackViewController?

    
    
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
    
        // close feedback 
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeFeedbackPanel:", name:"CloseFeedbackPanel", object: nil)
        


        
        
        // initialise the feedback view controller
        feedbackViewController = FeedbackViewController(nibName: "FeedbackViewController", bundle: nil)
        feedbackViewController?.roomModel = roomModel
        feedbackViewController?.exhibitModel = exhibitModel
        
        // make it black
        view.backgroundColor = UIColor.whiteColor()
        
        /**
        * Intro
        */
        if(roomModel?.mercury_room_type == "intro"){
            // create cover background
            overlay = UIImageView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height));
            overlay!.backgroundColor = UIColor.blackColor()
            overlay!.alpha = 0.3;
            
            
            // add cover image
            coverImage = UIImage(named:"cover")
            coverImageView =  UIImageView(frame: view.bounds)
            coverImageView!.image = coverImage
            coverImageView!.center = view.center

            
            // logo label
            museumLabel = UILabel(frame: CGRect(x: 20, y: 60, width: screenSize.width - 40, height: 60))
            museumLabel!.text = exhibitModel?.exhibit_title
            museumLabel!.font = UIFont.boldSystemFontOfSize(44)
            museumLabel!.textColor = UIColor.whiteColor()
            
            // subtitle
            exhibitionTitleLabel = UILabel(frame: CGRect(x: 20, y: 80, width: screenSize.width - 40, height: 100))
            exhibitionTitleLabel!.numberOfLines = 3
            exhibitionTitleLabel!.lineBreakMode = .ByWordWrapping
            exhibitionTitleLabel!.text = exhibitModel?.exhibit_subtitle
            exhibitionTitleLabel!.font =  UIFont (name: "HelveticaNeue-Light", size: 23)
            exhibitionTitleLabel!.textColor = UIColor.whiteColor()
            
            // description
            descriptionLabel = UILabel(frame: CGRect(x: 20, y: 240, width: screenSize.width - 40, height: screenSize.height - 200))
            descriptionLabel!.numberOfLines = 8
            descriptionLabel!.lineBreakMode = .ByWordWrapping
            descriptionLabel!.text = exhibitModel?.exhibit_description
            descriptionLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
            descriptionLabel!.textColor = UIColor.whiteColor()
            
            // ipad layout update
            if(deviceFunctionService.deviceType == "ipad"){
                descriptionLabel?.frame = CGRect(x: 20, y: 80, width: screenSize.width-200, height: 400)
            }
            
            // add images
            view.addSubview(coverImageView!)
            view.addSubview(overlay!)
            view.addSubview(museumLabel!)
            view.addSubview(exhibitionTitleLabel!)
            view.addSubview(descriptionLabel!)
            
            
            /**
            * Social media content
            */
            if(exhibitModel?.exhibit_twitter_enabled == "1"){
                
                // Twitter button
                twitterButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
                twitterButton!.setTitle("Twitter", forState: UIControlState.Normal)
                twitterButton!.frame = CGRectMake(20, screenSize.height - 70, 100, 30)
                twitterButton!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                twitterButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                twitterButton?.backgroundColor = UIColor.blueColor()
                
                view.addSubview(twitterButton!)
            }
            
            
            if(exhibitModel?.exhibit_facebook_enabled == "1"){
                facebookButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
                facebookButton!.setTitle("Facebook", forState: UIControlState.Normal)
                
                if(exhibitModel?.exhibit_twitter_enabled == "1"){
                    facebookButton!.frame = CGRectMake(140, screenSize.height - 70, 100, 30)
                }else{
                    twitterButton!.frame = CGRectMake(20, screenSize.height - 70, 100, 30)
                }
                facebookButton!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                facebookButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                facebookButton?.backgroundColor = UIColor.blueColor()
                
                view.addSubview(facebookButton!)
            }
            
            
        }else if(roomModel?.mercury_room_type == "room"){
            // description
            roomTitle = UILabel(frame: CGRect(x: 0, y: 80, width: screenSize.width, height: 100))
            roomTitle!.numberOfLines = 1
            roomTitle!.lineBreakMode = .ByWordWrapping
            roomTitle!.text = roomModel?.mercury_room_title
            roomTitle!.font =  UIFont (name: "HelveticaNeue-Light", size: 23)
            roomTitle!.textColor = UIColor.blackColor()
            roomTitle?.textAlignment = NSTextAlignment.Center
            
            // description
            descriptionLabel = UILabel(frame: CGRect(x: 0, y: 160, width: screenSize.width, height: 100))
            descriptionLabel!.numberOfLines = 8
            descriptionLabel!.lineBreakMode = .ByWordWrapping
            descriptionLabel!.text = roomModel?.mercury_room_description
            descriptionLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
            descriptionLabel!.textColor = UIColor.blackColor()
            descriptionLabel!.textAlignment = NSTextAlignment.Center
            
            // commentbutton
            commentButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
            commentButton!.setTitle("Comment", forState: UIControlState.Normal)
            commentButton!.frame = CGRectMake(20, screenSize.height - 70, 100, 30)
            commentButton!.addTarget(self, action: "showCommentPanel:", forControlEvents: UIControlEvents.TouchUpInside)
            commentButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            commentButton?.backgroundColor = UIColor.blueColor()
        
            // views
            view.addSubview(roomTitle!)
            view.addSubview(descriptionLabel!)
            view.addSubview(commentButton!)
        }
    }
    
    func showCommentPanel(sender:UIButton!){
     
        //println(sender.valueForKey("roomId"))
        println(sender.tag)
        
        // alternative layout for ipad
        if(deviceFunctionService.deviceType == "ipad"){
            
            var xPos:CGFloat = (screenSize.width/2)
            var yPos:CGFloat = (screenSize.height/2)
            
            
            feedbackViewController?.view.frame = CGRect(x:(xPos/2), y: (yPos/2), width: xPos, height: yPos)
            feedbackViewController?.view.backgroundColor = UIColor.whiteColor()
            feedbackViewController?.exhibitModel = exhibitModel
            feedbackViewController?.roomModel = roomModel
        
            
            overlay = UIImageView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height));
            overlay!.backgroundColor = UIColor.blackColor()
            overlay!.alpha = 0;
            

            // Add Sub views
            self.addChildViewController(feedbackViewController!)
            view.addSubview(overlay!)
            view.addSubview(feedbackViewController!.view)
            
            // show the overlay
            UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: {
                // Place the UIViews we want to animate here (use x, y, width, height, alpha)
                self.overlay?.alpha = 0.8
                
                return
                }, completion: { finished in
                    // the animation is complete
            })
            
        }else{
            
        }
        NSNotificationCenter.defaultCenter().postNotificationName("ShowFeedbackPanel", object: nil, userInfo:  nil)
    }
    
    func closeFeedbackPanel(notification: NSNotification){
        overlay?.removeFromSuperview()
    }
    
    
    /**
    * Hide status bar
    */
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

