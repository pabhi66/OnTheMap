//
//  FacebookClient.swift
//  On The Map
//
//  Created by Abhishek Prajapati on 5/23/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin
import FBSDKCoreKit

class FacebookClient{
    
    // MARK: Shared Instance
    class func sharedInstance() -> FacebookClient {
        struct Singleton {
            static var sharedInstance = FacebookClient()
        }
        return Singleton.sharedInstance
    }
    
    //Mark: facebook login
    func facebookLogin(_ controller: UIViewController, completionHandlerForFBLogin: @escaping (_ result:[String:Any]?, _ error: Error?, _ errorMessage: String?) -> Void){
        let loginManager = LoginManager()
    
        loginManager.logIn([.publicProfile, .email, .userFriends], viewController: controller){ (result) in
            
            switch result {
                case .cancelled:
                    let userInfo = [NSLocalizedDescriptionKey : "User pressed cancelled"]
                    completionHandlerForFBLogin(nil, NSError(domain: "facebookLogin", code: 1, userInfo: userInfo), "User cancelled facebook login")
                
            case .failed(let error):
                completionHandlerForFBLogin(nil, error, "Failed to login with facebook")
                
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                self.getUserInfo(completionHandlerForFBGET: completionHandlerForFBLogin)
            }
        }
    }
    
    //Mark: get user's information
    func getUserInfo(completionHandlerForFBGET: @escaping (_ result:[String:Any]?, _ error: Error?, _ errorString: String?) -> Void){
        let params = ["fields":"email,name, first_name,last_name,picture.width(1000).height(1000),birthday,gender"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        graphRequest.start {
            (urlResponse, requestResult) in
            switch requestResult {
            case .failed(let error):
                completionHandlerForFBGET(nil, error, "Unable to get user's information")
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    completionHandlerForFBGET(responseDictionary, nil, nil)
                }
            }
        }
    }
    
    //Mark: get user facebook token
    func getFBToken(completionHandlerForToken: @escaping (_ token:String?, _ error: Error?, _ errorString: String?) -> Void){
        if let tokens = FBSDKAccessToken.current(){
            completionHandlerForToken(tokens.tokenString, nil, nil)
        }else{
            let userInfo = [NSLocalizedDescriptionKey : "User is not logged in: "]
            completionHandlerForToken(nil,NSError(domain: "get fbtoken", code: 1, userInfo: userInfo), "User is not logged in")
        }
    }
}
