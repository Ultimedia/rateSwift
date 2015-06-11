//
//  MuseumModel.swift
//  Rate
//
//  Created by Maarten Bressinck on 25/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import Foundation

class MuseumModel: NSObject, Printable {
    let museum_id:String
    let museum_cover:String
    let museum_title:String
    let museum_address:String
    let museum_description:String
    let museum_website:String
    let museum_twitter:String
    let museum_facebook:String
    let museum_visible:String
    let museum_open:String
    var musuem_loc:CLLocation?
    var museum_coordinate:CLLocationCoordinate2D?
    var museum_dis:Double?
    
    var exhibitData = Array<ExhibitModel>()
    

    
    
    init(museum_id: String?, museum_cover:String?, museum_title: String?, museum_address: String?, museum_description: String?, museum_website: String?, museum_twitter: String?, museum_facebook: String?, museum_visible: String?, museum_open: String?, exhibitData:Array<ExhibitModel>) {
        self.museum_id = museum_id ?? ""
        self.museum_cover = museum_cover ?? ""
        self.museum_title = museum_title ?? ""
        self.museum_address = museum_address ?? ""
        self.museum_description = museum_description ?? ""
        self.museum_website = museum_website ?? ""
        self.museum_twitter = museum_description ?? ""
        self.museum_facebook = museum_facebook ?? ""
        self.museum_visible = museum_visible ?? ""
        self.museum_open = museum_open ?? ""
        self.exhibitData = exhibitData
    }
}