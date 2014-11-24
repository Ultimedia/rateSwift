//
//  ModelController.swift
//  PageBasedApplicationDemo
//
//  Created by Ravi Shankar on 13/08/14 edited by Maarten Bressinck
//  Copyright (c) 2014 Ravi Shankar. All rights reserved.
//

import UIKit
import CoreData


class ExhibitionModel: NSObject, UIPageViewControllerDataSource {
    // Core variables
    var rooms = [Dictionary<String, String>]()
    var globalIndex = 0
    
    
    // Exhibition Specific
    var exhibitonTitle:String = "Richard Mosse"
    var museumTitle:String = "FoMu"
    var exhibitionDescription:String = "Richard Mosse brengt de gewapende rebellengroepen in het oosten van de Democratische Republiek Congo in beeld met infraroodfilm die oorspronkelijk ontwikkeld was voor militaire camouflagedetectie. Deze in onbruik geraakte film registreert infraroodlicht en krijgt daardoor een opmerkelijk kleurenpalet van felroze en groenblauw."
    var coverImage:String = ""
    
    
    // Address
    var street:String = "Italienlei"
    var houseNumber:Int = 12
    var postCode:Int = 2000
    var floor:Int = 2
    
    
    // Opening hours
    var openingHours:Int = 222
    
    
    // Sharing Settings
    var twitterEnabled:Bool = true
    var twitterID:String = "@ultimedia"
    var twitterHash:String = "FoMu"
    var facebookEnabled:Bool = true
    var facebookID:String = "Ultimedia"
    
    
    // Helper function to create the data
    func addRoom(title: String, type:String, images:String, uniquehash:String, description: String, beaconID:String ){
        
        var roomInformation = [
            "title"  : title,
            "type": type,
            "images"  : images,
            "uniquehash"   : uniquehash,
            "description": description,
            "beaconID": beaconID
        ]
        
        self.rooms.append(roomInformation);
    }
    
    override init() {
        super.init()
        
        // Add the data
        addRoom("Room1", type: "intro", images: "cover", uniquehash: "hello3", description: "hello4", beaconID: "20467")
        addRoom("Room2", type: "room", images: "introduction", uniquehash: "hello3", description: "hello4", beaconID: "20467")
        addRoom("Room3", type: "exit", images: "introduction", uniquehash: "hello3", description: "hello4", beaconID: "20467")
    }
    
    func viewControllerAtIndex(index: Int) -> ExhibitStageViewController? {
        // Return the data view controller for the given index.
        if (self.rooms.count == 0) || (index >= self.rooms.count) {
            return nil
        }
                
        // set starting point
        let dataViewController = ExhibitStageViewController(nibName: "ExhibitStageViewController", bundle: nil)
            dataViewController.dataObject = self.rooms[index]
            dataViewController.exhibitionModel = self
        
            println("index")
            println(index)
        
        return dataViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = globalIndex
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        

        
        index--
        globalIndex = index
        
        
        println("min")
        println(index)
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = globalIndex
        if index == NSNotFound {
            return nil
        }
        
        index++
        if index == self.rooms.count {
            return nil
        }
        
        println("plus")
        println(index)
        
        globalIndex = index
        return self.viewControllerAtIndex(index)
    }
    
    // go to an item after getting the call from a beacon
    func gotoItemFromBeacon(beaconReference: String) {
        for room in rooms {
            var beaconID = room["beaconID"]
        }
    }
}

