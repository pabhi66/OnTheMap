//
//  UserInformation.swift
//  On The Map
//
//  Created by Abhishek Prajapati on 5/24/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import Foundation

class UserInformation{
    //Mark: user informations
    var createdAt: String
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var updatedAt: String
    
    //Mark: initialize user
    init(json: [String: Any]) {
        self.createdAt = json["createdAt"] as? String ?? ""
        self.firstName = json["firstName"] as? String ?? ""
        self.lastName = json["lastName"] as? String ?? ""
        self.latitude = json["latitude"] as? Double ?? 0.0
        self.longitude = json["longitude"] as? Double ?? 0.0
        self.mapString = json["mapString"] as? String ?? ""
        self.mediaURL = json["mediaURL"] as? String ?? ""
        self.objectId = json["objectId"] as? String ?? ""
        self.uniqueKey = json["uniqueKey"] as? String ?? ""
        self.updatedAt = json["updatedAt"] as? String ?? ""
    }
}
