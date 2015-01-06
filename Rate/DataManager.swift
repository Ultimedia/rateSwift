//
//  DataManager.swift
//  TopApps
//
//  Created by Dani Arnaout on 9/2/14.
//  Edited by Eric Cerney on 9/27/14.
//  Copyright (c) 2014 Ray Wenderlich All rights reserved.
//

import Foundation


class DataManager: NSObject {
    let museumUrl = "http://ultimedia.biz/mulab/museums"
    let userUrl = "http://ultimedia.biz/mulab/users"
    var userSaveUrl = "http://ultimedia.biz/mulab/user"
    var beaconUrl = "http://ultimedia.biz/mulab/beacons"

    
    // Data load checks
    var userLoaded:Bool = false
    var museumLoaded:Bool = false
    var dataLoaded:Bool = false
    
    // applicationModel
    let applicationModel = ApplicationData.sharedModel()

    
    func checkDataLoad(){
        if(userLoaded == true && museumLoaded == true){
            dataLoaded = true
        }
    }
    
    
    class func dataManager() -> DataManager {
        return _dataManager
    }
    

    /**
    * Load core applicationData
    */
    func loadData(){
        
        // Get all beacons
        getBeaconData { (beaconData) -> Void in
            let json = JSON(data: beaconData)
            
            // get all beacons involved
            if let beaconArray = json["beacons"].arrayValue {
                var beaconData = [BeaconModel]()
                
                for beacon in beaconArray{
                    
                    let mercury_beacon_id:String? = beacon["mercury_beacon_id"].stringValue
                    let mercury_beacon_identifier:String? = beacon["mercury_beacon_identifier"].stringValue
                    let mercury_beacon_device_id:String? = beacon["mercury_beacon_device_id"].stringValue
                    let mercury_exhibit_id:String? = beacon["mercury_exhibit_id"].stringValue
                    let mercury_beacon_uuid:String? = beacon["mercury_beacon_uuid"].stringValue
                    let mercury_room_id:String? = beacon["mercury_room_id"].stringValue
                    let mercury_media_id:String? = beacon["mercury_media_id"].stringValue
                    let mercury_museum_id:String? = beacon["mercury_museum_id"].stringValue

                    var beaconModel = BeaconModel(mercury_beacon_id: mercury_beacon_id, mercury_beacon_identifier:mercury_beacon_identifier , mercury_beacon_device_id:mercury_beacon_device_id , mercury_exhibit_id:mercury_exhibit_id , mercury_beacon_uuid:mercury_beacon_uuid, mercury_room_id:mercury_room_id, mercury_media_id:mercury_media_id, mercury_museum_id:mercury_museum_id)
                    
                    self.applicationModel.beaconData.append(beaconModel)
                }
            }
        }
        
        
        // Fetch userData from JSON
        getUserData { (userData) -> Void in
            let json = JSON(data: userData)
            
            // get all museums involved
            if let userArray = json["users"].arrayValue {
                var userData = [UserModel]()
                
                for user in userArray {
                    let user_id:String? = user["user_id"].stringValue
                    let user_name:String? = user["user_name"].stringValue
                    let user_image:String? = user["user_image"].stringValue
                    let user_twitterhandle:String? = user["user_twitterhandle"].stringValue
                    let user_facebookid:String? = user["user_facebookid"].stringValue
                    let user_active:String? = user["user_active"].stringValue
                    
                    var userModel = UserModel(user_id: user_id, user_name: user_name, user_image: user_image, user_twitterhandle: user_twitterhandle, user_facebookid: user_facebookid, user_active: user_active)
                    
                    self.applicationModel.userData.append(userModel)
                }
            }
            
            let mySelf = DataManager.dataManager()
                mySelf.userLoaded = true
                mySelf.checkDataLoad()
        }
        
        // Fetch museumData from JSON
        getMuseumData { (museumData) -> Void in
            // show activity indicator, disable interactions
            
            let json = JSON(data: museumData)
            
            // get all museums involved
            if let museumArray = json["museums"].arrayValue {
                var museumData = [MuseumModel]()
                
                for museum in museumArray {
                    
                    var museum_id: String? = museum["museum_id"].stringValue
                    var museum_title: String? = museum["museum_title"].stringValue
                    var museum_address: String? = museum["museum_address"].stringValue
                    var museum_open: String? = museum["museum_open"].stringValue
                    var museum_website: String? = museum["museum_website"].stringValue
                    var museum_twitter: String? = museum["museum_twitter"].stringValue
                    var museum_facebook: String? = museum["museum_facebbook"].stringValue
                    var museum_visible: String? = museum["museum_visible"].stringValue
                    var museum_description: String? = museum["museum_description"].stringValue
                    
                    // get all exhibits in that museum
                    var exhibitData = [ExhibitModel]()
                    if let exhibitArray = museum["exhibits"].arrayValue {
                        
                        for exhibit in exhibitArray {
                            
                            let exhibit_id:String? = exhibit["exhibit_id"].stringValue
                            let exhibit_museum_id:String? = exhibit["exhibit_museum_id"].stringValue
                            let exhibit_title:String? = exhibit["exhibit_title"].stringValue
                            let exhibit_description:String? = exhibit["exhibit_description"].stringValue
                            let exhibit_hash:String? = exhibit["exhibit_hash"].stringValue
                            let exhibit_website:String? = exhibit["exhibit_website"].stringValue
                            let exhibit_twitter:String? = exhibit["exhibit_twitter"].stringValue
                            let exhibit_facebook:String? = exhibit["exhibit_facebook"].stringValue
                            let exhibit_subtitle:String? = exhibit["exhibit_subtitle"].stringValue
                            let exhibit_cover_image:String? = exhibit["exhibit_cover_image"].stringValue
                            let exhibit_twitter_enabled = exhibit["exhibit_twitter_enabled"].stringValue
                            let exhibit_facebook_enabled = exhibit["exhibit_facebook_enabled"].stringValue
                            
                            // get all beacons inside an exhibit
                            var beaconData = [BeaconModel]()
                            if let beaconArray = exhibit["beacons"].arrayValue {
                                
                                for beacon in beaconArray{
                                    
                                    let mercury_beacon_id:String? = beacon["mercury_beacon_id"].stringValue
                                    let mercury_beacon_identifier:String? = beacon["mercury_beacon_identifier"].stringValue
                                    let mercury_beacon_device_id:String? = beacon["mercury_beacon_device_id"].stringValue
                                    let mercury_exhibit_id:String? = beacon["mercury_exhibit_id"].stringValue
                                    let mercury_beacon_uuid:String? = beacon["mercury_beacon_uuid"].stringValue
                                    let mercury_room_id:String? = beacon["mercury_room_id"].stringValue
                                    let mercury_media_id:String? = beacon["mercury_media_id"].stringValue
                                    let mercury_museum_id:String? = beacon["mercury_museum_id"].stringValue
                                    
                                    var beaconModel = BeaconModel(mercury_beacon_id: mercury_beacon_id, mercury_beacon_identifier:mercury_beacon_identifier , mercury_beacon_device_id:mercury_beacon_device_id , mercury_exhibit_id:mercury_exhibit_id , mercury_beacon_uuid:mercury_beacon_uuid, mercury_room_id:mercury_room_id, mercury_media_id:mercury_media_id, mercury_museum_id:mercury_museum_id)
                                    
                                    beaconData.append(beaconModel)
                                }
                            }
                            
                            
                            // get all rooms inside an exhibit
                            var roomData = [RoomModel]()
                            if let roomArray = exhibit["rooms"].arrayValue {
                                
                                for room in roomArray{
                                    
                                    let mercury_room_id:String? = room["mercury_room_id"].stringValue
                                    let mercury_room_exhibit_id:String? = room["mercury_room_exhibit_id"].stringValue
                                    let mercury_room_type:String? = room["mercury_room_type"].stringValue
                                    let mercury_room_title:String? = room["mercury_room_title"].stringValue
                                    let mercury_room_description:String? = room["mercury_room_description"].stringValue
                                    let mercury_room_beacon_id:String? =  room["mercury_room_beacon_id"].stringValue
                                    let mercury_room_hash:String? = room["mercury_room_hash"].stringValue
                                    
                                    
                                    // get all media inside this room
                                    var mediaData = [RoomMediaModel]()
                                    if let roomMediaArray = room["mediaData"].arrayValue {
                                        
                                        for media in roomMediaArray{
                                            let mercury_room_media_id:String? = media["mercury_room_media_id"].stringValue
                                            let mercury_room_id:String? = media["mercury_room_id"].stringValue
                                            let mercury_room_media_url:String? = media["mercury_room_media_url"].stringValue
                                            let mercury_room_media_description:String? = media["mercury_room_media_description"].stringValue
                                            
                                            var mediaModel = RoomMediaModel(mercury_room_media_id: mercury_room_media_id, mercury_room_id: mercury_room_id, mercury_room_media_url: mercury_room_media_url, mercury_room_media_description: mercury_room_media_description)
                                            
                                            mediaData.append(mediaModel)
                                        }
                                    }
                                    
                                    // get all social data inside this room
                                    var socialData = [RoomSocialModel]()
                                    if let roomSocialArray = room["socialData"].arrayValue{
                                        
                                        for social in roomSocialArray{
                                            let mercury_room_social_id:String? = social["mercury_room_social_id"].stringValue
                                            let mercury_room_id:String? = social["mercury_room_id"].stringValue
                                            let mercury_room_social_type:String? = social["mercury_room_social_type"].stringValue
                                            let mercury_room_social_data:String? = social["mercury_room_social_data"].stringValue
                                            let mercury_user_id:String? = social["mercury_user_id"].stringValue
                                            
                                            var socialModel = RoomSocialModel(mercury_room_social_id: mercury_room_social_id, mercury_room_id: mercury_room_id, mercury_room_social_type: mercury_room_social_type, mercury_room_social_data: mercury_room_social_data, mercury_user_id:mercury_user_id)
                                            
                                            socialData.append(socialModel)
                                        }
                                    }
                                    
                                    
                                    var roomModel = RoomModel(mercury_room_id: mercury_room_id, mercury_room_exhibit_id: mercury_room_exhibit_id, mercury_room_type: mercury_room_type, mercury_room_title: mercury_room_title, mercury_room_description: mercury_room_description, mercury_room_hash: mercury_room_hash,mediaData: mediaData, socialData: socialData, mercury_room_beacon_id: mercury_room_beacon_id)
                                    
                                    roomData.append(roomModel)
                                }
                                
                            }
                            
                            var exhibitModel = ExhibitModel(exhibit_id:exhibit_id , exhibit_museum_id:exhibit_museum_id , exhibit_title:exhibit_title , exhibit_description:exhibit_description , exhibit_hash:exhibit_hash , exhibit_twitter:exhibit_twitter , exhibit_facebook:exhibit_facebook , exhibit_subtitle:exhibit_subtitle , exhibit_cover_image:exhibit_cover_image, exhibit_twitter_enabled: exhibit_twitter_enabled, exhibit_facebook_enabled:exhibit_facebook_enabled, exhibit_website:exhibit_website, roomData: roomData, beaconData: beaconData)
                            
                            exhibitData.append(exhibitModel)
                        }
                        
                        var exhibits: Array? = exhibitData
                    }
                    
                    var museumModel = MuseumModel(museum_id: museum_id, museum_title: museum_title, museum_address: museum_address, museum_description: museum_description, museum_website: museum_website, museum_twitter: museum_twitter, museum_facebook: museum_facebook, museum_visible: museum_visible, museum_open: museum_open, exhibitData:exhibitData)
                    
                    // now push everything to the main applicationModel
                    self.applicationModel.museumData.append(museumModel)
                }
            }
            
            
            //self.applicationModel.activeMuseum = applicationModel.museumData[0]
            
            let mySelf = DataManager.dataManager()
            mySelf.museumLoaded = true
            mySelf.checkDataLoad()
        }
    }

    

    /**
    * Post user data to server
    */
    func postUserData(userModel:UserModel){
        
        var user_name:String = userModel.user_name
        var user_image:String = userModel.user_image
        var user_twitterhandle:String = userModel.user_twitterhandle
        var user_facebookid:String = userModel.user_facebookid
        
        var urlAsString = ""
        urlAsString += "user_name=" + user_name
        urlAsString += "&user_image=" + user_image
        urlAsString += "&user_twitter=" + user_twitterhandle
        urlAsString += "&user_facebookid=" + user_facebookid
        
        postData(userSaveUrl, dataString: urlAsString)
    }
    
    
    func postData(urlString:String, dataString:String){
        let httpMethod = "POST"
        let timeout = 15
        
        let body = dataString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let queue = NSOperationQueue()
        
        let url = NSURL(string: urlString)
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,timeoutInterval: 15.0)
            urlRequest.HTTPMethod = httpMethod
            urlRequest.HTTPBody = body
        
        NSURLConnection.sendAsynchronousRequest(urlRequest,
            queue: queue, completionHandler: {(response: NSURLResponse!,
                data: NSData!,
                error: NSError!) in
                
                if data.length > 0 && error == nil{
                    let html = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("html = \(html)")
                } else if data.length == 0 && error == nil{
                    println("Nothing was downloaded")
                } else if error != nil{
                    println("Error happened = \(error)")
                }
            }
        )
    }

    
    /**
    * Get users
    */
    func getUserData(success: ((userData: NSData!) -> Void)) {
        
        loadDataFromURL(NSURL(string: userUrl)!, completion:{(data, error) -> Void in
        let applicationModel = ApplicationData.sharedModel()
        
        if let urlData = data {
            success(userData: urlData)
        }
        })
    }
    
    
    /**
    * Get beacons
    */
    func getBeaconData(success: ((beaconData: NSData!) -> Void)) {
        
        loadDataFromURL(NSURL(string: beaconUrl)!, completion:{(data, error) -> Void in
            let applicationModel = ApplicationData.sharedModel()
            
            if let urlData = data {
                success(beaconData: urlData)
            }
        })
    }
    
    
    
    /**
    * Get musuem data
    */
    func getMuseumData(success: ((museumData: NSData!) -> Void)) {
        loadDataFromURL(NSURL(string: museumUrl)!, completion:{(data, error) -> Void in
            
            let applicationModel = ApplicationData.sharedModel()

            if let urlData = data {
                success(museumData: urlData)
            }
        })
    }

    
    /**
    * Helper function to fetch data from an URL
    */
    func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        var session = NSURLSession.sharedSession()
    
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            
                println("completion error")
            } else if let httpResponse = response as? NSHTTPURLResponse {
                
                if httpResponse.statusCode != 200 {
                    println(200)
                    
                    var statusError = NSError(domain:"be.devine.bressinck", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        loadDataTask.resume()
    }
}
let _dataManager:DataManager = { DataManager() }()