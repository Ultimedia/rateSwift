//
//  MuseumModel.swift
//  Rate
//
//  Created by Maarten Bressinck on 25/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import Foundation

class RoomModel: NSObject, Printable {
    let mercury_room_id:String
    let mercury_room_exhibit_id:String
    let mercury_room_type:String
    let mercury_room_title:String
    let mercury_room_description:String
    let mercury_room_order:String
    let mercury_room_beacon_id:String
    let mediaData = Array<RoomMediaModel>()
    let socialData = Array<RoomSocialModel>()
    
    init(mercury_room_id: String?, mercury_room_exhibit_id: String?, mercury_room_type: String?, mercury_room_title: String?, mercury_room_description: String?, mercury_room_order: String?, mediaData:Array<RoomMediaModel>, socialData:Array<RoomSocialModel>, mercury_room_beacon_id:String?) {
        self.mercury_room_id = mercury_room_id ?? ""
        self.mercury_room_exhibit_id = mercury_room_exhibit_id ?? ""
        self.mercury_room_type = mercury_room_type ?? ""
        self.mercury_room_title = mercury_room_title ?? ""
        self.mercury_room_description = mercury_room_description ?? ""
        self.mercury_room_order = mercury_room_order ?? ""
        self.mercury_room_beacon_id = mercury_room_beacon_id ?? ""
        self.mediaData = mediaData
        self.socialData = socialData
    }
}