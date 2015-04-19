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
    let applicationModel = ApplicationData.sharedModel()
    
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
    var coverPaddingView:UIView?
    var scrollDown:UIView?
    var scrollDownButton:UIButton?
    var logoLabel:UILabel?
    
    // buttons
    var twitterButton:UIButton?
    var facebookButton:UIButton?
    var closeButton:UIButton?
    var readButton:UIButton?
    
    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var lastYpos:CGFloat = 0
    var roomID:Int = 0
    
    
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
            
            let url = NSURL(string: ( exhibitModel!.exhibit_cover_image))
            if((url) != nil && url != ""){
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                coverImageView?.image = UIImage(data: data!)
                coverImageView?.contentMode = .ScaleAspectFit
                coverImageView?.frame = view.bounds
                coverImageView?.center = view.center
                coverImageView?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
                coverImageView?.contentMode = UIViewContentMode.ScaleAspectFill
            }
            
            coverPaddingView = UIView(frame: CGRect(x: 0, y: 40, width: screenSize.width, height: screenSize.height-80))
            
            
            logoLabel = UILabel()
            logoLabel!.frame = CGRect(x: 20, y: 150, width: 70, height: 60)
            logoLabel!.text = "EXHIBITIE"
            logoLabel!.font = UIFont.boldSystemFontOfSize(33)
            logoLabel!.textColor = applicationModel.UIColorFromRGB(0x242424)
            logoLabel!.font =  UIFont (name: "DINAlternate-Bold", size: 18)
            logoLabel!.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
            logoLabel!.sizeToFit()
            logoLabel!.textAlignment = NSTextAlignment.Center
            
            
            // logo label
            museumLabel = UILabel()
            museumLabel!.frame = CGRect(x: (screenSize.width/2) - 300, y: 230, width: 600, height: CGFloat.max)
            museumLabel!.text = exhibitModel?.exhibit_title
            museumLabel!.textColor = UIColor.whiteColor()
            museumLabel!.numberOfLines = 0
            museumLabel!.textColor = UIColor.whiteColor()
            museumLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
            museumLabel!.sizeToFit()
            
            
            
            // subtitle
            exhibitionTitleLabel = UILabel(frame: CGRect(x: 0, y: museumLabel!.frame.height + museumLabel!.frame.origin.y, width: coverPaddingView!.frame.width, height: 100))
            exhibitionTitleLabel!.numberOfLines = 0
            exhibitionTitleLabel!.lineBreakMode = .ByWordWrapping
            exhibitionTitleLabel!.text = exhibitModel?.exhibit_subtitle
            exhibitionTitleLabel!.font =  UIFont (name: "HelveticaNeue-Light", size: 23)
            exhibitionTitleLabel!.textColor = UIColor.whiteColor()
            exhibitionTitleLabel!.sizeToFit()
            
            
            // description
            descriptionLabel = UILabel(frame: CGRect(x: 0, y: exhibitionTitleLabel!.frame.height + exhibitionTitleLabel!.frame.origin.y, width: coverPaddingView!.frame.width, height: CGFloat.max))
            descriptionLabel!.numberOfLines = 0
            descriptionLabel!.lineBreakMode = .ByWordWrapping
            descriptionLabel!.text = exhibitModel?.exhibit_description
            descriptionLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
            descriptionLabel!.textColor = UIColor.whiteColor()
            descriptionLabel!.sizeToFit()
            descriptionLabel!.hidden = true
            
            
            readButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
            readButton!.titleLabel?.font =  UIFont(name: "Futura-Medium", size: 20)
            readButton!.setTitle("Meer informatie", forState: UIControlState.Normal)
            readButton!.addTarget(self, action: "readMore:", forControlEvents: UIControlEvents.TouchUpInside)
            readButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            readButton!.backgroundColor = UIColor.whiteColor()
            readButton!.frame = CGRectMake(30, screenSize.height - 140, 190, 70)
            readButton!.layer.borderColor = UIColor.whiteColor().CGColor
            readButton!.layer.borderWidth = 3
            readButton!.backgroundColor = UIColor.clearColor()
            
            
            let scrollImage = UIImage(named: "scroll-down-button") as UIImage?
            scrollDownButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
            scrollDownButton!.titleLabel?.font =  UIFont(name: "Futura-Medium", size: 30)
            scrollDownButton!.setTitle("", forState: UIControlState.Normal)
            scrollDownButton!.addTarget(self, action: "scrollDown:", forControlEvents: UIControlEvents.TouchUpInside)
            scrollDownButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            scrollDownButton!.backgroundColor = UIColor.whiteColor()
            scrollDownButton!.frame = CGRectMake((screenSize.width/2)-(30/2), screenSize.height - 45, 30, 30)
            scrollDownButton!.backgroundColor = UIColor.clearColor()
            scrollDownButton!.setImage(scrollImage, forState: .Normal)
            
            
            
            // Debug data
            scrollDown = UIView()
            scrollDown!.backgroundColor = UIColor.whiteColor()
            scrollDown!.frame = CGRect(x: 0, y: screenSize.height - 60, width: screenSize.width, height: 60)
            
            
            
            // ipad layout update
            if(deviceFunctionService.deviceType == "ipad"){
                
                // exhibit blue background
                logoLabel!.frame = CGRect(x: 80, y: 130, width: 120, height: 30)
                
                // museum title
                museumLabel!.font =  UIFont(name: "Futura-Medium", size: 44)
                museumLabel!.frame = CGRect(x: 80, y: 134, width: screenSize.width - 160, height: screenSize.height)
                museumLabel?.sizeToFit()
                
                // what is this?
                exhibitionTitleLabel!.frame = CGRect(x: 80, y: museumLabel!.frame.origin.y + museumLabel!.frame.height + 10, width: coverPaddingView!.frame.width - 60, height: 100)
                exhibitionTitleLabel?.sizeToFit()
                
                
                readButton!.frame = CGRectMake(80, exhibitionTitleLabel!.frame.origin.y + exhibitionTitleLabel!.frame.height + 20, 180, 60)
                
            }else{
                
                // exhibit blue background
                logoLabel!.frame = CGRect(x: 30, y: 130, width: 120, height: 30)
                museumLabel!.font =  UIFont(name: "Futura-Medium", size: 30)
                
                
                // museum title
                museumLabel!.frame = CGRect(x: 30, y: 134, width: screenSize.width - 60, height: screenSize.height)
                museumLabel?.sizeToFit()
                
                
                // what is this?
                exhibitionTitleLabel!.frame = CGRect(x: 30, y: museumLabel!.frame.origin.y + museumLabel!.frame.height + 10, width: coverPaddingView!.frame.width - 60, height: 100)
                exhibitionTitleLabel?.sizeToFit()
                
                // description (just hide it)
                descriptionLabel!.frame = CGRect(x: 0, y: exhibitionTitleLabel!.frame.height + exhibitionTitleLabel!.frame.origin.y, width: coverPaddingView!.frame.width, height: CGFloat.max)
                descriptionLabel!.sizeToFit()
                
                
                readButton!.frame = CGRectMake(30, exhibitionTitleLabel!.frame.origin.y + exhibitionTitleLabel!.frame.height + 20, 180, 60)
                
            }
            
            
            
            
            // add images
            view.addSubview(coverImageView!)
            view.addSubview(overlay!)
            
            view.addSubview(coverPaddingView!)
            coverPaddingView!.addSubview(museumLabel!)
            coverPaddingView!.addSubview(exhibitionTitleLabel!)
            coverPaddingView!.addSubview(descriptionLabel!)
            coverPaddingView!.addSubview(readButton!)
            view.addSubview(scrollDown!)
            view.addSubview(scrollDownButton!)
            view.addSubview(logoLabel!)
            
            
            // Twitter button
            if(exhibitModel?.exhibit_twitter_enabled == "1"){
                
                let twitterImage = UIImage(named:"twitter-share-icon") as UIImage?
                twitterButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
                twitterButton!.setTitle("", forState: UIControlState.Normal)
                twitterButton!.frame = CGRectMake(screenSize.width - 100, screenSize.height - 140, 40, 40)
                
                if(deviceFunctionService.deviceType == "iphone"){
                    twitterButton!.frame = CGRectMake(screenSize.width - 70, screenSize.height - 140, 40, 40)
                }
                
                twitterButton!.addTarget(self, action: "shareTwitter:", forControlEvents: UIControlEvents.TouchUpInside)
                twitterButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                twitterButton?.backgroundColor = UIColor.clearColor()
                twitterButton!.setImage(twitterImage, forState: .Normal)
                
                view.addSubview(twitterButton!)
            }
            
            let facebookImage = UIImage(named:"facebook-share-icon") as UIImage?
            
            facebookButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
            facebookButton!.setTitle("Facebook", forState: UIControlState.Normal)
            
            if(exhibitModel?.exhibit_twitter_enabled == "1"){
                facebookButton!.frame = CGRectMake(210, screenSize.height - 70, 100, 30)
            }else{
                twitterButton!.frame = CGRectMake(70, screenSize.height - 70, 100, 30)
            }
            facebookButton!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            facebookButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            facebookButton?.backgroundColor = UIColor.blueColor()
            
            //view.addSubview(facebookButton!)
            
            
            
            
            /**
            * Social media content
            */
            /*
            if(exhibitModel?.exhibit_twitter_enabled == "1"){
            
            // Twitter button
            twitterButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
            twitterButton!.setTitle("Twitter", forState: UIControlState.Normal)
            twitterButton!.frame = CGRectMake(70, screenSize.height - 70, 100, 30)
            twitterButton!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            twitterButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            twitterButton?.backgroundColor = UIColor.blueColor()
            
            view.addSubview(twitterButton!)
            }
            
            
            if(exhibitModel?.exhibit_facebook_enabled == "1"){
            facebookButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
            facebookButton!.setTitle("Facebook", forState: UIControlState.Normal)
            
            if(exhibitModel?.exhibit_twitter_enabled == "1"){
            facebookButton!.frame = CGRectMake(210, screenSize.height - 70, 100, 30)
            }else{
            twitterButton!.frame = CGRectMake(70, screenSize.height - 70, 100, 30)
            }
            facebookButton!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            facebookButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            facebookButton?.backgroundColor = UIColor.blueColor()
            
            view.addSubview(facebookButton!)
            }
            */
            
            
        }else if(roomModel?.mercury_room_type == "room"){
            
            // create content grid (different grids for different amounts of content)
            drawContentGrid()
        }
    }
    
    func shareTwitter(sender:UIButton){
        
    }
    
    func drawContentGrid(){
        println("draw content grid")
    
        var items:Int = 12
        var gridCols:CGFloat = 1
        
        var gap:CGFloat = 10
        if(deviceFunctionService.deviceType == "ipad"){
            gridCols = 3
        }
        
        var gridItemWidth:CGFloat = ((screenSize.width-80) / gridCols)
        var gridItemHeight:CGFloat = 420
        
        // exhibit
        var spacing:Int = 20
        var mediaCount = roomModel?.mediaData.count
        var numberOfRows:Int = mediaCount!
        var counter = 0
        
        // creating grid frame
        var gridFrame:UIView = UIView()
        var gridFrameHeight = screenSize.height
        
        var marginTop = 0

        var gridFrameHeading:UIView = UIView()
        gridFrameHeading.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 140)
        gridFrameHeading.backgroundColor = applicationModel.UIColorFromRGB(0xe9eae2)
        gridFrame.addSubview(gridFrameHeading)
        
        
        
        if(deviceFunctionService.deviceType != "ipad"){
            gridFrameHeight = (CGFloat(gridItemHeight) + (CGFloat(spacing) * 2) + gridFrameHeading.frame.height) * CGFloat(exhibitModel!.roomData.count)
        }else{
         
            gridFrameHeight = CGFloat(gridFrameHeading.frame.height) + ((CGFloat(mediaCount!) / 3) * gridItemHeight) + 60
        }
        
        gridFrame.frame = CGRect(x: 0, y: lastYpos, width: screenSize.width, height: gridFrameHeight)
        gridFrame.backgroundColor = applicationModel.UIColorFromRGB(0xddded6)
        view.addSubview(gridFrame)
        
        var socialMediaFrame:UIView = UIView()
        socialMediaFrame.frame = CGRect(x: 0, y: lastYpos + gridFrameHeight, width: screenSize.width, height: 1000)
        socialMediaFrame.backgroundColor = applicationModel.UIColorFromRGB(0xe5e6de)
        view.addSubview(socialMediaFrame)
        
        var infoNumber:UILabel = UILabel(frame: CGRect(x: 80, y: 20, width: 100, height: 100))
        
        var roomString = ""
        if(roomID <= 9){
            roomString = "0" + String(roomID) + "."
        }else{
            roomString = String(roomID) + "."
        }
        infoNumber.text = roomString
        
        
        
        infoNumber.textAlignment = NSTextAlignment.Left
        infoNumber.numberOfLines = 1
        infoNumber.sizeToFit()
        infoNumber.font =  UIFont (name: "AvenirNext-UltraLight", size: 60)
        infoNumber.sizeToFit()
        view.addSubview(infoNumber)
        
        var numberDescription:UILabel = UILabel(frame: CGRect(x: 80, y: infoNumber.frame.origin.y + infoNumber.frame.height - 10, width: 400,  height: 100))
        numberDescription.text = "OVER DEZE RUIMTE"
        numberDescription.textAlignment = NSTextAlignment.Left
        numberDescription.numberOfLines = 0
        numberDescription.sizeToFit()
        numberDescription.font =  UIFont (name: "AvenirNext-Medium", size: 12)
        numberDescription.sizeToFit()
        view.addSubview(numberDescription)
        
        var infoText:UILabel = UILabel()
        infoText.frame = CGRect(x: numberDescription.frame.width + 100, y: 20, width: screenSize.width - numberDescription.frame.width - 70 - 80, height: 100)
        infoText.font =  UIFont (name: "Avenir-Book", size: 16)
        infoText.numberOfLines = 4
        infoText.text = "Thomas Hobbes wos nen Iengelschn filosôof die olgemêen wierd gezien lyk êen van de groundleggers van de moderne polletieke filosofie. Zyn bekendste werk es zyn in 1651 uutgekommn boek Leviathan"
        view.addSubview(infoText)
        
        
        
        
        // description
        descriptionLabel = UILabel(frame: CGRect(x: 0, y: 160, width: screenSize.width, height: 100))
        descriptionLabel!.numberOfLines = 8
        descriptionLabel!.lineBreakMode = .ByWordWrapping
        descriptionLabel!.text = roomModel?.mercury_room_description
        descriptionLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
        descriptionLabel!.textColor = UIColor.blackColor()
        descriptionLabel!.textAlignment = NSTextAlignment.Center
        descriptionLabel!.hidden = true
        
        // commentbutton
        /*
        commentButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        commentButton!.setTitle("Comment", forState: UIControlState.Normal)
        commentButton!.frame = CGRectMake(20, screenSize.height - 70, 100, 30)
        commentButton!.addTarget(self, action: "showCommentPanel:", forControlEvents: UIControlEvents.TouchUpInside)
        commentButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        commentButton?.backgroundColor = UIColor.blueColor()
        */
        // views
        gridFrame.addSubview(descriptionLabel!)
        //gridFrame.addSubview(commentButton!)
        
        var gridCollection = Array<MediaTileViewController>()
        var mediaIterate = Array<MediaTileViewController>()
        
        
        for var i = 0; i < numberOfRows; ++i {
            
            for var j = 0; j<Int(gridCols); j++ {
                if(counter < mediaCount){
                    
                    // Do we need one or two grid cells :)?
                    
                    // create the right celltype
                    var t:MediaTileViewController = MediaTileViewController()
                    
                    var tView:Int = 0
                    
                    
                    var wider:Bool = false
                    
                    if(deviceFunctionService.deviceType != "ipad"){
                        gridItemWidth = screenSize.width - 50
                    }
                    
                    
                    if(roomModel!.mediaData[counter].mercury_room_media_type == "editiorial" && deviceFunctionService.deviceType == "ipad"){
                        
                        t.viewWidth = Int(gridItemWidth) * 2 + spacing
                        
                        wider = true
                        
                    }else{
                        t.viewWidth = Int(gridItemWidth)
                    }
                    t.viewHeight = Int(gridItemHeight - 20)
                    t.mediaModel = roomModel!.mediaData[counter]
                    
                    if(wider){
                        
                        // devidable by three?
                        if ((counter+1) % 3 == 0 && roomModel!.mediaData[counter].mercury_room_media_type == "editiorial" && deviceFunctionService.deviceType == "ipad"){
                            
                            // now we have to swap the elements
                            mediaIterate.append(gridCollection[counter-1])
                            
                            // now remove the misplaced element
                            gridCollection[counter-1].view.hidden = true
                            gridCollection[counter-1].removeFromParentViewController()
                            
                            // swap the wide container
                            t.view.frame = CGRect(x: (j-1)*(Int(gridItemWidth) + spacing) + 18, y: (i*(Int(gridItemHeight))) + 140 + 40, width: Int(gridItemWidth) * 2, height: Int(gridItemHeight))
                            
                        }else{
                            
                            t.view.frame = CGRect(x: (j-1)*(Int(gridItemWidth) + spacing) + 18, y: (i*(Int(gridItemHeight))) + 140 + 40, width: Int(gridItemWidth) * 2, height: Int(gridItemHeight))
                        }

                        
                    }else{
                        
                        var myHeight = (Int(gridItemHeight) + (spacing * 2) + marginTop)
                        var nPos = myHeight * i
                        
                        t.view.frame = CGRect(x: j*(Int(gridItemWidth) + spacing) + 18, y: (i*(Int(gridItemHeight))) + 140 + 40, width: Int(gridItemWidth), height: Int(gridItemHeight))
                        
  
                        if(deviceFunctionService.deviceType != "ipad"){
                            t.view.frame = CGRect(x: 20, y: 170 + nPos, width: Int(gridItemWidth), height: Int(gridItemHeight))

                        }
                    
                    }
                
                    
                    gridFrame.addSubview(t.view)
                    
                    // add this
                    gridCollection.append(t)
                    
                }
                counter++
            }
            
            
        }
        

        // social media content
        var socialNumber:UILabel = UILabel(frame: CGRect(x: 0, y: 40, width: screenSize.width, height: 50))
        socialNumber.text = roomString
        socialNumber.textAlignment = NSTextAlignment.Center
        socialNumber.numberOfLines = 1
        socialNumber.font =  UIFont (name: "AvenirNext-UltraLight", size: 60)
        socialMediaFrame.addSubview(socialNumber)
        
        
        var socialText:UILabel = UILabel()
        socialText.frame = CGRect(x: 0, y: socialNumber.frame.origin.y + socialNumber.frame.height, width: screenSize.width, height: 40)
        socialText.font =  UIFont (name: "Avenir-Book", size: 20)
        socialText.numberOfLines = 1
        socialText.textAlignment = NSTextAlignment.Center
        socialText.text = "DOOR DE BEZOEKERS"
        socialMediaFrame.addSubview(socialText)
        
        
        
        // socialGrid
        var socialItemsCount:Int = 10
        var socialHeight = 160
        var socialWidth = 160
        var socialSpacing:Int = 20
        var socialYPos = socialText.frame.origin.y + 70
        var socialXPos = 50
        
        for var i = 0; i < numberOfRows; ++i {
            
            var e:SocialGridItemViewController = SocialGridItemViewController()
            e.view.frame = CGRect(x: CGFloat(socialXPos), y: socialYPos, width: 160, height: 160)
            socialMediaFrame.addSubview(e.view)
            
            
            //Mooie tentoonstelling in #netwerk
            
            e.view.layer.transform = CATransform3DConcat(CATransform3DMakeScale(1, 1, 1),  CATransform3DMakeRotation(45 * CGFloat(M_PI/180), 0, 0, 1))
            
            var socialTitle = UILabel()
            socialTitle.frame = CGRect(x: 0, y: 0, width: 160, height: 160)
            socialTitle.text = "Mooie tentoonstelling in Netwerk"
            socialTitle.font = UIFont.boldSystemFontOfSize(33)
            socialTitle.textColor = UIColor.whiteColor()
            socialTitle.font =  UIFont (name: "DINAlternate-Bold", size: 18)
            socialTitle.textAlignment = NSTextAlignment.Center
            socialTitle.numberOfLines = 5
            
            e.view.addSubview(socialTitle)
            socialTitle.layer.transform = CATransform3DConcat(CATransform3DMakeScale(1, 1, 1),  CATransform3DMakeRotation(-45 * CGFloat(M_PI/180), 0, 0, 1))
            
            
            socialXPos = socialXPos + socialWidth + 70

        }
        

    }
    
    
    func readMore(send:UIButton){
        NSNotificationCenter.defaultCenter().postNotificationName("ReadMore", object: nil, userInfo:  nil)
        
    }
    
    func scrollDown(sender:UIButton){
        NSNotificationCenter.defaultCenter().postNotificationName("ScrollExhibitDown", object: nil, userInfo:  nil)
    }
    
    func showCommentPanel(sender:UIButton!){
        
        
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
    
    
    
}

