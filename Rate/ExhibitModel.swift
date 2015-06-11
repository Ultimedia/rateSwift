//
//  MuseumModel.swift
//  Rate
//
//  Created by Maarten Bressinck on 25/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import Foundation

class ExhibitModel: NSObject, Printable {
    // Core data
    let exhibit_id:String
    let exhibit_museum_id:String
    let exhibit_title:String
    let exhibit_description:String
    let exhibit_hash:String
    let exhibit_website:String
    let exhibit_twitter:String
    let exhibit_facebook:String
    let exhibit_subtitle:String
    let exhibit_cover_image:String
    let exhibit_twitter_enabled:String
    let exhibit_facebook_enabled:String
    let exhibit_opening_hours:String
    var roomData = Array<RoomModel>()
    var myRoom:RoomModel?
    var beaconData = Array<BeaconModel>()
    

    // Default Texts
    let overviewInfo_Dutch = "Begeef je door de exhibitie, deze app zal je automatisch begeleiden. Hieronder vind je een overzicht met de verschillende ruimtes die de worden geactiveerd"
    let overviewTitle_Dutch = "Overzicht"
    let outroviewInfo_Dutch = "Einde"
    let outroviewTitle_Dutch = "Einde"
    
    
    // Functional variables
    var globalIndex = 1
    
    init(exhibit_id: String?, exhibit_museum_id: String?, exhibit_title: String?, exhibit_description: String?, exhibit_hash: String?, exhibit_twitter: String?, exhibit_facebook: String?, exhibit_subtitle: String?, exhibit_cover_image: String?, exhibit_twitter_enabled:String?, exhibit_facebook_enabled:String?, exhibit_opening_hours:String?,  exhibit_website:String?, roomData:Array<RoomModel>, beaconData:Array<BeaconModel>) {
        self.exhibit_id = exhibit_id ?? ""
        self.exhibit_museum_id = exhibit_museum_id ?? ""
        self.exhibit_title = exhibit_title ?? ""
        self.exhibit_description = exhibit_description ?? ""
        self.exhibit_subtitle = exhibit_subtitle ?? ""
        self.exhibit_cover_image = exhibit_cover_image ?? ""
        self.exhibit_twitter = exhibit_twitter ?? ""
        self.exhibit_facebook = exhibit_facebook ?? ""
        self.exhibit_hash = exhibit_hash ?? ""
        self.exhibit_website = exhibit_website ?? ""
        self.exhibit_twitter_enabled = exhibit_twitter_enabled ?? ""
        self.exhibit_facebook_enabled = exhibit_facebook_enabled ?? ""
        self.exhibit_opening_hours = exhibit_opening_hours ?? "" 
        self.roomData = roomData
        self.beaconData = beaconData
    }
      // go to an item after getting the call from a beacon
    func gotoItemFromBeacon(beaconReference: String) {
        /*for room in rooms {
            var beaconID = room["beaconID"]
        }*/
    }

}