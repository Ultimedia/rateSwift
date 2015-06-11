//
//  MuseumModel.swift
//  Rate
//
//  Created by Maarten Bressinck on 25/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import Foundation

class UserModel: NSObject, Printable {
    let user_id:String
    let user_name:String
    let user_image:String
    let user_twitterhandle:String
    let user_facebookid:String
    let user_active:String
    
    init(user_id: String?, user_name: String?, user_image: String?, user_twitterhandle: String?, user_facebookid: String?, user_active: String?) {
        self.user_id = user_id ?? ""
        self.user_name = user_name ?? ""
        self.user_image = user_image ?? ""
        self.user_twitterhandle = user_twitterhandle ?? ""
        self.user_facebookid = user_facebookid ?? ""
        self.user_active = user_active ?? ""
    }
}