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
    var closestBeacon:CLBeacon?
    
    var location:CLPlacemark!
    var distances: [Double]?
    var museumsDic = [MuseumModel :Double]()

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
    * Find the nearest museum
    */
    func getNearestMuseum(){
        //et distance = fromLocation.distanceFromLocation(toLocation)

        println("musuem zoeken")
        
        var counter:Int = 0
        var geocoder = CLGeocoder()
        // see which musuem is closest
        var baboon = true
        for museum in applicationModel.museumData{
            
            // get the lat long from museum
            var address = museum.museum_address
            
            geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, {(placemarks, error)->Void in
                
                
                if let placemark = placemarks?[0] as? CLPlacemark {
                    
                    museum.musuem_loc = CLLocation(latitude: placemark.location.coordinate.latitude, longitude: placemark.location.coordinate.longitude)
                    
                    museum.museum_coordinate = CLLocationCoordinate2D(
                        latitude: placemark.location.coordinate.latitude,
                        longitude: placemark.location.coordinate.longitude
                    )
                    
                    var userLoc = CLLocation(latitude: self.userLocation["lat"]!, longitude: self.userLocation["lon"]!)
                    
                    
                    
                    museum.museum_dis = museum.musuem_loc!.distanceFromLocation(userLoc)
                    museum.museum_dis = museum.museum_dis! / 1000.0
                    self.museumsDic[museum] = museum.museum_dis
                    
                    
                    
                    counter++
                    
                    // last iteration
                    if(counter == self.applicationModel.museumData.count){
                        var museumModelCount:Int = 0
                        for (k,v) in (Array(self.museumsDic).sorted {$0.1 < $1.1}) {


                            if(museumModelCount == 0){

                                // now return this beast
                                self.applicationModel.nearestMuseum = k
                            NSNotificationCenter.defaultCenter().postNotificationName("NearestMusuemChanged", object: nil, userInfo:  nil)
                            }
                            museumModelCount++
                        }
                    }
                    
                }else{
                    
                }
            })
        }
    }

    

    
    /**
    * Handle iBeacon events
    */
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        // strip the beacons that have an unknown proximity
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        
        var latestMinor:Int = 0
        var currentMuseumId:Int = 0
        
        // proceed if we have beacons in range
        // first element in array is the closest beacon
        if (knownBeacons.count > 0) {
        
            //get closest beacon
            closestBeacon  = knownBeacons[0] as? CLBeacon
            
            // gotoArtwork
            var minor:Int = Int(closestBeacon!.minor)
            var te:String = String(minor)
            
            // check if this beacon matches one of the beacons in the  database
            if(applicationModel.beaconData.count > 0 && latestMinor != closestBeacon?.minor){
                
                var lastBeacon:BeaconModel?

                // check our beacons
                for beacon in applicationModel.beaconData{
                    
                    // see if this beacon mathces one of the beacons in the system
                    if(closestBeacon?.minor == (beacon.mercury_beacon_device_id.toInt())){
                        
                        
                        if(lastBeacon == nil || lastBeacon?.mercury_museum_id != beacon.mercury_museum_id){
                        
                            currentMuseumId = beacon.mercury_museum_id.toInt()!
                            latestMinor = closestBeacon?.minor as Int

                            
                            // get the museum we're in
                            for museum in applicationModel.museumData{
                            
                                if(beacon.mercury_museum_id == museum.museum_id){
                                    applicationModel.activeMuseum = museum as MuseumModel
                                
                                    NSNotificationCenter.defaultCenter().postNotificationName("MuseumFound", object: nil, userInfo:  nil)

                                    // now get the exhibiton
                                    for exhibit in museum.exhibitData{
                                        if(exhibit.exhibit_id == beacon.mercury_exhibit_id){
                                            applicationModel.activeExhibition = exhibit
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                    lastBeacon = beacon
                }
            }
        }
    }
    
    
    /**
    * Check if the nearest beacon matches the exhibition
    */
    func nearestBeacon(){
    
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
    * Error
    */
    func locationManager(manager: CLLocationManager!,
        didFailWithError error: NSError!){
            println("Location manager failed with error = \(error)")
    }
}
let _locationServices : LocationSevices = { LocationSevices() }()

