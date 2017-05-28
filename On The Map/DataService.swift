//
//  DataService.swift
//  On The Map
//
//  Created by Abhishek Prajapati on 5/21/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import Foundation

class DataService{
    //Mark: shared instance of dataservice
    static let sharedInstance = DataService()
    
    //Mark: fileprivate user variables
    fileprivate var _firstName: String? = nil
    fileprivate var _lastName: String? = nil
    fileprivate var _userID: String? = nil
    fileprivate var _users = [UserInformation]()
    
    //Mark: getters and setters

    var users: [UserInformation] {
        get {
            return _users
        }
        set {
            _users.append(newValue[0])
        }
    }
    
    //get and set user's id
    var userID: String{
        get{
            return _userID!
        }set{
            _userID = newValue
        }
    }
    
    //get and set user firstname
    var firstName: String{
        get{
            return _firstName!
        }set{
            _firstName = newValue
        }
    }
    
    //get and set user last name
    var lastName: String{
        get{
            return _lastName!
        }set{
            _lastName = newValue
        }
    }
    
}
