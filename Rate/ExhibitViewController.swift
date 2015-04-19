//
//  ExhibitViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 19/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class ExhibitViewController: UIViewController, UIPageViewControllerDataSource {
    
    // our pageview controller
    var pageViewController: UIPageViewController?
    var currentIndex : Int = 0
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var exhibitCount:Int = 0

    // applicationModel
    let applicationModel = ApplicationData.sharedModel()    
    var eventData = Dictionary<String, String>()
    var exhibitListViewController:ExhibitListViewController?
    var exhibitListScroll:UIScrollView?
    var panelView:UIScrollView?

    var gridAdded:Bool = false

    var museumInfoPanel:UIView?
    
    
    // data
    var museumModel:[MuseumModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.blackColor()
    
        // How many exhibits in this musuem?
        exhibitCount = self.applicationModel.museumData[0].exhibitData.count
        
        // Create the pageViewController
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController?.dataSource = self
        
        let startingViewController: ExhibitHolderViewController = viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        
        pageViewController!.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: true, completion: nil)
        pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height + 50);
        
        //64
        
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
        
        eventData["icon"] = "exhibitGrid"
        NSNotificationCenter.defaultCenter().postNotificationName("RightIcon", object: nil, userInfo:  eventData)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gridToggle:", name:"GridToggle", object: nil)

        // exhibit list view controller
        exhibitListViewController = ExhibitListViewController(nibName: nil, bundle: nil)
        exhibitListViewController!.view.frame = CGRect(x: 0, y: 60, width: screenSize.width, height: 150)
        exhibitListViewController!.view.backgroundColor = applicationModel.UIColorFromRGB(0x785dc8)
        exhibitListViewController!.view.hidden = true

        
        exhibitListScroll = UIScrollView()
        exhibitListScroll!.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 150)

        exhibitListScroll!.contentSize = CGSize(width: screenSize.width, height: 150)
        exhibitListScroll!.backgroundColor = applicationModel.UIColorFromRGB(0x5225d3)
        exhibitListViewController!.view.addSubview(exhibitListScroll!)
        
        


    }
    

    
    /**
    * Grid Toggle
    */
    func gridToggle(ns:NSNotification){

        if(!gridAdded){
            gridAdded = true
            view.addSubview(exhibitListViewController!.view)
            
            var xPos:CGFloat = 20
            var counter:Int = 0
            var roomWidth:CGFloat = 0
            
            // now create the thumbs
            for room in applicationModel.selectedExhibit!.roomData{
                

                if(room.mercury_room_type == "room"){
                    
                    println("ik voeg em toe")
                    
                    let roomButton = UIButton()
                    roomButton.setTitle("Ruimte" + String(counter), forState: .Normal)
                    roomButton.setTitleColor(applicationModel.UIColorFromRGB(0x222325), forState: .Normal)
                    roomButton.frame = CGRect(x: xPos, y: 12, width: 200, height: 130)
                    roomButton.addTarget(self, action: "selectRoom:", forControlEvents: .TouchUpInside)
                    roomButton.tag = counter
                    roomButton.backgroundColor = UIColor.whiteColor()
                    
                    self.view.addSubview(roomButton)
                    
                    
                    xPos = xPos + roomButton.frame.width + CGFloat(10)
                    exhibitListScroll!.addSubview(roomButton)

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
    
    
    func selectRoom(sender: UIButton!) {
        
        println(sender.tag)
        
        eventData["roomID"] = String(sender.tag)
        NSNotificationCenter.defaultCenter().postNotificationName("ScrollToRoom", object: nil, userInfo:  eventData)

    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! ExhibitHolderViewController).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! ExhibitHolderViewController).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        index++
        if (index == exhibitCount) {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    
    func viewControllerAtIndex(index: Int) -> ExhibitHolderViewController?
    {
        if self.exhibitCount == 0 || index >= self.exhibitCount
        {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let pageContentViewController = ExhibitHolderViewController()
            pageContentViewController.pageIndex = index
        currentIndex = index
        
        return pageContentViewController
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.applicationModel.museumData[0].exhibitData.count
    }
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    /*
    /**
    * Hide status bar
    */
    override func prefersStatusBarHidden() -> Bool {
        return true
    }*/
}