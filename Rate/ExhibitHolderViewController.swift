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
    
    // Singleton Models
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()

    var socialMenubar:SocialToolbarViewController?
    var roomsBox = []

    var pageIndex : Int = 0
    var titleText : String = ""
    var socialBar:Bool = false
    var imageFile : String = ""
    
    var museumInfoPanel:UIView?
    var panelView:UIScrollView?
    var panelAdded:Bool = false

    
    
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
        ///scrollToRoom(applicationModel.nearestRoom!.mercury_room_order.toInt()!)
    }
    
    
    func scrollToRoom(tag:Int){
        
        if(feedbackScreenSlot?.view.tag == tag){
            
            exhibitScrollView!.setContentOffset(CGPointMake(0, feedbackScreenSlot!.view!.frame.origin.y), animated: true)

        }else{

            for room in applicationModel.selectedExhibit!.roomData{
                if(room.mercury_room_order.toInt() == tag){
                    var scrollPos = (Int(screenSize.height) * tag)
                    var wageConversionFloat = CGFloat(scrollPos)
                    
                    if(room.mercury_room_type == "intro"){
                        exhibitScrollView!.setContentOffset(CGPointMake(0, 0), animated: true)

                    }else{
                        exhibitScrollView!.setContentOffset(CGPointMake(0, wageConversionFloat), animated: true)
                    }
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
        
        // current exhibi (this should be handled by the beacons)
        var myExhibit = applicationModel.selectedExhibit
        var scrollHeight = CGFloat((myExhibit!.roomData.count)+1)
        
        
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
        
        var textSplit = applicationModel.selectedExhibit?.exhibit_description
        
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

        for room in myExhibit!.roomData  {
            
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
                    
                    // add socialgrid height (need to calculate this dynamically)
                    frameHeight = frameHeight + 3000
                    
                }else{
                    
                    println((CGFloat(room.mediaData.count) / 3))
                    
                    
                    // content grid
                    frameHeight = ((CGFloat(room.mediaData.count) / 3) * 420) + CGFloat(140) + 40
                    // social media grid
                    frameHeight = frameHeight + 1220
                    
                }
                
   
                
                dataViewController.view.frame = CGRect(x: 0, y:yPos, width: screenSize.width, height: frameHeight)
                dataViewController.view.backgroundColor = UIColor.whiteColor()
                dataViewController.view.tag = looper
                dataViewController.roomID = looper
                
                println("looper")
                println(looper)
                
                exhibitScrollView!.addSubview(dataViewController.view)
                self.addChildViewController(dataViewController)
                
                totalHeight = totalHeight + frameHeight
                yPos = yPos + frameHeight

                
                rooms.append(dataViewController)
                

                break;
                
            case "exit":
                var feedbackScreen = ExhibitFeedbackScreenViewController(nibName: "ExhibitFeedbackScreenViewController", bundle: nil)
                feedbackScreen.exhibitModel = myExhibit
                feedbackScreen.view.frame = CGRect(x: 0, y:yPos, width: screenSize.width, height: screenSize.height)
                feedbackScreen.view.backgroundColor = UIColor.yellowColor()
                feedbackScreen.view.tag = room.mercury_room_order.toInt()!
                
                exhibitScrollView!.addSubview(feedbackScreen.view)
                self.addChildViewController(feedbackScreen)
                
                feedbackScreenSlot = feedbackScreen
                
                totalHeight = totalHeight + screenSize.height
                
                break;
                
            default:
                println("no label found")
            }
            
            	
            looper++

        }
        

        exhibitScrollView?.contentSize = CGSize(width:screenSize.width, height: totalHeight)
        
        socialMenubar = SocialToolbarViewController(nibName: "SocialToolbarViewController", bundle: nil)
        socialMenubar!.view.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 120)
        socialMenubar!.view.hidden = true
        view.addSubview(socialMenubar!.view)

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
            
            
            
            
            // scrollTo
            //

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
        
        
        // hide social bar
        if(scrollView.contentOffset.y < screenSize.height){
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
            
            // hide infoPanel
            if(scrollView.contentOffset.y > screenSize.height - (screenSize.height / 2)){
                if(panelAdded){
                    
                    println("hiding panel")
                    
                    UIView.animateWithDuration(0.3, delay: 0, options: nil, animations: {
                        self.panelView!.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: 340)
                        return
                        }, completion: { finished in
                            self.panelAdded = false
                            
                            
                    })
                }
            }
            
            // show social tools
            if(scrollView.contentOffset.y > screenSize.height - 100){
                
                if(!socialBar){
                
                    
                socialMenubar!.view.hidden = false
                socialMenubar!.view.frame = CGRect(x: 0, y: screenSize.height - 20, width: screenSize.width, height: 120)
                UIView.animateWithDuration(0.3, delay: 0, options: nil, animations: {
                    self.socialMenubar!.view.frame = CGRect(x: 0, y: self.screenSize.height - 120, width: self.screenSize.width, height: 120)
                    self.socialBar = true
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
                
            // hide social tools
                
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
