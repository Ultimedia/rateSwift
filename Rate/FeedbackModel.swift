//
//  RoomSocialModel.swift
//  Rate
//
//  Created by Maarten Bressinck on 26/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import Foundation

class FeedbackModel: NSObject, Printable {
    let feedback_score:String
    let feedback_text:String
    let exhibit_id:String
    let user_id:String
    
    init(feedback_score: String?, feedback_text: String?, exhibit_id: String?, user_id: String?) {
        self.feedback_score = feedback_score ?? ""
        self.feedback_text = feedback_text ?? ""
        self.exhibit_id = exhibit_id ?? ""
        self.user_id = user_id ?? ""
    }
}