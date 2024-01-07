//
//  PatientUpdateProfileTableViewController.swift
//  Mokhtabri
//
//  Created by Fatima ahmed on 16/12/2023.
//

import UIKit
import FirebaseAuth

class PatientUpdateProfileTableViewController: UITableViewController {
    // variables
    var loggedInUser: User? = AppData.loggedInUser
    var patientLog: Patient?
    var check = false;
    
    //declaring elements
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameFIeld: UITextField!
    

    // declare var
    var p = AppData.patient1
    var userName = ""
    var fn = ""
    var ln = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // find the patient
        FindPatient()
        // update the data
        update()
    }
    
    func FindPatient() {
        guard let loggedInUser = loggedInUser else {
            return
        }
        patientLog = AppData.patients.first{$0.username == loggedInUser.username}
    }
    
    func update() {
        usernameField.text = patientLog?.username
        usernameField.textColor = UIColor.black
        firstnameField.text = patientLog?.firstName
        firstnameField.textColor = UIColor.black
        lastnameFIeld.text = patientLog?.lastName
        lastnameFIeld.textColor = UIColor.black
        
        usernameField.clearsOnBeginEditing = false
        firstnameField.clearsOnBeginEditing = false
        lastnameFIeld.clearsOnBeginEditing = false
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
    
    @IBAction func UpdateBtn(_ sender: Any) {
        if isDataChanged() {
            check = self.checkData()
            if check {
                confirmation(title: "Update Account", message: "Are you sure you want to update your data?") {                    self.updateProfile()
                    AppData.saveData()
                }
            }
        } else {
            errorAlert(title: "No Changes", message: "No changes detected in your profile.")
        }
    }

    func isDataChanged() -> Bool {
        guard let patientLog = patientLog else { return false }

        // Fetch current field values
        let currentUserName = usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let currentFirstName = firstnameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let currentLastName = lastnameFIeld.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        // Compare with existing data
        return currentUserName != patientLog.username || currentFirstName != patientLog.firstName || currentLastName != patientLog.lastName
    }

    
    func updateProfile() {
        Auth.auth().currentUser?.updateEmail(to: self.userName) { error in
            if let error = error {
                self.errorAlert(title: "Update Failed", message: "Failed to update email: \(error.localizedDescription)")
            } else {
                self.patientLog?.firstName = self.fn
                self.patientLog?.lastName = self.ln
                AppData.saveData()
                self.errorAlert(title: "Update Successful", message: "Data Changed Successfully.")
            }
        }
    }
    
    func checkData() -> Bool {
        // take data from the fields
        userName = usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        fn = firstnameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        ln = lastnameFIeld.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // for email format
        let emailFormat = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let valid = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        
        // check if fields are empty
        if userName.isEmpty || fn.isEmpty || ln.isEmpty {
            errorAlert(title: "Error", message: "Please don't leave any data empty")
            return false
        }

        if !valid.evaluate(with: userName) {
            errorAlert(title: "Error", message: "Please enter a valid email")
            return false
        }

        // check if email is changed and already in use
        if userName != loggedInUser?.username {
            if AppData.getUserFromEmail(email: userName) != nil {
                errorAlert(title: "Error", message: "Email is already in use")
                return false
            }
        }
        
        // validate names
        if fn.count < 2 || ln.count < 2 {
            errorAlert(title: "Error", message: "Please enter a valid name")
            return false
        }

        return true
    }


}
