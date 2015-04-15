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
import CoreBluetooth


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
    var lastBeacon:BeaconModel?
    var location:CLPlacemark!
    var distances: [Double]?
    var museumsDic = [MuseumModel :Double]()
    var beaconCheck:CLBeacon?
    var userLocationFound:Bool = false
    var sortedMuseums:[MuseumModel]!
    var te:[MuseumModel]!
    var musArray = Array<MuseumModel>()
    var teee:AnyObject?
    
    // Beacon change validation
    var minBeaconResponder:Int = 3
    var beaconResponder = 0

    
    // distance var (the distance required for the app to look foor beacons)
    var distanceVar:Double = 100
    var beaconSearching:Bool = false

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
            
            applicationModel.location = false
            NSNotificationCenter.defaultCenter().postNotificationName("LocationPermissionFalse", object: nil, userInfo:  nil)

            
        }else{
            locationPermission = true
            println("locationpermission")
            
            applicationModel.location = true
            NSNotificationCenter.defaultCenter().postNotificationName("LocationPermissionTrue", object: nil, userInfo:  nil)

            
            // Start monitoring the beacon region
            locationManager.startRangingBeaconsInRegion(region)
            
            // Get the location of the device
            locationManager.startUpdatingLocation()
        }
    }
    
    /*
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        println(__FUNCTION__)
        if peripheral.state == CBPeripheralManagerState.PoweredOn {
            println("Broadcasting...")
            //start broadcasting
            myBTManager!.startAdvertising(_broadcastBeaconDict)
        } else if peripheral.state == CBPeripheralManagerState.PoweredOff {
            println("Stopped")
            myBTManager!.stopAdvertising()
        } else if peripheral.state == CBPeripheralManagerState.Unsupported {
            println("Unsupported")
        } else if peripheral.state == CBPeripheralManagerState.Unauthorized {
            println("This option is not allowed by your application")
        }
    }
    */
    
    
    /**
    * Find the nearest museum
    */
    func getNearestMuseum(){
        
        if(userLocationFound){
        
            var counter:Int = 0
            var geocoder = CLGeocoder()
            // see which musuem is closest
            var baboon = true
            for museum in applicationModel.museumData{
            
            // get the lat long from museum
            var address = museum.museum_address
            
            geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error)->Void in
                
                
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
                        
            
                        self.musArray = Array<MuseumModel>()
                        
                        var museumModelCount:Int = 0
                        for (k,v) in (Array(self.museumsDic).sorted {$0.1 < $1.1}) {

                            self.musArray.append(k)
                            
                            if(museumModelCount == 0){

                                // now return this beast
                                if(self.applicationModel.nearestMuseum != k){
                                    self.applicationModel.nearestMuseum = k
                                NSNotificationCenter.defaultCenter().postNotificationName("NearestMusuemChanged", object: nil, userInfo:  nil)
                                }
                                
                                // should we start checking for beacons? (do this only if we are really close to the museum
                                if(self.applicationModel.nearestMuseum?.museum_dis < self.distanceVar){
                                    
                                    // now search for beacons
                                    //self.beaconSearching = true
                                    
                                    
                                    
                                }else{
                                    
                                    //println("museum gevonden maar nog ver")
                                    
                                    // don't search for beacons (we're not close enough to the museum)
                                    self.beaconSearching = false
                                }
                                
                            }
                            
                            
                            museumModelCount++
                            
                            if(museumModelCount == self.museumsDic.count){
                                
                                // now dispatch an
                                NSNotificationCenter.defaultCenter().postNotificationName("MuseumListCompletedHandler", object: nil, userInfo:  nil)

                            }
                        }
                        
                    }
                }else{
                    
                    println("can't map this location")
                    println(address)
                    
                }
            })
        }
        }
    }

    

    
    /**
    * Handle iBeacon events
    */
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
    
        
        
        if(beaconSearching){
            
        // strip the beacons that have an unknown proximity
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        var latestMinor:Int = 0
        var currentMuseumId:Int = 0
        var beaconCollection:Array<BeaconModel>
        var exhibitCollection = Array<ExhibitModel>()
        var counter:Int = 0
        
            
        // once the selected exhibit is eanbled we hav eto do things differently
        if(applicationModel.localExhibitSelected){

            println("selected yes")
            
            // get the exhibit id
            var myExhibitId = applicationModel.selectedExhibit?.exhibit_id
            
            if (knownBeacons.count > 0) {
                
                
                //get closest beacon
                closestBeacon = knownBeacons[0] as? CLBeacon
                
                // gotoArtwork
                var minor:Int = Int(closestBeacon!.minor)
                
                // check if this beacon matches one of the beacons in the  database
                if(applicationModel.beaconData.count > 0 && latestMinor != closestBeacon?.minor){
                    
                    // check our beacons
                    for beacon in applicationModel.beaconData{
                    
                        // see if this beacon mathces one of the beacons in the system
                        if(minor == (beacon.mercury_beacon_device_id.toInt())){
                            
                            if(lastBeacon?.mercury_museum_id.toInt() != beacon.mercury_museum_id.toInt() && beacon.mercury_exhibit_id == applicationModel.selectedExhibit?.exhibit_id){
                                
                                lastBeacon = beacon
                                applicationModel.nearestBeacon = beacon
                                
                                
                                
                                for room in applicationModel.selectedExhibit!.roomData{
                                    if(room.mercury_room_id == beacon.mercury_room_id){
                                        applicationModel.nearestRoom = room
                                    }
                                }
                                
                                
                                // an extra check
                                if(beaconResponder >= minBeaconResponder){
                                
                                    beaconResponder = 0
                                    
                                    // now tell the app we have the beacon in hands
                                    NSNotificationCenter.defaultCenter().postNotificationName("BeaconsChanged", object: nil, userInfo:  nil)
                                    
                                }
                                
                            }else{
                                beaconResponder++
                            }
                        }
                    }
                }
            }
            
        }else{
            
        // proceed if we have beacons in range
        // first element in array is the closest beacon
        if (knownBeacons.count > 0) {
    
    
            //get closest beacon
            closestBeacon = knownBeacons[0] as? CLBeacon
            
            // Loop through the beacons
            for clBeacon in knownBeacons{
                
                var dminor:Int = Int(clBeacon.minor)
            
                // map beacons
                for beacon in applicationModel.beaconData{
                    if(dminor == (beacon.mercury_beacon_device_id.toInt())){

                        latestMinor = closestBeacon?.minor as! Int
                        
                        
                        
                        for exhibit in applicationModel.selectedMuseum!.exhibitData{
                            
                            if(exhibit.exhibit_id == beacon.mercury_exhibit_id){
                                exhibitCollection.append(exhibit)
                            }
                        }
                    }
                }
                
                counter++
                
                // last one
                if(counter == knownBeacons.count && exhibitCollection.count != 0){
                    //println(exhibitCollection)
                    applicationModel.nearestExhibit = exhibitCollection[0]
                    applicationModel.activeExhibits = exhibitCollection
                    
                    
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("BeaconsDetected", object: nil, userInfo:  nil)
                    
                    beaconResponder = 0
                    }
                }
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
    
        userLocationFound = true
            
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

