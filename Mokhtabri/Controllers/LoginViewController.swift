//
//  LoginViewController.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 04/12/2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
//declare user defaults
    let defaults = UserDefaults.standard
    //creating outlets for the fields
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBAction func loginBtnTapped(_ sender: Any) {
        //start validating
            validateFields()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    
    
    
    func validateFields(){
        //validations for input fields
        if usernameTxt.text?.isEmpty==true{
            //prompt an alert to the user
            let alert = UIAlertController(title: "Empty Field", message: "Please Enter Your Username", preferredStyle: .alert)
            
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
        
        //start login process after validation
        login()
    }
    
    func login(){
        
        //force unwrap tp avoid the crash
        Auth.auth().signIn(withEmail: usernameTxt.text!, password: passwordTxt.text!) { [weak self] authResult, errorMessgae in
            
            
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
            let vc = mainSB.instantiateViewController(withIdentifier: "tabBar")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
            let userID: String = Auth.auth().currentUser!.uid
            
            
        }else{
            //set the user as false inside user defaults
            self.defaults.set(false, forKey: "Logged In")
            
            //pass the user to the login form directly
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
    
    
    
    @IBAction func createPatientAccountTapped(_ sender: Any) {
        
        
    }
    
}
