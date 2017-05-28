//
//  ParceConveience.swift
//  On The Map
//
//  Created by Abhishek Prajapati on 5/24/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import Foundation

extension ParseClient{
    
    //Mark: get user location and all its information
    func getUsersLocation(_ completionHandlerForGETLocations: @escaping (_ success: Bool, _ errorString: String?)->Void){
        
        /* Make the request */
        let _ = ParseClient.sharedInstance().taskForGETMethod { (result, errorString, error) in
            
            //check for error
            guard (error == nil) else{
                completionHandlerForGETLocations(false, errorString)
                return;
            }
            
            //check if result is correct
            guard let results = result?["results"] as? [[String: Any]] else{
                completionHandlerForGETLocations(false, "Unable to parse student locations")
                return;
            }
            
            //DataService.sharedInstance.userLocations.removeAll()
            //store all users' information
            for jsonObject in results{
                let user: UserInformation = UserInformation(json: jsonObject as [String : Any])
                if user.firstName != ""{
                    DataService.sharedInstance.users = [user];
                }
            }
            completionHandlerForGETLocations(true,nil);
        }
    }
    
    //Mark: check if the user have alreay posted
    func checkUserPost(_ completionHandlerForGETLocations: @escaping (_ success: Bool, _ errorString: String?)->Void){
        
        /* Make the request */
        let _ = ParseClient.sharedInstance().taskForGETMethod { (result, errorString, error) in
            
            //check for error
            guard (error == nil) else{
                completionHandlerForGETLocations(false, errorString)
                return;
            }
            
            //check if result is correct
            guard let results = result?["results"] as? [[String: Any]] else{
                completionHandlerForGETLocations(false, "Unable to parse student locations")
                return;
            }
            
            guard (results[0]["objectId"] as? String) != nil else{
                completionHandlerForGETLocations(false, "NO user object found")
                return;
            }
            completionHandlerForGETLocations(true,nil);
        }
    }
    
    //Mark: post user location
    func postUserLocation(_ userID: String, _ firstName: String, lastName: String, _ location: String, _ url: String, _ lat: Double, _ long: Double, _ completionHandlerForPOSTLocations: @escaping (_ success: Bool, _ errorString: String?)->Void ){
        
        /* Make the request */
        let _ = ParseClient.sharedInstance().taskForPOSTMethod(userID, firstName, lastName: lastName, location, url, lat, long) { (result, errorString, error) in
            
            //check for error
            guard (error == nil) else{
                completionHandlerForPOSTLocations(false, errorString)
                return;
            }
            
            //check if result is not nil
            guard result != nil else{
                completionHandlerForPOSTLocations(false, errorString)
                return
            }
            
            //success
            for x in DataService.sharedInstance.users{
                if userID == x.uniqueKey{
                    x.latitude = lat
                    x.longitude = long
                    x.mapString = location
                    x.mediaURL = url
                }
            }
            completionHandlerForPOSTLocations(true,nil);
            
        }
    }
}
