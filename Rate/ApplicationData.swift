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

class ApplicationData: NSObject {
    
    // Core Application Data
    var userData:[UserModel] = []
    var museumData:[MuseumModel] = []
    var currentViewController:UIViewController?
    

    var menuAnimationValueForIphone = 100
    var menuAnimationValueForIpad = 100
    
    
    // Network
    var networkConnection:Bool = false
    var firstLogin:Bool = false
    
    class func sharedModel() -> ApplicationData {
        return _sharedModel
    }

    
}
let _sharedModel : ApplicationData = { ApplicationData() }()