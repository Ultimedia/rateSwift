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
    var panelView:UIScrollView?

    var museumInfoPanel:UIView?
    
    // data
    var museumModel:[MuseumModel] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blackColor()
    
        // How many exhibits in this musuem?
        exhibitCount = self.applicationModel.selectedMuseum!.exhibitData.count
        
        applicationModel.selectedMuseumDuplicate = self.applicationModel.selectedMuseum;
                
        var firstEx = applicationModel.selectedMuseumDuplicate?.exhibitData[applicationModel.selectedExhibitIndex];
        applicationModel.selectedMuseumDuplicate!.exhibitData.removeAtIndex(applicationModel.selectedExhibitIndex)
        applicationModel.selectedMuseumDuplicate!.exhibitData.insert(firstEx!, atIndex: 0)
        
        // Create the pageViewController
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController?.dataSource = self
        
        let startingViewController: ExhibitHolderViewController = viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        
        pageViewController!.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: true, completion: nil)
        pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height + 50);
        
        currentIndex = applicationModel.selectedExhibitIndex;
        
        
        //64
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
        
        eventData["icon"] = "exhibitGrid"
        NSNotificationCenter.defaultCenter().postNotificationName("RightIcon", object: nil, userInfo:  eventData)

    }
    

    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        println("function 1")
        
        var index = (viewController as! ExhibitHolderViewController).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        
        println("functie 2")
        
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
        println("functio 3")
        
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
        return self.applicationModel.selectedMuseum!.exhibitData.count
    }
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        println("functie 5")
        
        return 0
    }
}