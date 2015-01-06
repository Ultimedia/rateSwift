//
//  TeaserSubViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 21/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class TeaserSubViewController: UIViewController, UICollectionViewDelegateFlowLayout {


    var museumMapView: MKMapView?
    var collectionView: UICollectionView?
    
    // Singleton Models
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()
    let applicationModel = ApplicationData.sharedModel()

    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.grayColor()
        
        createUI()
    }
    
    
    func createUI(){
        
        // add collectin
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height/2), collectionViewLayout: layout)
        collectionView!.delegate = self
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView!.backgroundColor = UIColor.redColor()
        self.view.addSubview(collectionView!)
        
        
        
        
        // museumproperties
        museumMapView = MKMapView()
        museumMapView?.frame = CGRect(x: 0, y: screenSize.height/2, width: screenSize.width, height: screenSize.height/2)
        museumMapView?.showsUserLocation = true
        view.addSubview(museumMapView!)
        
        
        // Annotations
        var annotations:[MKPointAnnotation] = []
        
        // Loop counter
        var counter:Int = 1


        // lets add museums (museum overview table)
        for museum in applicationModel.museumData{
            
            var geocoder = CLGeocoder()
            var yPos = 90*counter
            var overviewFrame:UIView = UIView()
                overviewFrame.backgroundColor = UIColor.whiteColor()
                overviewFrame.frame = CGRect(x: 10, y: yPos, width: Int(screenSize.width-20), height: 200)
            view.addSubview(overviewFrame)

            
            var subtitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 90))
                subtitleLabel.numberOfLines = 3
                subtitleLabel.lineBreakMode = .ByWordWrapping
                subtitleLabel.text = museum.museum_title
                subtitleLabel.font =  UIFont (name: "HelveticaNeue-Regular", size: 18)
                subtitleLabel.textColor = UIColor.whiteColor()
                subtitleLabel.backgroundColor = UIColor.grayColor()
                subtitleLabel.textAlignment = NSTextAlignment.Center
            
            var address = museum.museum_address
            geocoder.geocodeAddressString(address, {(placemarks, error)->Void in
                if let placemark = placemarks?[0] as? CLPlacemark {
                    
                    let location = CLLocationCoordinate2D(
                        latitude: placemark.location.coordinate.latitude,
                        longitude: placemark.location.coordinate.longitude
                    )
                    
                    var annotation = MKPointAnnotation()
                    annotation.setCoordinate(location)
                    annotation.title = "Roatan"
                    annotation.subtitle = "Honduras"
                    self.museumMapView?.addAnnotation(annotation)
                    

                    annotations.append(annotation)

                }else{
                }
                
                println(error)
            })
            
            view.addSubview(overviewFrame)
            overviewFrame.addSubview(subtitleLabel)
            
            counter++
        }

        // ipad layout update
        if(deviceFunctionService.deviceType == "ipad"){

        }
        
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
