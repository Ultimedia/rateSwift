//
//  DIrectionsOverlayViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 25/12/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit
import MapKit

class DIrectionsOverlayViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var instructionsButton: UIButton!
    @IBOutlet weak var buttonFooter: UIView!
    
    let applicationModel = ApplicationData.sharedModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        map.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        
        println(applicationModel.nearestMuseum!.museum_coordinate)
        
        let region = MKCoordinateRegion(center: applicationModel.nearestMuseum!.museum_coordinate!, span: span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = applicationModel.nearestMuseum!.museum_coordinate!
        annotation.title =  applicationModel.nearestMuseum!.museum_title
        annotation.subtitle = applicationModel.nearestMuseum?.museum_open
        
        map.addAnnotation(annotation)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
        
        
        // Annotations
        var annotations:[MKPointAnnotation] = []
        
        // Loop counter
        var counter:Int = 1
        
        // lets add museums (museum overview table)
        for museum in applicationModel.museumData{
            
            var geocoder = CLGeocoder()
            var address = museum.museum_address
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error)->Void in
                if let placemark = placemarks?[0] as? CLPlacemark {
                    
                    let location = CLLocationCoordinate2D(
                        latitude: placemark.location.coordinate.latitude,
                        longitude: placemark.location.coordinate.longitude
                    )
                    
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = "Roatan"
                    annotation.subtitle = "Honduras"
                    self.map?.addAnnotation(annotation)
                    
                    annotations.append(annotation)
                    
                }else{
                    
                }
                
                println(error)
            })
            
            counter++
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func instructionsButtonAction(sender: AnyObject) {
    

    }
    
    @IBOutlet weak var closeHandler: UIButton!
    
    
    @IBAction func closeHandler(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("CloseNavigationView", object: nil, userInfo:  nil)
        
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
