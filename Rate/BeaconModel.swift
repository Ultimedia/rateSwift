//
//  MuseumModel.swift
//  Rate
//
//  Created by Maarten Bressinck on 25/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import Foundation

class BeaconModel: NSObject, Printable {
    let mercury_beacon_id:String
    let mercury_beacon_identifier:String
    let mercury_beacon_device_id:String
    let mercury_exhibit_id:String
    let mercury_beacon_uuid:String
    let mercury_room_id:String
    let mercury_media_id:String
    let mercury_museum_id:String

    
    
    init(mercury_beacon_id: String?, mercury_beacon_identifier: String?, mercury_beacon_device_id: String?, mercury_exhibit_id: String?, mercury_beacon_uuid:String?, mercury_room_id:String?, mercury_media_id:String?, mercury_museum_id:String?) {
        self.mercury_beacon_id = mercury_beacon_id ?? ""
        self.mercury_beacon_identifier = mercury_beacon_identifier ?? ""
        self.mercury_beacon_device_id = mercury_beacon_device_id ?? ""
        self.mercury_exhibit_id = mercury_exhibit_id ?? ""
        self.mercury_beacon_uuid = mercury_beacon_uuid ?? ""
        self.mercury_room_id = mercury_room_id ?? ""
        self.mercury_media_id = mercury_media_id ?? ""
        self.mercury_museum_id = mercury_museum_id ?? ""
    }
}




