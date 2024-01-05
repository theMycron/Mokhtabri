//
//  LoginViewController.swift
//  Mokhtabri
//
//  Created by Maryam Aleskafi on 04/12/2023.


import UIKit
import FirebaseAuth
import Foundation


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxt.delegate = self
        passwordTxt.delegate = self
        
    }
//declare user defaults
    let defaults = UserDefaults.standard
    //creating outlets for the fields
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
  
//show alert messsage for user
    func showInvalidEmailAlert() {
        let alertController = UIAlertController(title: "Invalid Email Format",
                                                message: "Please enter a valid email address.",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        //start validating
       
            validateFields()
          
        
         
    }
    
   

    
    
    
    func validateFields(){
        //validations for input fields
        if emailTxt.text?.isEmpty==true{
            //prompt an alert to the user
            let alert = UIAlertController(title: "Empty Field", message: "Please Enter Your Email", preferredStyle: .alert)
            
            //show a dismiss button + presnt the alert
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            
            return
        }
        
      
        
       
        if passwordTxt.text?.isEmpty == true{
            //prompt an alert to the user
            let alert = UIAlertController(title: "Empty Field", message: "Please Enter Your Password", preferredStyle: .alert)
            
            //show a dismiss button + presnt the alert
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            
            return
        }
        //Password length validation
        let pwd = passwordTxt.text ?? ""
        let passwordLength = pwd.count

        // Set the desired minimum password length
        let minimumPasswordLength = 8

       /* if passwordLength < minimumPasswordLength {
            // Password length is less than the desired length
            // Display an alert or show an error message to the user
            let alert = UIAlertController(title: "Invalid Password", message: "Password should be at least \(minimumPasswordLength) characters long for more security.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }*/
        guard let email = emailTxt.text else {
            // Email text field is empty
            return
        }
        
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            showInvalidEmailAlert()
        }
       
        
        //start login process after validation
        login()
    }
    
    func login(){
        
        //let texts = Helper.shared.getTextFromTextField(textFields:[emailTxt,passwordTxt])
        //let email = texts[0]
        //let password = texts[1]
        //FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {authResult, error in
          //  guard error == nil else{
               // Helper.shared.showAlert(Controller: self, title: "Invalid credentials", message : "Check your email or password")
               // return
           // }
       // })
        /*Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!) { [weak self] authResult, errorMessgae in
            
             
            guard self != nil else {return}
            
            if let errorMessgae = errorMessgae{
                print(errorMessgae.localizedDescription)
                
               
            }
            //double check the information
            self!.checkUserInfo()
        }*/
      // print(Auth.auth().currentUser!.uid)
        
        
        guard let email = emailTxt.text, let password = passwordTxt.text else {
              return
          }

          Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
              guard let self = self else { return }

              if let error = error {
                  // Show error message when authentication fails
                  self.showInvalidCredentialsAlert()
                  print("Authentication failed: \(error.localizedDescription)")
                  return
              }

              // Authentication successful, proceed to check user info
              self.checkUserInfo()
          }
    }
    
    //double check that the user logged in and have information
    func checkUserInfo(){
        
        
        
        if Auth.auth().currentUser != nil {
            guard let email = Auth.auth().currentUser?.email else {
                print("email is null")
                return
            }
            
            let viewControllerIdentifier: String
            var isTabBarController: Bool = true
            
            if email.contains("admin@gmail"){
                viewControllerIdentifier = "AdminView"
                // admin screen has no tab bar controller, so do not instantiate as tab bar controller
                isTabBarController = false
            } else if email.contains("@mokhtabri"){
                viewControllerIdentifier = "LabTabBarController"
            } else {
                viewControllerIdentifier = "PatientTabBarController"
            }
            
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if isTabBarController {
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as! UITabBarController
                self.view.window?.rootViewController = viewController
                self.view.window?.makeKeyAndVisible()
            } else {
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as! UINavigationController
                self.view.window?.rootViewController = viewController
                self.view.window?.makeKeyAndVisible()
            }
            
            
            //
            //            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            //            guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? UINavigationController else {
            //                return
            //            }
            //
            //            viewController.modalPresentationStyle = .fullScreen
            //            self.present(viewController, animated: true) {
            //                // Dismiss the previous view controller in settings
            //                self.navigationController?.viewControllers = [viewController]
            //            }
            
            
            
            
            //let storyboard = UIStoryboard(name: "PatientHome", bundle: nil)
            // guard let viewController = storyboard.instantiateViewController(withIdentifier: "PatientHome") as? PatientHomeTableViewController else {
            //return
            //}
            //viewController.modalPresentationStyle = .fullScreen
            //self.present(viewController, animated: true) {
            // Dismiss the previous view controller in settings
            //self.navigationController?.viewControllers = [viewController]
            //}
            // let userID: String = Auth.auth().currentUser!.uid
            
            
        }
        
        
        
    }
    
    func showInvalidCredentialsAlert() {
        let alertController = UIAlertController(title: "Invalid Credentials",
                                                message: "The username or password you entered were invalid. Please try again.",
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //checkUserInfo()
    }
    //if the credentials were wromg
    
   // let alert = UIAlertController(title: "Invalid Credentials", message: "The username and password you entered were invalid. Please try again.", preferredStyle: .alert)
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTxt{
            passwordTxt.becomeFirstResponder()
        }else{
            validateFields()
        
            //login()
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
