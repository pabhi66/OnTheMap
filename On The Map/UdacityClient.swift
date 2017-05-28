//
//  UdacityClient.swift
//  On The Map
//
//  Created by Abhishek Prajapati on 5/21/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import Foundation

class UdacityClient: NSObject{
    // MARK: Properties
    
    //Mark: shared session
    var session = URLSession.shared

    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    //Mark: task for post method
    /**
     Sends a request for information to udacity.
     - Parameter userEmail: User's Email Address
     - Parameter userPassword: User's Password
     - Parameter completionHandlerForPOST: Specify what to do once the data comes back.
     - Returns: NSURLSessionDataTask of the task that was ran.
     */
    func taskForPOSTMethod(_ userEmail: String, _ userPassword: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void ) -> URLSessionDataTask {
        
        //build url and confgure request
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(userEmail)\", \"password\": \"\(userPassword)\"}}".data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return;
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
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            
            var parsedResult: [String:AnyObject]! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                sendError("Could not parse the data as JSON: '\(data)'")
                completionHandlerForPOST(nil, NSError(domain: "getUserInfo", code: 1, userInfo: userInfo))
                return
            }
            
            completionHandlerForPOST(parsedResult as AnyObject, nil)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    //Mark: task for get method
    /**
     Sends a request for information to udacity.
     - Parameter accountKey: User's account key
     - Parameter completionHandlerForGET: Specify what to do once the data comes back.
     - Returns: NSURLSessionDataTask of the task that was ran.
     */
    func taskForGETMethod(_ accountKey: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void ) -> URLSessionDataTask{
        
        /** Build url and configure the request **/
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(accountKey)")!)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest ) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            
            var parsedResult: [String:AnyObject]! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                sendError("Could not parse the data as JSON: '\(data)'")
                completionHandlerForGET(nil, NSError(domain: "getUserInfo", code: 1, userInfo: userInfo))
                return
            }
            
            completionHandlerForGET(parsedResult as AnyObject, nil)
        }
        task.resume()
        return task
    }
    
    //Mark: task for delete method
    /**
     Sends a request for information to udacity.
     - Parameter completionHandlerForDELETE: Specify what to do once the data comes back.
     - Returns: NSURLSessionDataTask of the task that was ran.
     */
    func taskForDELETEMethod(_ completionHandlerForDelete: @escaping (_ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask (with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            guard let data = data else {
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata (in: range) /* subset respo nse data! */
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            /*var parsedResult: [String:AnyObject]! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                completionHandlerForDelete(NSError(domain: "logout", code: 1, userInfo: userInfo))
                return
            }*/
            
            completionHandlerForDelete(nil)
        }
        task.resume()
        
        return task
    }
}
