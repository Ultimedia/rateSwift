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

        mapKit.layer.cornerRadius = self.mapKit.frame.size.width / 2
        mapKit.clipsToBounds = true
        mapKit.layer.borderWidth = 5.0
        mapKit.layer.borderColor = UIColor.whiteColor().CGColor
        mapKit.alpha = 0

        compasLabel.hidden = true
    }
    
    func updateMapkit(){
        mapKit.alpha = 1
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegion(center: applicationModel.nearestMuseum!.museum_coordinate!, span: span)
        
        mapKit.setRegion(region, animated: true)
        
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
