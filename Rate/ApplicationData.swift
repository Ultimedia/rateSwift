//
//  ModelController.swift
//  PageBasedApplicationDemo
//
//  Created by Ravi Shankar on 13/08/14 edited by Maarten Bressinck
//  Copyright (c) 2014 Ravi Shankar. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import MapKit

class ApplicationData: NSObject {
    
    // Core Application Data
    var userData:[UserModel] = []
    var museumData:[MuseumModel] = []
    var beaconData:[BeaconModel] = []
    var nearestMuseum:MuseumModel?
    
    var defaultLocation = CLLocationCoordinate2D(
        latitude: 50.819478,
        longitude: 3.257726
    )
    
    // Active museum (the one closest to the user's location
    var activeMuseum:MuseumModel?
    var activeExhibition:ExhibitModel?
    
    var currentViewController:UIViewController?
    
    var menuAnimationValueForIphone = 100
    var menuAnimationValueForIpad = 100
    
    // Network
    var networkConnection:Bool = false
    var firstLogin:Bool = false
    
    // Did the user sign in using facebook or twitter?
    var localAccount = false
    
    // Current User
    var activeUser:UserModel?
    
    
    /**
    * Get local data
    */
    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    func getStoredData(){
        
        // did the user sign in?
        if let firstNameIsNotNill = defaults.objectForKey("firstLogin") as? Bool {
            firstLogin = defaults.objectForKey("firstLogin") as Bool
        }
        
        if let localAccountIsNotNill = defaults.objectForKey("localAccount") as? Bool {
            localAccount = defaults.objectForKey("localAccount") as Bool
        }
        
    }
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
    class func sharedModel() -> ApplicationData {
        return _sharedModel
    }
    
}
let _sharedModel : ApplicationData = { ApplicationData() }()