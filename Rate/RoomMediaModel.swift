//
//  MuseumModel.swift
//  Rate
//
//  Created by Maarten Bressinck on 25/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import Foundation

class RoomMediaModel: NSObject, Printable {
    let mercury_room_media_id:String
    let mercury_room_id:String
    let mercury_room_media_url:String
    let mercury_room_media_caption:String
    let mercury_room_media_type:String
    let mercury_room_author:String

    
    init(mercury_room_media_id: String?, mercury_room_id: String?, mercury_room_media_url: String?, mercury_room_media_caption: String?, mercury_room_media_type:String?, mercury_room_author:String?) {
        self.mercury_room_media_id = mercury_room_media_id ?? ""
        self.mercury_room_id = mercury_room_id ?? ""
        self.mercury_room_media_url = mercury_room_media_url ?? ""
        self.mercury_room_media_caption = mercury_room_media_caption ?? ""
        self.mercury_room_media_type = mercury_room_media_type ?? ""
        self.mercury_room_author = mercury_room_author  ?? ""
    }
}