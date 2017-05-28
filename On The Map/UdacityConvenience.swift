//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Abhishek Prajapati on 5/21/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import Foundation

extension UdacityClient{
    
    // MARK: Authentication (GET) Methods
    /**
        Authenticate student by their email and password
     **/
    
    func authenticate(_ userEmail: String, _ userPassword: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void){
        
        let _ = UdacityClient.sharedInstance().taskForPOSTMethod(userEmail, userPassword) { (result, error) in
            
            /** display error**/
            func displayError(_ error: String){
                //let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForAuth(false, error)
                return
            }
            
            /**  if error is nil send erro **/
            if error != nil {
                completionHandlerForAuth(false, "Please check your email and/or password and try again.")
            }
            
            /** check if user session and account data is present**/
            guard let result = result as? [String: Any] else{
                displayError("Unable to find user data.")
                return
            }
            
            guard let account = result["account"] as? [String: Any] else{
                displayError("Unable to find user account in \(result).")
                return
            }
            
            guard let session = result["session"] as? [String: Any] else{
                displayError("Unable to find user session in \(result).")
                return
            }
            
            guard let key = account["key"] as? String else{
                displayError("Unable to find user's account key.")
                return
            }
            
            guard let registered = account["registered"] as? Bool else{
                displayError("Unable to Varify user.")
                return
            }
            
            guard let expiration = session["expiration"] as? String else{
                displayError("Unable to find user's session expiration key.")
                return
            }
            
            guard let id = session["id"] as? String else{
                displayError("Unable to find user's session id.")
                return
            }
            
            //print(account)

            self.getUserInformation(key, registered, expiration, id, completionHandlerForUserInfo: completionHandlerForAuth)
        }
    }
    
    //Mark: get user information (name, location, map url, etc.)
    func getUserInformation(_ accountKey: String, _ accountRegistered: Bool, _ sessionExpiration: String, _ sessionId: String, completionHandlerForUserInfo: @escaping (_ success: Bool, _ errorString: String?)-> Void){
        
        let _ = UdacityClient.sharedInstance().taskForGETMethod(accountKey) { (result, error) in
            
            /** display error**/
            func displayError(_ error: String){
                //let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForUserInfo(false, error)
                return
            }
            
            /**  if error is nil send erro **/
            if error != nil {
                completionHandlerForUserInfo(false, "error occured while trying to get user information. Please try again.")
                return;
            }
            
            guard let result = result as? [String: Any] else{
                displayError("Unable to get user's information.")
                return
            }
            
            guard let user = result["user"] as? [String:Any] else{
                displayError("Unable to find user.")
                return
            }
            
            guard let firstName = user["first_name"] as? String else{
                displayError("Unable to find user's first name.")
                return
            }
            
            guard let lastName = user["last_name"] as? String else{
                displayError("Unable to find user's last name.")
                return
            }
            
            DataService.sharedInstance.firstName = firstName
            DataService.sharedInstance.lastName = lastName
            DataService.sharedInstance.userID = accountKey
            
            completionHandlerForUserInfo(true, nil)
        }
    }
    
}
