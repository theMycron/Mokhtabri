//
//  RegisterForm1ViewController.swift
//  Mokhtabri
//
//  Created by Maram Eskafi on 17/12/2023.
//

import Foundation
import UIKit
import FirebaseAuth

class RegisterForm1ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
        
        // Do any additional setup after loading the view.
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
    
    //validation for email entry format
    func validateEmailFormat() {
        guard let email = email.text else {
            // Email text field is empty
            return
        }
        
        let emailRegex = "[A-Za-z0-9._%+-]+@gmail\\.com$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            showInvalidEmailAlert()
        }
    }

    func showInvalidEmailAlert() {
        let alertController = UIAlertController(title: "Invalid Email Format",
                                                message: "Please enter a valid Gmail address.",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        
        validateFields()
        validateEmailFormat()
    }
    
    
    
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
        
        
        
        //validation for cpr field
        if email.text?.isEmpty==true{
            //prompt an alert to the user
            let alert = UIAlertController(title: "Empty Field", message: "Please Enter Your email", preferredStyle: .alert)
            
            //show a dismiss button + presnt the alert
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            
            return
            
            
            
        }
        validateEmailFormat()
        //function to validate email entry format
        func validateEmailFormat() -> Bool {
            guard let email = email.text else {
                // Email text field is empty
                return false
            }
            
            let emailRegex = "[A-Za-z0-9._%+-]+@gmail\\.com$"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            
            return emailPredicate.evaluate(with: email)
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
    
    
  
    
    
    //send user information + password to firebase
    func Register(){
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
            
            //check the auth result to make sure that the user is created
            guard let user = authResult?.user, error == nil else{
                
                
                
                //if user is not created, display the error.
                print("Error \(error?.localizedDescription)")
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
    
}

