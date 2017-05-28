//
//  ParceClient.swift
//  On The Map
//
//  Created by Abhishek Prajapati on 5/24/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import Foundation

class ParseClient{
    
    // shared session
    var session = URLSession.shared
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: GET
    func taskForGETMethod(_ completionHandlerForGET: @escaping (_ result: AnyObject?, _ errorString: String?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /** Build url and configure the request **/
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /*Make the request */
        let task = session.dataTask(with: request as URLRequest){ (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, error, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            let parsedResult = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            guard (parsedResult?["results"] as? [[String: Any]]) != nil else{
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                completionHandlerForGET(nil, "Could not pasrse the data as JSON", NSError(domain: "getUserInfo", code: 1, userInfo: userInfo))
                return;
            }
            
            //print(jsonObjectList)
            
         completionHandlerForGET(parsedResult as AnyObject, nil, nil)
            
        }
        task.resume();
        return task;
    }
    
    
    // MARK: Post
    func taskForPOSTMethod(_ userID: String, _ firstName: String, lastName: String, _ location: String, _ url: String, _ lat: Double, _ long: Double, _ completionHandlerForPOST: @escaping (_ result: AnyObject?, _ errorString: String?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: String = "{\"uniqueKey\": \"\(userID)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(url)\",\"latitude\": \(lat), \"longitude\": \(long)}"
        
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest){ (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, error, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            completionHandlerForPOST(data as AnyObject, nil, nil)
        }
        
        task.resume()
        return task;
    }
    
    
}
