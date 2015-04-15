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

    
    
    var pageIndex : Int = 0
    var titleText : String = ""
    var imageFile : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createExhibition()
        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showFeedbackPanel:", name:"ShowFeedbackPanel", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeFeedbackPanel:", name:"CloseFeedbackPanel", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "beaconChangedHandler:", name:"BeaconsChanged", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "scrollDownHandler:", name:"ScrollExhibitDown", object: nil)

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
//            betaText?.text = "room ID " + applicationModel.nearestBeacon!.mercury_room_id + " " + applicationModel.nearestBeacon!.mercury_beacon_device_id
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
        
        
        var totalHeight:CGFloat = 0
        
        
        // rooms
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
                
                looper++
                
                break;
                
            case "room":
                var frameHeight:CGFloat = CGFloat(400) * (CGFloat(room.mediaData.count) / CGFloat(3)) + 300
            
                var screenHeight = screenSize.height
                if(frameHeight < screenSize.height){
                    frameHeight = screenSize.height
                }
                
                
                if(deviceFunctionService.deviceType != "ipad"){
                    
                    
                    // do room height + heading height
                    frameHeight = 460 * CGFloat(room.mediaData.count) + 140
                    
                    // add socialgrid height (need to calculate this dynamically)
                    frameHeight = frameHeight + screenSize.height
                }
                
   
                println("items")
                println(room.mediaData.count)

                println("frameheight")
                println(frameHeight)
                
                
                dataViewController.view.frame = CGRect(x: 0, y:yPos, width: screenSize.width, height: frameHeight)
            
                dataViewController.view.backgroundColor = UIColor.whiteColor()
                
                
                exhibitScrollView!.addSubview(dataViewController.view)
                self.addChildViewController(dataViewController)
                
                totalHeight = totalHeight + frameHeight
                yPos = yPos + frameHeight

                
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
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView,
        willDecelerate decelerate: Bool){
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
