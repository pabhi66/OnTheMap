//
//  LocationFinderViewController.swift
//  On The Map
//
//  Created by Abhishek Prajapati on 5/25/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit
import MapKit
import SkyFloatingLabelTextField

class LocationFinderViewController: UIViewController, MKMapViewDelegate {
    
    //Variables and outlets
    var searchResponse = MKLocalSearchResponse()
    var locationText: String?
    var lat: Double = 0.0
    var long: Double = 0.0
    @IBOutlet weak var linkText: SkyFloatingLabelTextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    //Mark: view did load
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.showsUserLocation = true;
        mapView.delegate = self;
        mapView.setCenter(self.mapView.region.center, animated: true)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 247/255, green: 143/255, blue: 143/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    //Mark: view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.locationLabel.text = self.locationText
        let annotation = MKPointAnnotation()
        annotation.title = DataService.sharedInstance.firstName + " " + DataService.sharedInstance.lastName
        annotation.subtitle = locationText
        let latitude = searchResponse.boundingRegion.center.latitude
        let longitude = searchResponse.boundingRegion.center.longitude
        self.lat = latitude
        self.long = longitude
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.coordinate = coordinate

        self.mapView.addAnnotation(annotation)
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 50000, 50000)
        self.mapView.setRegion(region, animated: true)

    }

    //Mark: Cancel button is clicked
    @IBAction func cancleButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Mark: done button is clicked
    @IBAction func postNewLocation(_ sender: Any) {
        ParseClient.sharedInstance().postUserLocation(DataService.sharedInstance.userID, DataService.sharedInstance.firstName, lastName: DataService.sharedInstance.lastName, locationText!, linkText.text!, lat, long) { (success, error) in
            
            if success{
                performUIUpdatesOnMain{
                    self.dismiss(animated: true, completion: nil)
                }
            }else{
                performUIUpdatesOnMain{
                    self.showError("Error", error)
                }
            }
        }
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
}
