//
//  ExhibitViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 19/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class ExhibitViewController: UIViewController, UIPageViewControllerDelegate {

    @IBOutlet weak var exhibitScrollView: UIScrollView!
    
    // our pageview controller
    var pageViewController: UIPageViewController?
    let applicationData = ApplicationData.sharedModel()
    let screenSize: CGRect = UIScreen.mainScreen().bounds

    // applicationModel
    let applicationModel = ApplicationData.sharedModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.whiteColor()
        
        createExhibition()
    }
    
    
    func createExhibition(){
        view.backgroundColor = UIColor.blackColor()
        
        // current exhibi (this should be handled by the beacons)
        var myExhibit = applicationData.museumData[0].exhibitData[0]
        var scrollHeight = CGFloat((myExhibit.roomData.count)+2)
        
        // create the scrollview
        exhibitScrollView.contentSize = CGSize(width:screenSize.width, height: screenSize.height*scrollHeight)
        exhibitScrollView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        exhibitScrollView.bounces = false
        exhibitScrollView.pagingEnabled = true
        
        // rooms
        var looper:Int = 0;
        
        // Create room views
        for room in myExhibit.roomData  {
            var yPos = screenSize.height*CGFloat(looper)
            if(looper >= 1){
                print("alt")
 
                yPos = screenSize.height*CGFloat(looper+1)
            }
            
            
            // Create the overview screen
            if(looper == 1){
                
                var overviewViewController = ExhibitOverviewController(nibName: "ExhibitOverviewController", bundle:nil)
                    overviewViewController.exhibitModel = applicationData.museumData[0].exhibitData[0]
                    overviewViewController.view.frame = CGRect(x: 0, y:screenSize.height*CGFloat(looper), width: screenSize.width, height: screenSize.height)
                
                exhibitScrollView.addSubview(overviewViewController.view)
                self.addChildViewController(overviewViewController)
            }
            
        
            // Create a new view controller and pass suitable data.
            var dataViewController = ExhibitStageViewController(nibName: "ExhibitStageViewController", bundle: nil)
                dataViewController.exhibitModel = applicationData.museumData[0].exhibitData[0]
                dataViewController.roomModel = room
                dataViewController.view.frame = CGRect(x: 0, y:yPos, width: screenSize.width, height: screenSize.height)
            
                exhibitScrollView.addSubview(dataViewController.view)
                self.addChildViewController(dataViewController)
            
            
            looper++

            
            // Create ending view
            if(looper == myExhibit.roomData.count){
                
                // create the feedback screen
                var feedbackScreen = ExhibitFeedbackScreenViewController(nibName: "ExhibitFeedbackScreenViewController", bundle: nil)
                    feedbackScreen.exhibitModel = applicationData.museumData[0].exhibitData[0]
                    feedbackScreen.view.frame = CGRect(x: 0, y:yPos+screenSize.height, width: screenSize.width, height: screenSize.height)
                    feedbackScreen.view.backgroundColor = UIColor.yellowColor()
                
                    exhibitScrollView.addSubview(feedbackScreen.view)
                    self.addChildViewController(feedbackScreen)
            }
        }
    }
    
    /**
    * Hide status bar
    */
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}