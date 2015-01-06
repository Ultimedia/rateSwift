//
//  CompassViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 27/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit
import MapKit

class CompassViewController: UIViewController {
    @IBOutlet weak var compasLabel: UILabel!

    @IBOutlet weak var mapKit: MKMapView!
    
    let applicationModel = ApplicationData.sharedModel()
    var map:DIrectionsOverlayViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clearColor()
        /*
        // Create a new CircleView
        var circleView = CompassView(frame: CGRectMake((view.frame.width-100)/2, (view.frame.height-100)/2-20, 100, 100))
        //var circleView:CompassView = CompassView(frame: CGRectMake((view.frame.width-100)/2, (view.frame.height-100)/2-20, 100, 100))
        view.addSubview(circleView)
        
        // Animate the drawing of the circle over the course of 1 second
        circleView.animateCircle(5.0)
        */

        mapKit.layer.cornerRadius = self.mapKit.frame.size.width / 2
        mapKit.clipsToBounds = true
        mapKit.layer.borderWidth = 3.0
        mapKit.layer.borderColor = UIColor.whiteColor().CGColor
        mapKit.alpha = 0
    }
    
    func updateMapkit(){
        mapKit.alpha = 1
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegion(center: applicationModel.nearestMuseum!.museum_coordinate!, span: span)
        
        mapKit.setRegion(region, animated: true)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    
        println("open map view")

        NSNotificationCenter.defaultCenter().postNotificationName("ShowMapPopup", object: nil, userInfo:  nil)

    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
