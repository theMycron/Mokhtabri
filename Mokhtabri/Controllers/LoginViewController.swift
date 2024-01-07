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

        //creating outlets for the fields
        
        @IBOutlet weak var emailTxt: UITextField!
        @IBOutlet weak var passwordTxt: UITextField!
        
        
          @IBAction func loginBtnTapped(_ sender: Any) {
              //start validating
               validateFields()
                
          }
    //show alert messsage for user
        func showInvalidEmailAlert() {
            let alertController = UIAlertController(title: "Invalid Email Format",
                                                    message: "Please enter a valid email address.",
                                                    preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
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
         
            guard let email = emailTxt.text else {
                // Email text field is empty
                return
            }
            
            //logical comparison
            let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            
            //if it is not the same format
            if !emailPredicate.evaluate(with: email) {
                showInvalidEmailAlert()
            }
           
            
            //start login process after validation
            login()
        }
        
        func login(){
            
         
            
            guard let email = emailTxt.text, let password = passwordTxt.text else {
                  return
              }

              Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                  guard let self = self else { return }

                  
                  
                  if let error = error {
                      // Show error message when authentication fails
                      self.showInvalidCredentialsAlert()
                      //Retrieve the localized description for this error.
                      print("Authentication failed: \(error.localizedDescription)")
                      return
                  }
                  
               
                  
                  // Authentication successful, proceed to check user info
                  self.checkUserInfo()
                  
                  
              }
        }
        func showInvalidCredentialsAlert() {
            let alertController = UIAlertController(title: "Invalid Credentials",
                                                    message: "The email or password you entered were invalid. Please try again.",
                                                    preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)

            present(alertController, animated: true, completion: nil)
        }
        
        override func viewDidAppear(_ animated: Bool) {
            
        }
        
        //double check that the user logged in and have information
        func checkUserInfo(){
            
            
            
            if Auth.auth().currentUser != nil {
                guard let email = Auth.auth().currentUser?.email else {
                    print("email is null")
                    return
                }
                
                let user = AppData.getUserFromEmail(email: emailTxt.text!)
                AppData.loggedInUser = user
                
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
                    //Shows the window and makes it the key window.
                    self.view.window?.makeKeyAndVisible()
                } else {
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as! UINavigationController
                    self.view.window?.rootViewController = viewController
                    self.view.window?.makeKeyAndVisible()
                }
                
            }
            
        }
        
        //Inherited from UITextFieldDelegate
        //for the return key, once presses, the cursor will move to the next field
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == emailTxt{
                passwordTxt.becomeFirstResponder()
            }else{
                validateFields()
            
            }
            return true
        }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    }
