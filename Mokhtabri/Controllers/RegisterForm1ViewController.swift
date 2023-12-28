//
//  RegisterForm1ViewController.swift
//  Mokhtabri
//
//  Created by Maryam Eskafi on 17/12/2023.
//

import Foundation
import UIKit
import FirebaseAuth

class RegisterForm1ViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        firstname.delegate = self
        lastname.delegate = self
        cpr.delegate = self
        email.delegate = self
        password.delegate = self
        
    
      
    }
    
    
    @IBOutlet weak var firstname: UITextField!
    
    @IBOutlet weak var lastname: UITextField!
    
    
    @IBOutlet weak var cpr: UITextField!
    
    
    @IBOutlet weak var email: UITextField!
    
    
    
    @IBOutlet weak var password: UITextField!
    
    
    
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //declare user defaults
    let defaults = UserDefaults.standard
    
    
    
  

    func showInvalidEmailAlert() {
        let alertController = UIAlertController(title: "Invalid Email Format",
                                                message: "Please enter a valid email address.",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func registerBtnTapped(_ sender: Any) {
        
        validateFields()
        //validateEmailAndCheckRegistration()
        backToLogin()
    
           
      
       
    }
//    func validateEmailAndCheckRegistration() {
//        guard let emailText = email.text, !emailText.isEmpty else {
//            // Handle empty email field
//            return
//        }
//
//        // Validate email format
//        if !isValidEmail(emailText) {
//            // Handle invalid email format
//            return
//        }
//
//        // Check if email is already registered
//        Auth.auth().fetchSignInMethods(forEmail: emailText) { (signInMethods, error) in
//            if let error = error {
//                // Handle error in fetching sign-in methods
//                print("Error fetching sign-in methods:", error.localizedDescription)
//                
//                if error.localizedDescription.contains("There is no user record corresponding to this identifier.") {
//                    // Proceed with registration process
//                    // ...
//                    // Register the user with Firebase Authentication
//                } else {
//                    // Handle other error cases
//                    print("Error:", error.localizedDescription)
//                }
//            } else {
//                // Email is already registered
//                // Display alert indicating email is already in use
//                let alertController = UIAlertController(title: "Email Already Registered",
//                                                        message: "The email address is already registered.",
//                                                        preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default)
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: nil)
//            }
//        }
//    }
//
//    // Email format validation
//    func isValidEmail(_ email: String) -> Bool {
//        // Implement your email format validation logic
//        // Return true if the email is valid, false otherwise
//        // Example implementation:
//        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//        return emailPredicate.evaluate(with: email)
//    }

    
    
    
    
    func validateFields(){
        //validation for firstname empty field
        if firstname.text?.isEmpty==true{
            //prompt an alert to the user
            let alert = UIAlertController(title: "Empty Field", message: "Please Enter Your First Name", preferredStyle: .alert)
            
            //show a dismiss button + presnt the alert
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            
            return
            
        }
        
        
        
        //validation for lastname field
        if lastname.text?.isEmpty==true{
            
            //prompt an alert to the user
            let alert = UIAlertController(title: "Empty Field", message: "Please Enter Your Last Name", preferredStyle: .alert)
            
            //show a dismiss button + presnt the alert
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            
            
            return
        }
        
        //validation for cpr field
        if cpr.text?.isEmpty==true{
            //prompt an alert to the user
            let alert = UIAlertController(title: "Empty Field", message: "Please Enter Your CPR", preferredStyle: .alert)
            
            //show a dismiss button + presnt the alert
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            
            return
            
        }
        guard let cpr = cpr.text else {
            // CPR text field is empty
            return
        }
        
        let cprRegex = "^[0-9]{9}$"
        let cprPredicate = NSPredicate(format: "SELF MATCHES %@", cprRegex)
        
        if !cprPredicate.evaluate(with: cpr) {
            showInvalidCPRAlert()
        }
        
        
        //validation for cpr field
        if email.text?.isEmpty==true{
            //prompt an alert to the user
            let alert = UIAlertController(title: "Empty Field", message: "Please Enter Your email", preferredStyle: .alert)
            
            //show a dismiss button + presnt the alert
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            
            return
            
            
            
            
        }
        guard let email = email.text else {
            // Email text field is empty
            return
        }
        
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            showInvalidEmailAlert()
        }
        
       
      
        
        
        //validation for password field
        if password.text?.isEmpty == true{
            
            //prompt an alert to the user
            let alert = UIAlertController(title: "Empty Field", message: "Please Enter Your Password", preferredStyle: .alert)
            
            //show a dismiss button + presnt the alert
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            
            return
        }
        let pwd = password.text ?? ""
        let passwordLength = pwd.count

        // Set the desired minimum password length
        let minimumPasswordLength = 8

        if passwordLength < minimumPasswordLength {
            // Password length is less than the desired length
            // Display an alert or show an error message to the user
            let alert = UIAlertController(title: "Weak Password", message: "Password should be at least \(minimumPasswordLength) characters long for more security.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
       
        
        
        //call the Register function if the fields are validated
        Register()
        
    }
    
    
  
    func showInvalidCPRAlert() {
        let alertController = UIAlertController(title: "Invalid CPR Format",
                                                message: "Please enter a valid CPR number consisting of 9 digits.",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    //send user information + password to firebase
   func Register(){
        
      
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
            
            //check the auth result to make sure that the user is created
            guard let user = authResult?.user, error == nil else{
                
                
                
                //if user is not created, display the error.
                print("Error \(String(describing: error?.localizedDescription))")
                //set the user as false inside user defaults
                self.defaults.set(false, forKey: "Logged In")
               
                
                return

            }
            
            //set the user as logged in inside user defaults
            self.defaults.set(true, forKey: "Logged In")
            
            //redirect 
            let mainSB = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainSB.instantiateViewController(withIdentifier: "PatientRegistration")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        
        }
        
        
        //save the info in the user defaults
        defaults.set(firstname.text, forKey: "First Name" )
        defaults.set(lastname.text, forKey: "Last Name")
        defaults.set(cpr.text, forKey: "CPR")
        defaults.set(email.text, forKey: "Username")
        defaults.set(password.text, forKey: "User Password")
        //save the gender and dob
        let selectedDate = datePicker.date

        let defaults = UserDefaults.standard
        defaults.set(selectedDate, forKey: "Selected Date")
        
        let selectedSegmentIndex = genderSegmentedControl.selectedSegmentIndex

        var selectedGender: String?
        if selectedSegmentIndex == 0 {
            selectedGender = "Male"
        } else if selectedSegmentIndex == 1 {
            selectedGender = "Female"
        }

        let def = UserDefaults.standard
        defaults.set(selectedGender, forKey: "Selected Gender")
        
    }
    
    
    func backToLogin(){
        let alertController = UIAlertController(title: "Successfully Registered!",
                                                message: "Please proceed to the login page to complete the signing-in process.",
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "login")
            self?.view.window?.rootViewController = viewController
            self?.view.window?.makeKeyAndVisible()
        }

        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstname{
            lastname.becomeFirstResponder()
        }else if textField == lastname{
            cpr.becomeFirstResponder()
        }else   if textField == cpr{
            email.becomeFirstResponder()
        }else if textField == email{
            password.becomeFirstResponder()
        }
        
        else{
            validateFields()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

