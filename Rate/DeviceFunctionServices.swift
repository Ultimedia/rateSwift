//
//  DeviceFunctionServices.swift
//  Rate
//
//  Created by Maarten Bressinck on 27/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import Foundation
class DeviceFunctionServices: NSObject {
    
    var deviceType:String = "iphone"
    
    class func deviceFunctionServices() -> DeviceFunctionServices {
        return _deviceFunctionServices
    }
    
    /**
    * Are we running an ipad or an iphone?
    */
    func detectDevice(){
        if(UIDevice.currentDevice().userInterfaceIdiom == .Pad){
            deviceType = "ipad"
        }else if(UIDevice.currentDevice().userInterfaceIdiom == .Phone){
            deviceType = "iphone"
        }else{
        
        }
    }
}

let _deviceFunctionServices : DeviceFunctionServices = { DeviceFunctionServices() }()
    