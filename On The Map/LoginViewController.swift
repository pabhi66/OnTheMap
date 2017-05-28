//
//  ViewController.swift
//  On The Map
//
//  Created by Abhishek Prajapati on 5/21/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //Mark: login outlets
    @IBOutlet weak var userEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var userPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Mark: login view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        userEmail.delegate = self;
        userPassword.delegate = self;
        
    }
    
    //Mark: login view appears
    //when view appears suscribe to keyboard
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToKeyboardNotifications()
        
        activityIndicator.isHidden = true;
        self.setupTextField(userEmail, "Email", "Email")
        self.setupTextField(userPassword, "Password", "Password")
    }
    
    //Mark: login view will disappear
    //when view disappers unsubscribe to keyboard
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    //Mark: login button clicked
    //when login button is clicked carefully login
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        activityIndicator.isHidden = false;
        activityIndicator.startAnimating();
        
        //if internet is available then login
        if isInternetAvailable != .notReachable{
            
            //if credentials are valid then attemp to login
            if isValidcredentials(){
                UdacityClient.sharedInstance().authenticate(userEmail.text!, userPassword.text!) { (success, error) in
                    performUIUpdatesOnMain{
                        if success{
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true;
                            self.getUserInformation()
                        }else{
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true;
                            self.displayError(error)
                        }
                    }
                }
            }else{
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true;
                displayError("Please check your email and/or password and try again.")
                userPassword.text = ""
            }
        }else{ //show internet error
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true;
            displayError("Please check your internet connection and try again.")
        }
    }
    
    //Mark: get user information
    private func getUserInformation(){
        ParseClient.sharedInstance().getUsersLocation { (success, error) in
            performUIUpdatesOnMain {
                if success{
                    self.completeLogin()
                }else{
                    self.displayError(error)
                }
            }
        }
    }
    
    // MARK: complete Login
    private func completeLogin() {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "mainView") as! UITabBarController
        self.present(controller, animated: true, completion: nil)
    }
    
    //Mark: display errors
    //display alerts
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            //create alert controller
            let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
            
            //default action for alert
            let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            
            //add the default action to alertcontroller
            alertController.addAction(defaultAction)
            
            //present alert
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //Mark: sign up button clicked
    //when sign up button is clicked open udacity's sign up page
    @IBAction func signUpButtonClicked(_ sender: Any){
        UIApplication.shared.open(NSURL(string:"https://auth.udacity.com/sign-up")! as URL, options: [:], completionHandler: nil)
    }
    
    //Mark: facebook button clicked
    //when facebook button is clicked sign in with facebook
    @IBAction func FacebookLoginClicked(_ sender: Any){
        FacebookClient.sharedInstance().facebookLogin(self) { (result, error, errorString) in
            guard (error == nil) else {
                performUIUpdatesOnMain {
                    self.displayError(errorString)
                }
                return;
            }
            
            guard result != nil else{
                performUIUpdatesOnMain {
                    self.displayError(errorString)
                }
                return;
            }
            
            self.FBLogin()
        }
    }
    
    //Mark: login with facebook
    func FBLogin(){
        performUIUpdatesOnMain {
            self.activityIndicator.isHidden = false;
            self.activityIndicator.startAnimating();
        }
        
        FacebookClient.sharedInstance().getFBToken { (result, error, errorString) in
            if error != nil {
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true;
                    self.displayError(errorString)
                }
            }else{
                
            }
        }
    }
}



//Mark: login extension (keyboard notifications, credentials checker, set up textfields)
extension LoginViewController{
    func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)/2
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillDisappear(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    //check for valid credentials
    func isValidcredentials() -> Bool{
        if userEmail == nil || userPassword == nil{
            return false;
        }
        
        if userEmail.text == nil || userEmail?.text == "" || userPassword.text == nil || userPassword?.text == "" || (userPassword.text?.characters.count)! <= 5{
            return false;
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailCheck.evaluate(with: userEmail.text!)
    }
    
    //set up user interface
    func setupTextField(_ textField: SkyFloatingLabelTextField, _ title: String, _ placeholder: String){
        //text color
        let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
        let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
        let overcastBlueColor = UIColor(red: 247/255, green: 143/255, blue: 143/255, alpha: 1.0)
        
        textField.placeholder = placeholder
        textField.title = title
        
        textField.tintColor = overcastBlueColor // the color of the blinking cursor
        textField.textColor = darkGreyColor
        textField.lineColor = lightGreyColor
        textField.selectedTitleColor = overcastBlueColor
        textField.selectedLineColor = overcastBlueColor
        
        textField.lineHeight = 1.0 // bottom line height in points
        textField.selectedLineHeight = 2.0
    }
}

