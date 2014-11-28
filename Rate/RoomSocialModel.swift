//
//  RoomSocialModel.swift
//  Rate
//
//  Created by Maarten Bressinck on 26/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import Foundation

class RoomSocialModel: NSObject, Printable {
    let mercury_room_social_id:String
    let mercury_room_id:String
    let mercury_room_social_type:String
    let mercury_room_social_data:String
    let mercury_user_id:String
    
    init(mercury_room_social_id: String?, mercury_room_id: String?, mercury_room_social_type: String?, mercury_room_social_data: String?, mercury_user_id:String?) {
        self.mercury_room_social_id = mercury_room_social_id ?? ""
        self.mercury_room_id = mercury_room_id ?? ""
        self.mercury_room_social_type = mercury_room_social_type ?? ""
        self.mercury_user_id = mercury_user_id ?? ""
        self.mercury_room_social_data = mercury_room_social_data ?? ""
    }
}