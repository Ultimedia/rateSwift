//
//  ExhibitViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 19/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class ExhibitViewController: UIViewController, UIPageViewControllerDelegate {

    // our pageview controller
    var pageViewController: UIPageViewController?
    
    
    // Create our model
    var modelController: ExhibitionModel {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ExhibitionModel()
        }
        return _modelController!
    }
    var _modelController: ExhibitionModel? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // make it black
        view.backgroundColor = UIColor.clearColor()
        
        createModules()
    }
    
    
    func createModules(){
        // create an UIPageViewController
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Vertical, options: nil)
        self.pageViewController!.delegate = self
        
        // set starting point
        let startingViewController:ExhibitStageViewController =  self.modelController.viewControllerAtIndex(0)!

        // asign the viewcontrollers to the UIPageviewController
        let viewControllers: NSArray = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })
        self.pageViewController!.dataSource = self.modelController
        
        // add the pageview contoller
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
       
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        var pageViewRect = self.view.bounds
        self.pageViewController!.view.frame = pageViewRect
        self.pageViewController!.didMoveToParentViewController(self)
        
        // Add the page view controller's gesture recognizers to the view controller's view so that the gestures are started more easily.
        self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
    }
    
    
    // UIPageViewController delegate methods
    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
        let currentViewController = self.pageViewController!.viewControllers[0] as UIViewController
        let viewControllers: NSArray = [currentViewController]
        
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })
        self.pageViewController!.doubleSided = false
        
        return .Min
    }
    
    
    /// super super hero I'm in cafe nero
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}