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
        firstnameField.text = patientLog?.firstName
        firstnameField.textColor = UIColor.black
        lastnameFIeld.text = patientLog?.lastName
        lastnameFIeld.textColor = UIColor.black
        
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
        return 2
    }
    
    @IBAction func UpdateBtn(_ sender: Any) {
        if isDataChanged() {
            check = self.checkData()
            if check {
                confirmation(title: "Update Account", message: "Are you sure you want to update your data?") {
                    guard let patientLog = self.patientLog else {
                        return
                    }
                    patientLog.firstName = self.fn
                    patientLog.lastName = self.ln
                    AppData.editUser(user: patientLog)
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
        let currentFirstName = firstnameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let currentLastName = lastnameFIeld.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        // Compare with existing data
        return currentFirstName != patientLog.firstName || currentLastName != patientLog.lastName
    }

    
    func checkData() -> Bool {
        // take data from the fields
        fn = firstnameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        ln = lastnameFIeld.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        

        // check if fields are empty
        if fn.isEmpty || ln.isEmpty {
            errorAlert(title: "Error", message: "Please don't leave any data empty")
            return false
        }
        
        // validate names
        if fn.count < 2 || ln.count < 2 {
            errorAlert(title: "Error", message: "Please enter a valid name")
            return false
        }

        return true
    }


}
