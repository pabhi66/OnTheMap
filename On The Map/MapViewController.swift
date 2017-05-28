//
//  MapViewController.swift
//  On The Map
//
//  Created by Abhishek Prajapati on 5/21/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    //Mark: mapview controller outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //Mark: View did load
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.showsUserLocation = true;
        mapView.delegate = self;
        mapView.setCenter(self.mapView.region.center, animated: true)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 247/255, green: 143/255, blue: 143/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        tabBarController?.tabBar.barTintColor = UIColor(red: 247/255, green: 143/255, blue: 143/255, alpha: 1.0)
        tabBarController?.tabBar.tintColor = UIColor.white
        //navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
    }
    
    //Mark: View did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpUserPins();
    }
    
    //Mark: Set up user's location on the map
    func setUpUserPins(){
        
        //get user's information
        let users = DataService.sharedInstance.users
        
        //remove all annotations if there are any
        
        for user in users{
            
            //get user's atitude and longitude and find coordinate
            let lat = CLLocationDegrees(user.latitude)
            let long = CLLocationDegrees(user.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            //create a map annotation and insert user's name, map url, and coordinates
            let annotaion = MKPointAnnotation()
            annotaion.coordinate = coordinate
            let userName = user.firstName + " " + user.lastName
            annotaion.title = userName
            annotaion.subtitle = user.mediaURL
            self.mapView.addAnnotation(annotaion)
        }
    }
    
    //Mark: set up pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor(red: 247/255, green: 143/255, blue: 143/255, alpha: 1.0)
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    //Mark: open annotation link
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let url  = view.annotation?.subtitle
        
        //check if the url is able to open
        if varifyURL(url!){
            UIApplication.shared.open(NSURL(string: url!!)! as URL, options: [:], completionHandler: nil)
        }else{
            showError("Bad URL", "Given URL is not a valid url.")
        }
    }
    
    //Mark: Varify user's URL
    func varifyURL(_ url: String?) -> Bool{
        
        if let url = url{
            if let nsurl = NSURL(string: url){
                return UIApplication.shared.canOpenURL(nsurl as URL)
            }
        }
        return false
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

    @IBAction func logoutButtonClicked(_ sender: Any) {
        let _ = UdacityClient.sharedInstance().taskForDELETEMethod { (error) in
            performUIUpdatesOnMain {
                if error == nil {
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "login")
                    self.present(controller, animated: true, completion: nil)
                    
                } else {
                    self.showError("Unable to logout", error?.domain)
                }
            }
        }
    }

}
