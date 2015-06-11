//
//  MuseumModel.swift
//  Rate
//
//  Created by Maarten Bressinck on 25/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import Foundation

class RoomPosModel: NSObject, Printable {
    let mercury_room_id:String
    let mercury_room_start:CGFloat
    let mercury_room_end:CGFloat

    init(mercury_room_id: String?, mercury_room_start: CGFloat?, mercury_room_end: CGFloat?) {
        self.mercury_room_id = mercury_room_id ?? ""
        self.mercury_room_start = mercury_room_start ?? 0
        self.mercury_room_end = mercury_room_end ?? 0
    }
}