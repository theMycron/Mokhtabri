//
//  LoginViewController.swift
//  Mokhtabri
//
//  Created by Maryam Aleskafi on 04/12/2023.


import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
//declare user defaults
    let defaults = UserDefaults.standard
    //creating outlets for the fields
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    func validateEmailFormat() {
        guard let email = emailTxt.text else {
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
    
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        //start validating
       
            validateFields()
            validateEmailFormat()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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

        if passwordLength < minimumPasswordLength {
            // Password length is less than the desired length
            // Display an alert or show an error message to the user
            let alert = UIAlertController(title: "Weak Password", message: "Password should be at least \(minimumPasswordLength) characters long for more security.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
        
        
        //start login process after validation
        login()
    }
    
    func login(){
        
        //force unwrap tp avoid the crash
        Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!) { [weak self] authResult, errorMessgae in
            
            
            guard let strongSelf = self else {return}
            
            if let errorMessgae = errorMessgae{
                print(errorMessgae.localizedDescription)
                
               
            }
            //double check the information
            self!.checkUserInfo()
        }
        
    }
    //double check that the user logged in and have information
    func checkUserInfo(){
        if Auth.auth().currentUser != nil {
            //print the id to ensure
            print(Auth.auth().currentUser?.uid)
            //print(Auth.auth().currentUser?.displayName)
            
            //set the value inside the user defaults
            self.defaults.set(true, forKey: "Logged In")
            
            //pass the user the overview
            let mainSB = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainSB.instantiateViewController(withIdentifier: "PatientRegistration")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
            let userID: String = Auth.auth().currentUser!.uid
            
            
        }else{
            //set the user as false inside user defaults
            self.defaults.set(false, forKey: "Logged In")
            
            //redirect user
            let login = UIStoryboard(name: "Main", bundle: nil)
            let loginVc = login.instantiateViewController(withIdentifier: "login")
            loginVc.modalPresentationStyle = .overFullScreen
            self.present(loginVc, animated: true)
           

        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //checkUserInfo()
    }
    //if the credentials were wromg
    
   // let alert = UIAlertController(title: "Invalid Credentials", message: "The username and password you entered were invalid. Please try again.", preferredStyle: .alert)
    
    
    
  
    
}
