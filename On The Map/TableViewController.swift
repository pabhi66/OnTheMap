//
//  TableViewController.swift
//  On The Map
//
//  Created by Abhishek Prajapati on 5/23/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Mark: outlet
    @IBOutlet weak var tableView: UITableView!
    
    //Mark: view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 247/255, green: 143/255, blue: 143/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        tabBarController?.tabBar.barTintColor = UIColor(red: 247/255, green: 143/255, blue: 143/255, alpha: 1.0)
        tabBarController?.tabBar.tintColor = UIColor.white
    }
    
    
    //Mark: view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                tableView.reloadData()
        tableView.contentInset = UIEdgeInsets.zero
    }
    
    //Mark: tableview size
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.sharedInstance.users.count
    }
    
    //Mark: set up tableview cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? TableViewCell{
            
            //set user's full name and website and show it in the cell
            let userFullName = DataService.sharedInstance.users[indexPath.row].firstName + " " + DataService.sharedInstance.users[indexPath.row].lastName
            cell.userName.text = userFullName
            cell.userWebsite.text = DataService.sharedInstance.users[indexPath.row].mediaURL
            return cell;
        }else{
            return TableViewCell()
        }
    }
    
    //Mark: select tableview cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //get user's url
        let url = DataService.sharedInstance.users[indexPath.row].mediaURL
        
        //check if the url is able to open
        if varifyURL(url){
            UIApplication.shared.open(NSURL(string: url)! as URL, options: [:], completionHandler: nil)
        }else{
            showError("Bad URL", "Given URL is not a valid url.")
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
    
    //Mark: Varify user's URL
    func varifyURL(_ url: String?) -> Bool{
        
        if let url = url{
            if let nsurl = NSURL(string: url){
                return UIApplication.shared.canOpenURL(nsurl as URL)
            }
        }
        return false
    }

    //Mark: logout button clicked
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
