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

    var pageIndex : Int = 0
    var titleText : String = ""
    var imageFile : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createExhibition()
        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showFeedbackPanel:", name:"ShowFeedbackPanel", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeFeedbackPanel:", name:"CloseFeedbackPanel", object: nil)

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
        var myExhibit = applicationModel.museumData[0].exhibitData[pageIndex]
        var scrollHeight = CGFloat((myExhibit.roomData.count)+2)
        
        
        // create the scrollview
        exhibitScrollView = UIScrollView()
        exhibitScrollView?.contentSize = CGSize(width:screenSize.width, height: screenSize.height*scrollHeight)
        exhibitScrollView?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        exhibitScrollView?.bounces = false
        exhibitScrollView?.pagingEnabled = true
        exhibitScrollView?.delegate = self
        
        view.addSubview(exhibitScrollView!)
        
        // rooms
        var looper:Int = 0;
        
        // Create room views
        for room in myExhibit.roomData  {
            var yPos = screenSize.height*CGFloat(looper)
            if(looper >= 1){
                yPos = screenSize.height*CGFloat(looper+1)
            }
            
            // Create the overview screen
            if(looper == 1){
                
                var overviewViewController = ExhibitOverviewController(nibName: "ExhibitOverviewController", bundle:nil)
                overviewViewController.exhibitModel = myExhibit
                overviewViewController.view.frame = CGRect(x: 0, y:screenSize.height*CGFloat(looper), width: screenSize.width, height: screenSize.height)
                
                exhibitScrollView!.addSubview(overviewViewController.view)
                self.addChildViewController(overviewViewController)
            }
            
            // Create a new view controller and pass suitable data.
            var dataViewController = ExhibitStageViewController(nibName: "ExhibitStageViewController", bundle: nil)
            dataViewController.exhibitModel = myExhibit
            dataViewController.roomModel = room
            dataViewController.view.frame = CGRect(x: 0, y:yPos, width: screenSize.width, height: screenSize.height)
            
            exhibitScrollView!.addSubview(dataViewController.view)
            self.addChildViewController(dataViewController)
            
            looper++
            
            // Create ending view
            if(looper == myExhibit.roomData.count){
                
                // create the feedback screen
                var feedbackScreen = ExhibitFeedbackScreenViewController(nibName: "ExhibitFeedbackScreenViewController", bundle: nil)
                feedbackScreen.exhibitModel = myExhibit
                feedbackScreen.view.frame = CGRect(x: 0, y:yPos+screenSize.height, width: screenSize.width, height: screenSize.height)
                feedbackScreen.view.backgroundColor = UIColor.yellowColor()
                
                exhibitScrollView!.addSubview(feedbackScreen.view)
                self.addChildViewController(feedbackScreen)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        if(exhibitScrollView!.contentOffset.y >= screenSize.height){
            eventData["showToolBar"] = "true"
            eventData["menuTitle"] = "true"
            eventData["menuTitleString"] = applicationModel.museumData[0].museum_title + ": " + applicationModel.museumData[0].exhibitData[pageIndex].exhibit_title
            
            NSNotificationCenter.defaultCenter().postNotificationName("ToggleMenuBar", object: nil, userInfo:  eventData)
        }else{
            eventData["showToolBar"] = "false"
            eventData["menuTitle"] = "false"
            eventData["menuTitleString"] = ""            
            NSNotificationCenter.defaultCenter().postNotificationName("ToggleMenuBar", object: nil, userInfo:  eventData)
        }
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!,
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
