//
//  ExhibitHolderViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 5/12/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class ExhibitHolderViewController: UIViewController, UIScrollViewDelegate {

    var exhibitScrollView:UIScrollView?
    let applicationModel = ApplicationData.sharedModel()
    var eventData = Dictionary<String, String>()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var rooms:[ExhibitStageViewController] = []
    var feedbackScreenSlot:ExhibitFeedbackScreenViewController?
    var socialModel:RoomSocialModel?

    // Singleton Models
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()
    var exhibitListViewController:ExhibitListViewController?

    var socialMenubar:SocialToolbarViewController?
    var roomsBox = []

    var pageIndex : Int = 0
    var titleText : String = ""
    var socialBar:Bool = false
    var imageFile : String = ""
    
    var museumInfoPanel:UIView?
    var panelView:UIScrollView?
    var panelAdded:Bool = false
    
    var gridAdded:Bool = false
    var roomButtons:[UIButton] = []
    var exhibitListScroll:UIScrollView?
    
    var shareViewController:ShareViewController?

    var shareType:String?
    var titelLabel:UILabel?
    var inputText:UITextView?
    var submitButton:UIButton?

    let dataServices = DataManager.dataManager()
    
    var overlay:UIView?
    var exitTitleLabel:UILabel!
    var submitBtn:UIButton?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createExhibition()
        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showFeedbackPanel:", name:"ShowFeedbackPanel", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeFeedbackPanel:", name:"CloseFeedbackPanel", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "beaconChangedHandler:", name:"BeaconsChanged", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "scrollToRoomhandler:", name:"ScrollToRoom", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "scrollDownHandler:", name:"ScrollExhibitDown", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "readMoreHandler:", name:"ReadMore", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gridToggle:", name:"GridToggle", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sharePanel:", name:"SharePanelToggle", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "socialAdded:", name:"SocialAdded", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeExhibitHandler:", name:"CloseExhibit", object: nil)


        
        // exhibit list view controller
        exhibitListViewController = ExhibitListViewController(nibName: nil, bundle: nil)
        exhibitListViewController!.view.frame = CGRect(x: 0, y: 60, width: screenSize.width, height: 150)
        exhibitListViewController!.view.backgroundColor = UIColor.blackColor()
        exhibitListViewController!.view.hidden = true
        
        exhibitListScroll = UIScrollView()
        exhibitListScroll!.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 150)
        
        exhibitListScroll!.contentSize = CGSize(width: screenSize.width, height: 150)
        exhibitListScroll!.backgroundColor = UIColor.whiteColor()
        exhibitListViewController!.view.addSubview(exhibitListScroll!)
        
        
        shareViewController = ShareViewController()
        if(deviceFunctionService.deviceType != "ipad"){
            shareViewController!.view.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 400)
        }
        
        view.addSubview(shareViewController!.view)
        self.addChildViewController(shareViewController!);

    }
    
    
    func closeExhibitHandler(ns:NSNotification){
        
        
        
        
        overlay = UIView();
        overlay?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.9)
        overlay?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        overlay?.alpha = 0;
        view.addSubview(overlay!)
        
        exitTitleLabel = UILabel(frame: CGRect(x: 20, y: 150, width: screenSize.width - 40, height: 120))
        exitTitleLabel.font = UIFont (name: "Avenir-Book", size: 35)
        exitTitleLabel.text = "Bedankt voor de feedback!"
        exitTitleLabel.textColor = UIColor.whiteColor()
        exitTitleLabel.textAlignment = NSTextAlignment.Center
        exitTitleLabel.numberOfLines = 6;
        
        
        submitBtn = UIButton()
        submitBtn!.frame = CGRect(x: 30, y: screenSize.height - 140, width: screenSize.width - 60, height: 60)
        submitBtn?.backgroundColor = UIColor.clearColor();
        submitBtn?.layer.borderWidth = 2;
        submitBtn?.layer.borderColor = UIColor.whiteColor().CGColor
        submitBtn!.addTarget(self, action: "closePanel:", forControlEvents: .TouchUpInside)
        submitBtn!.setTitle("Overzicht", forState: UIControlState.Normal)
        submitBtn!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        submitBtn!.titleLabel?.textAlignment = NSTextAlignment.Center

        
        
        overlay!.addSubview(self.exitTitleLabel)
        overlay!.addSubview(self.submitBtn!);
        
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: {

            self.overlay!.alpha = 1
            
     
            
            return
            }, completion: { finished in
        })
        
    }
    
    
    func closePanel(sender:UIButton){

        eventData["menu"] = "overview"
        NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
        

        
        
    }
    
    
    
    /**
    * Grid Toggle
    */
    func gridToggle(ns:NSNotification){
        
        
        
        if(!gridAdded){
            
            
            // remove rooms
            for room in roomButtons{
                room.removeFromSuperview()
            }
            
            
            gridAdded = false
            view.addSubview(exhibitListViewController!.view)
            
            var xPos:CGFloat = 20
            var counter:Int = 0
            var roomWidth:CGFloat = 0
            
            
            // now create the thumbs
            for room in self.applicationModel.selectedMuseum!.exhibitData[pageIndex].roomData{
                
                if(room.mercury_room_type == "room"){
                    
                    let roomButton = UIButton()
                    roomButton.setTitle(room.mercury_room_title + " " + String(counter), forState: .Normal)
                    roomButton.setTitleColor(applicationModel.UIColorFromRGB(0x222325), forState: .Normal)
                    roomButton.frame = CGRect(x: xPos, y: 12, width: 200, height: 130)
                    roomButton.addTarget(self, action: "selectRoom:", forControlEvents: .TouchUpInside)
                    roomButton.tag = counter
                    roomButton.backgroundColor = UIColor.whiteColor()
                    roomButton.layer.borderWidth = 1
                    roomButton.layer.borderColor = UIColor.grayColor().CGColor
                    self.view.addSubview(roomButton)
                    
                    xPos = xPos + roomButton.frame.width + CGFloat(10)
                    exhibitListScroll!.addSubview(roomButton)
                    
                    roomButtons.append(roomButton);
                    
                }
                
                counter++
            }
            
            exhibitListScroll!.contentSize = CGSize(width: xPos, height: 150)
        }
        
        if(exhibitListViewController!.view.hidden){
            exhibitListViewController!.view.hidden = false
            
            exhibitListViewController!.view.frame.origin.y = -exhibitListViewController!.view.frame.height
            UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: {
                // Place the UIViews we want to animate here (use x, y, width, height, alpha)
                self.exhibitListViewController!.view.frame.origin.y = 60
                
                return
                }, completion: { finished in
                    // the animation is complete
            })
            
        }else{
            UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: {
                // Place the UIViews we want to animate here (use x, y, width, height, alpha)
                self.exhibitListViewController!.view.frame.origin.y = -60
                
                return
                }, completion: { finished in
                    // the animation is complete
                    self.exhibitListViewController!.view.hidden = true
            })
        }
    }
    

    
    func scrollDownHandler(ns:NSNotification){
        
        if(exhibitScrollView!.contentOffset.y > 0){
            // scroll to point
            exhibitScrollView!.setContentOffset(CGPointMake(0, 0), animated: true)
        }else{
            // scroll to point
            exhibitScrollView!.setContentOffset(CGPointMake(0, screenSize.height - 64), animated: true)
        }
    }
    
    
    func beaconChangedHandler(ns:NSNotification){
        if(applicationModel.developer){
            // show beacon info
            // betaText?.text = "room ID " + applicationModel.nearestBeacon!.mercury_room_id + " " applicationModel.nearestBeacon!.mercury_beacon_device_id
        }
        
        // go to the right room
        scrollToRoom(applicationModel.nearestRoom!.mercury_room_order.toInt()!)
    }
    
    
    func scrollToRoom(tag:Int){
        
        if(feedbackScreenSlot?.view.tag == tag){
            
            exhibitScrollView!.setContentOffset(CGPointMake(0, feedbackScreenSlot!.view!.frame.origin.y), animated: true)

        }else{
            
            for roomPos in applicationModel.roomPosition{
                if(roomPos.mercury_room_id == applicationModel.nearestRoom?.mercury_room_id){
                    
                    var scrollPos = Int(roomPos.mercury_room_start - 60)
                    var wageConversionFloat = CGFloat(scrollPos)
                    
                    exhibitScrollView!.setContentOffset(CGPointMake(0, wageConversionFloat), animated: true)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showFeedbackPanel(notification: NSNotification){
     
        exhibitScrollView?.scrollEnabled = false
        
    }
    
    func closeFeedbackPanel(notification: NSNotification){
        
        exhibitScrollView?.scrollEnabled = true
        
    }
    
    func createExhibition(){
        
        applicationModel.roomPosition = [];
        
        // current exhibi (this should be handled by the beacons)
        var myExhibit = applicationModel.selectedMuseum!.exhibitData[pageIndex];
        applicationModel.selectedExhibit = applicationModel.selectedMuseum!.exhibitData[pageIndex];
        var scrollHeight = CGFloat((myExhibit.roomData.count)+1)

        // create the scrollview
        exhibitScrollView = UIScrollView()
        exhibitScrollView?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        exhibitScrollView?.bounces = true
        exhibitScrollView?.pagingEnabled = false
        exhibitScrollView?.delegate = self
        view.addSubview(exhibitScrollView!)
        
        panelView = UIScrollView()
        panelView!.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 340)
        panelView!.contentSize = CGSize(width: screenSize.width, height: 340)
        panelView!.backgroundColor = UIColor(white: 1, alpha: 0.8)
        view.addSubview(panelView!)
        
        var panelLine:UIView = UIView(frame:CGRect(x: 0, y: 0, width: screenSize.width, height: 3))
        panelLine.backgroundColor = applicationModel.UIColorFromRGB(0x653dc9)
        panelView!.addSubview(panelLine)
        
        var panelTitle:UILabel = UILabel(frame: CGRect(x: 40, y: 20, width: 300, height: 60))
        panelTitle.text = "OVER DEZE EXHBITIE"
        panelTitle.font = UIFont.boldSystemFontOfSize(33)
        panelTitle.textColor = applicationModel.UIColorFromRGB(0x242424)
        panelTitle.font =  UIFont (name: "DINAlternate-Bold", size: 18)
        panelView!.addSubview(panelTitle)
        
        var textSplit = applicationModel.selectedMuseum!.exhibitData[pageIndex].exhibit_description;
        
        var textScroll:UIScrollView = UIScrollView()
            textScroll.frame = CGRect(x: 0, y: 60, width: panelView!.frame.width , height: panelView!.frame.height - 100)
            textScroll.contentSize = CGSize(width: panelView!.frame.width, height: 800)
            panelView?.addSubview(textScroll)
        
        var panelTextLeft:UILabel = UILabel(frame: CGRect(x:40, y:70, width: screenSize.width - 200, height: panelView!.frame.height - 60))
            panelTextLeft.text = textSplit
            panelTextLeft.font = UIFont (name: "HelveticaNeue-Light", size: 16)
            panelTextLeft.textColor = UIColor.blackColor()
            panelTextLeft.numberOfLines = 0
            panelTextLeft.preferredMaxLayoutWidth = screenSize.width / 2 - 30
            panelTextLeft.lineBreakMode = NSLineBreakMode.ByWordWrapping
            panelTextLeft.sizeToFit()
            textScroll.addSubview(panelTextLeft)
        
        if(deviceFunctionService.deviceType != "ipad"){
            panelTextLeft.frame = CGRect(x:40, y:0, width: screenSize.width - 80, height: panelView!.frame.height - 60)
        }
        
        var panelTextRight:UILabel = UILabel(frame: CGRect(x:20 + screenSize.width / 2, y:70, width: screenSize.width / 2 - 50, height: panelView!.frame.height - 60))
            panelTextRight.text = ""
            panelTextRight.font = UIFont (name: "HelveticaNeue-Light", size: 16)
            panelTextRight.textColor = UIColor.blackColor()
                panelTextRight.numberOfLines = 0
            panelTextRight.preferredMaxLayoutWidth = screenSize.width / 2 - 30
            panelTextRight.lineBreakMode = NSLineBreakMode.ByWordWrapping
            panelTextRight.sizeToFit()
        
        
        var totalHeight:CGFloat = 0
        var looper:Int = 0;
        
        // Create room views
        var yPos:CGFloat = 0

        for room in myExhibit.roomData  {
            
            var dataViewController = ExhibitStageViewController(nibName: "ExhibitStageViewController", bundle: nil)
                dataViewController.exhibitModel = myExhibit
                dataViewController.roomModel = room
            
            switch(room.mercury_room_type){
                
            case "intro":
                
                
                
                dataViewController.view.frame = CGRect(x: 0, y:yPos, width: screenSize.width, height: screenSize.height)
                dataViewController.view.tag = room.mercury_room_order.toInt()!
                
                
                exhibitScrollView!.addSubview(dataViewController.view)
                self.addChildViewController(dataViewController)
                
                totalHeight = totalHeight + screenSize.height * 2
                yPos = yPos + screenSize.height
                
                
                var roomPosition = RoomPosModel(mercury_room_id: room.mercury_room_id, mercury_room_start: 0, mercury_room_end: screenSize.height);
                applicationModel.roomPosition.append(roomPosition);
                
                
                break;
                
            case "room":


                
                var frameHeight:CGFloat = CGFloat(400) * (CGFloat(room.mediaData.count) / CGFloat(3)) + 300
                var screenHeight = screenSize.height
                
                if(frameHeight < screenSize.height){
                    frameHeight = screenSize.height
                }
                
                
                if(deviceFunctionService.deviceType != "ipad"){
                    
                    // do room height + heading height
                    frameHeight = 440 * CGFloat(room.mediaData.count) + 140
                    if(room.mediaData.count == 1){
                        frameHeight = frameHeight + 30
                    }else if(room.mediaData.count == 0){
                        frameHeight = frameHeight + 0
                    }else if(room.mediaData.count == 4){
                        frameHeight = frameHeight - 20
                    }
                    
                    var socialWidth = Int(screenSize.width) / 2 - 25;
                    var socialHeight = Int(screenSize.width) / 2 - 25;
                    var socialYPos:CGFloat = 0;
                    
                    for var i = 0; i < room.socialData.count; ++i {
                        socialHeight = socialWidth
                        
                        if (i % 2 == 0) {
                            socialYPos = CGFloat(i / 2) * CGFloat(socialHeight + (10) / 2) + 150
                        }else{
                            
                        }
                    }
                
                    
                    // fout zit dus hier
                    if(room.socialData.count > 0){

                        // add socialgrid height (need to calculate this dynamically)
                        frameHeight = frameHeight + socialYPos + 210
                        
                        
                        //  socialYPos = CGFloat(i / 2) * CGFloat(socialHeight + (socialSpacing) / 2) + 150
                        

                        
                        
                       // frameHeight = frameHeight +  (CGFloat(room.socialData.count / 2) * (270 + 40)) + 200
                        
                        // extra
                        
                       // frameHeight = frameHeight + 160 * CGFloat(room.socialData.count) + 140 + 100

                    }
                    
                    
                    
                }else{
                    
                    // content grid
                    frameHeight = ((CGFloat(room.mediaData.count) / 3) * 420) + CGFloat(140) + 40
                    if(room.mediaData.count == 0){
                        frameHeight = 200
                    }
                    
                    if(room.socialData.count > 0){
                    
                        // social media grid
                        frameHeight = frameHeight + ((CGFloat(room.socialData.count) / 3) * 160 + 80) + CGFloat(140)
                    
                    }
                }
                var startPos = yPos;
                dataViewController.view.frame = CGRect(x: 0, y:yPos, width: screenSize.width, height: frameHeight)
                dataViewController.view.backgroundColor = UIColor.whiteColor()
                dataViewController.view.tag = looper
                dataViewController.roomID = looper
                
                exhibitScrollView!.addSubview(dataViewController.view)
                self.addChildViewController(dataViewController)
                
                totalHeight = totalHeight + frameHeight
                yPos = yPos + frameHeight

                
                rooms.append(dataViewController)
                
                
                var roomPosition = RoomPosModel(mercury_room_id: room.mercury_room_id, mercury_room_start: startPos, mercury_room_end: startPos + frameHeight);
                applicationModel.roomPosition.append(roomPosition);


                
                
                break;
                
            case "exit":
                var feedbackScreen = ExhibitFeedbackScreenViewController(nibName: "ExhibitFeedbackScreenViewController", bundle: nil)
                feedbackScreen.exhibitModel = myExhibit
                feedbackScreen.view.frame = CGRect(x: 0, y:yPos, width: screenSize.width, height: screenSize.height)
                feedbackScreen.view.tag = room.mercury_room_order.toInt()!
                
                exhibitScrollView!.addSubview(feedbackScreen.view)
                self.addChildViewController(feedbackScreen)
                
                feedbackScreenSlot = feedbackScreen
                
                totalHeight = totalHeight + screenSize.height
                
                var roomPosition = RoomPosModel(mercury_room_id: room.mercury_room_id, mercury_room_start: yPos, mercury_room_end: yPos + screenSize.height);
                applicationModel.roomPosition.append(roomPosition);
                
                break;
                
            default:
                println("no label found")
            }
            
            	
            looper++

        }
        
        exhibitScrollView?.contentSize = CGSize(width:screenSize.width, height: totalHeight - 680)
        socialMenubar = SocialToolbarViewController(nibName: "SocialToolbarViewController", bundle: nil)
        socialMenubar!.view.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 120)
        
        // if mobile
        if(deviceFunctionService.deviceType != "ipad"){
            socialMenubar!.view.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 40)
        }
        
        socialMenubar!.view.hidden = true
        view.addSubview(socialMenubar!.view)

    }
    
    
    
    
    func selectRoom(sender: UIButton!) {
        
        eventData["roomID"] = String(sender.tag)
        NSNotificationCenter.defaultCenter().postNotificationName("ScrollToRoom", object: nil, userInfo:  eventData)
    }
    
    
    func sharePanel(ns:NSNotification){
        
        if let toggle = ns.userInfo {
            var target:String = (toggle["target"] as! String)
            
            self.shareViewController!.view.frame = CGRect(x: 0, y: 64, width: self.screenSize.width, height: self.screenSize.height - 152)

            shareViewController!.shareType = target;
            shareViewController!.view.alpha = 0;
            
            
            UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
                self.shareViewController?.view.alpha = 1

                return
                }, completion: { finished in
                    
                self.shareViewController!.setShare();
            })

            
            applicationModel.socialPanel = true;
        }
        
    }
    
    
    func socialAdded(ns:NSNotification){
        
        // hide social panel
        applicationModel.socialPanel = false;

    }
    
    
    /**
    * Read More Panel
    */
    func readMoreHandler(ns:NSNotification){
        
        if(!panelAdded){
            
            panelAdded = true
            
            panelView!.frame.origin.y = screenSize.height
            UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: {
                // Place the UIViews we want to animate here (use x, y, width, height, alpha)
                self.panelView!.frame.origin.y = self.screenSize.height - self.panelView!.frame.height
                
                return
                }, completion: { finished in
                    // the animation is complete
            })
            
            
            
        }else{
            panelAdded = false
            
            UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: {
                // Place the UIViews we want to animate here (use x, y, width, height, alpha)
                self.panelView!.frame.origin.y = self.screenSize.height + self.panelView!.frame.height
                
                return
                }, completion: { finished in
                    // the animation is complete
            })
            
        }
        
    }
    
    
    
    func scrollToRoomhandler(ns:NSNotification){
        
        if let roomId = ns.userInfo {

            var evtData:String = (roomId["roomID"] as! String)
            var roomSave:Int = evtData.toInt()!
            
            var selectedRoom = self.view.viewWithTag(roomSave)
            
            for room in rooms{
                if(room.view.tag == roomSave){
                    
                    exhibitScrollView!.setContentOffset(CGPointMake(0, room.view.frame.origin.y - 60), animated: true)
                }
            }
        }
        
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        if(exhibitScrollView!.contentOffset.y >= screenSize.height){
            eventData["showToolBar"] = "true"
            eventData["menuTitle"] = "true"
            eventData["menuTitleString"] = applicationModel.nearestMuseum!.museum_title + ": " + applicationModel.selectedExhibit!.exhibit_title
            
            NSNotificationCenter.defaultCenter().postNotificationName("ToggleMenuBar", object: nil, userInfo:  eventData)
        }else{
            eventData["showToolBar"] = "false"
            eventData["menuTitle"] = "-welfalse"
            eventData["menuTitleString"] = ""            
            NSNotificationCenter.defaultCenter().postNotificationName("ToggleMenuBar", object: nil, userInfo:  eventData)
        }
        
        
        var lastRoomY:CGFloat = 0
        
        // get last room pos
        if(applicationModel.roomPosition.count > 0){
            
            lastRoomY =  applicationModel.roomPosition[applicationModel.roomPosition.count - 1].mercury_room_end
            
        }
        
        if(scrollView.contentOffset.y >= lastRoomY && self.socialBar == true){
            
            UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: {
                self.socialMenubar!.view.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: 120)
                
                return
                }, completion: { finished in
                    self.socialBar = false
            })
        }else if(scrollView.contentOffset.y < screenSize.height){
            
            
 
            

            
    
            
            
            if(socialBar){
                UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: {
                    self.socialMenubar!.view.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: 120)
                    
                    return
                    }, completion: { finished in
                        self.socialBar = false
                })
                
            }
        
        }
        
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView,
        willDecelerate decelerate: Bool){
            
            shareViewController!.currentScrollPos = scrollView.contentOffset.y
            
            // hide infoPanel
            if(scrollView.contentOffset.y > screenSize.height - (screenSize.height / 2)){
                if(panelAdded){
                    
                    UIView.animateWithDuration(0.3, delay: 0, options: nil, animations: {
                        self.panelView!.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: 340)
                        
                        
                        return
                        }, completion: { finished in
                            self.panelAdded = false
                            
                    })
                }
            }
            
            var lastRoomY:CGFloat = 0;
            
            if(applicationModel.roomPosition.count > 0){
                
                lastRoomY =  applicationModel.roomPosition[applicationModel.roomPosition.count - 1].mercury_room_end
                
            }
            
            
            // show social tools
            if(scrollView.contentOffset.y > screenSize.height - 100 && scrollView.contentOffset.y <= lastRoomY - 100){
                
                if(!socialBar){
                
                    
                socialMenubar!.view.hidden = false
                socialMenubar!.view.frame = CGRect(x: 0, y: screenSize.height - 20, width: screenSize.width, height: 120)
                    
                if(deviceFunctionService.deviceType != "ipad"){
                        socialMenubar!.view.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 88)
                    }
                    
                    
                UIView.animateWithDuration(0.3, delay: 0, options: nil, animations: {
                    self.socialMenubar!.view.frame = CGRect(x: 0, y: self.screenSize.height - 120, width: self.screenSize.width, height: 120)
                    self.socialBar = true
                    
                    if(self.deviceFunctionService.deviceType != "ipad"){
                        self.socialMenubar!.view.frame = CGRect(x: 0, y: self.screenSize.height - 88, width: self.screenSize.width, height: 88)
                    }
                    
                    
                    return
                    }, completion: { finished in
                        
                })
                }
                
            }else{
                UIView.animateWithDuration(0.3, delay: 0, options: nil, animations: {
                    self.socialMenubar!.view.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: 120)
                    
                    return
                    }, completion: { finished in
                        self.socialBar = false
                })
            }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        
        
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
