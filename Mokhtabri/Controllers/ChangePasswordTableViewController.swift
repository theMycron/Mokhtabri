//
//  ChangePasswordTableViewController.swift
//  Mokhtabri
//
//  Created by Fatima ahmed on 17/12/2023.
//

import UIKit
import FirebaseAuth

class ChangePasswordTableViewController: UITableViewController {
    
    //variables
    var loggedInUser: User? = AppData.loggedInUser
    var patientLog: Patient?
    
    // declaring elements
    @IBOutlet weak var oldPassField: UITextField!
    @IBOutlet weak var newPassField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    
    var oldPass = " "
    var newPass = " "
    var conPass = " "
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FindPatient()
    }
    
    
    func FindPatient() {
        guard let loggedInUser = loggedInUser else {
            return
        }
        patientLog = AppData.patients.first{$0.username == loggedInUser.username}
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    // for the navigation bar to appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func ChangeBtn(_ sender: Any) {
        var check = false;
        check = checkPass()
        
        confirmation(title: "Change Password", message: "Are you sure you want to change your password?") {
            if check{
                Auth.auth().currentUser?.updatePassword(to: self.newPass) { error in
                    if let error = error {
                        // Handle the error (e.g., show an error alert)
                        self.errorAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        // Handle the successful password update
                        self.errorAlert(title: "Success", message: "Password Changed Successfully.")
                    }
                }
            }
            
        }
        
        
        // handles errors in changing password.
        func checkPass() -> Bool{
            // take values from text fields
            oldPass = oldPassField.text ?? ""
            newPass = newPassField.text ?? ""
            conPass = confirmPassField.text ?? ""
            
            // check if empty
            if oldPass.isEmpty || newPass.isEmpty || conPass.isEmpty {
                errorAlert(title: "Error", message: "Please enter data in all the fields. Don't leave any fields empty.")
                return false
            } else {
                // password matches?
                if patientLog?.password == oldPass {
                    // new passwords match?
                    if newPass == conPass {
                        // new pass = old pass?
                        if oldPass == newPass {
                            errorAlert(title: "Error", message: "New password entered is the same as your old password. Please Try Again")
                            return false
                        } else {
                            // universal guidelines
                            if newPass.count < 8 {
                                errorAlert(title: "Error", message: "Make sure your password is atleast 8 characters long.")
                                return false
                            }
                        }
                    } else {
                        errorAlert(title: "Error", message: "The password new passwords don't match. Please Try again.")
                        return false
                    }
                } else {
                    errorAlert(title: "Error", message: "The password you entered doesn't match the current password. Please Try again.")
                    return false
                }
            }
            
            return true
        }
    }
}
