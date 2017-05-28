//
//  PostNewLocationViewController.swift
//  On The Map
//
//  Created by Abhishek Prajapati on 5/25/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MapKit

class PostNewLocationViewController: UIViewController {

    @IBOutlet weak var locationText: SkyFloatingLabelTextField!
    var searchResponse = MKLocalSearchResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = UIColor(red: 247/255, green: 143/255, blue: 143/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //check if the uesr have already posted
        ParseClient.sharedInstance().checkUserPost { (success, error) in
            if success{
                performUIUpdatesOnMain{
                    let alert = UIAlertController(title: "Override location",
                                                  message: "You have already posted. Do you want to override your location?",
                                                  preferredStyle: .alert)
                    
                    // post button
                    let postAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                        alert.dismiss(animated: true, completion: nil)
                    })
                    
                    // Cancel button
                    let cancel = UIAlertAction(title: "No", style: .destructive, handler: { (action) -> Void in
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    alert.addAction(postAction)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    //Mark: cancel clicked
    @IBAction func cancelPost(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    //Mark: find on map clicked
    @IBAction func postNewLocation(_ sender: Any) {
        
        self.post()
    }
    
    func post(){
        //check if text is not empty
        guard let location = self.locationText.text, location != "" else{
            self.showError("invalid location", "Please enter correct location and try again.")
            return;
        }
        
        //get location
        self.getLocation(location){ (success, error, response) in
            if success{
                performUIUpdatesOnMain{
                    self.searchResponse = response!
                    self.performSegue(withIdentifier: "findLocation", sender: self)
                }
                
            }else{
                performUIUpdatesOnMain{
                    self.showError("Error", error)
                }
            }
        }
    }
    
    //Mark: get geo location from given city and state
    func getLocation(_ location: String, complitionHandlerForGetLocation: @escaping (_ success: Bool, _ error: String?, _ result: MKLocalSearchResponse?) -> Void){
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = location
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            
            guard (error == nil) else{
                complitionHandlerForGetLocation(false, "Please enter valid location and try again.", nil)
                return;
            }
            
            guard let response = response else{
                complitionHandlerForGetLocation(false, "No such location found!", nil)
                return;
            }
            
            if response.mapItems.count == 0{
                complitionHandlerForGetLocation(false, "No such location found!", nil)
                return;
            }
            
            complitionHandlerForGetLocation(true,nil, response)
            
        })
    }
    
    //Mark: Show Error Alert
    func showError(_ title: String?, _ message: String?){
        
        //create alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        //default action for alert
        let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        
        //add the default action to alertcontroller
        alertController.addAction(defaultAction)
        
        //present alert
        present(alertController, animated: true, completion: nil)
    }
    
    //Mark: prepare to segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocation"{
            let vc = segue.destination as! LocationFinderViewController
            vc.searchResponse = self.searchResponse
            vc.locationText = self.locationText.text
        }
    }
    
}
