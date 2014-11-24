//
//  ModelController.swift
//  PageBasedApplicationDemo
//
//  Created by Ravi Shankar on 13/08/14 edited by Maarten Bressinck
//  Copyright (c) 2014 Ravi Shankar. All rights reserved.
//

import UIKit
import CoreData

class ModelController: NSObject {

    // Beacons
    var beaconPermission:Bool = false;
    var beaconFound:Bool = false;
    
    // Network
    var networkConnection:Bool = false
    
    var firstLogin:Bool = true

    
    override init() {
        super.init()
    }
    
}

