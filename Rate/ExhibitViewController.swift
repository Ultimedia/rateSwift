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
        
        pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height + 50);
        
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as ExhibitHolderViewController).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as ExhibitHolderViewController).pageIndex
        
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
    
    
    /**
    * Hide status bar
    */
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}