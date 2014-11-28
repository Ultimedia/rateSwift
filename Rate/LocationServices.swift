//
//  LocationManager.swift
//  Rate
//
//  Created by Maarten Bressinck on 27/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Foundation
import CoreLocation



class LocationSevices: NSObject, CLLocationManagerDelegate {
    class func locationServices() -> LocationSevices {
        return _locationServices
    }
    
    // An instance of a core location manager
    var locationManager = CLLocationManager()
    var deviceLocationManager : CLLocationManager?
    
    // Your beacon uuid and identifier
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"), identifier: "Estimotes")
    
    // applicationModel
    let applicationModel = ApplicationData.sharedModel()
    
    // store the current userLocation
    var userLocation = Dictionary<String,CLLocationDegrees>()
    
    // Beacons
    var locationPermission:Bool = false;
    var beaconFound:Bool = false;
    
    /**
    * Setup beacons
    */
    func initLocationServices(){
        
        // Let our locationManager know that this View Controller should be its delegate (so it should deliver its messages here)
        locationManager.delegate = self;
        
        // Ask user permission and check if the permission has been granted
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            println("no location permission :(")
            locationPermission = false
            locationManager.requestWhenInUseAuthorization()
        }else{
            locationPermission = true
            println("locationpermission")
            
            // Start monitoring the beacon region
            locationManager.startRangingBeaconsInRegion(region)
            
            // Get the location of the device
            locationManager.startUpdatingLocation()
        }
    }
    
    
    /**
    * Handle iBeacon events
    */
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        // show all beacons
        //println(beacons)
        
        // strip the beacons that have an unknown proximity
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        
        // proceed if we have beacons in range
        // first element in array is the closest beacon
        if (knownBeacons.count > 0) {
            
            //get closest beacon
            let closestBeacon = knownBeacons[0] as CLBeacon
            
            // gotoArtwork
            var minor:Int = Int(closestBeacon.minor)
            var te:String = String(minor)
            
        }
    }
    
    
    /**
    * Get location of the device
    */
    func locationManager(manager: CLLocationManager!,
        didUpdateToLocation newLocation: CLLocation!,
        fromLocation oldLocation: CLLocation!){
            
        userLocation["lat"] = newLocation.coordinate.latitude
        userLocation["lon"] = newLocation.coordinate.longitude
    }
    
    
    /**
    * Get nearest museum
    */
    func getNearestMuseum(){
        
    }
    
    
    /**
    * Error
    */
    func locationManager(manager: CLLocationManager!,
        didFailWithError error: NSError!){
            println("Location manager failed with error = \(error)")
    }
}
let _locationServices : LocationSevices = { LocationSevices() }()