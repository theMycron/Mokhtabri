//
//  PatientUpdateProfileTableViewController.swift
//  Mokhtabri
//
//  Created by Fatima ahmed on 16/12/2023.
//

import UIKit

class PatientUpdateProfileTableViewController: UITableViewController {
    
    //declaring elements
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameFIeld: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    // declare var
    var p = AppData.patient1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.text = p.username
        usernameField.textColor = UIColor.black
        firstnameField.text = p.firstName
        firstnameField.textColor = UIColor.black
        lastnameFIeld.text = p.lastName
        lastnameFIeld.textColor = UIColor.black
        phoneField.text = p.phone
        phoneField.textColor = UIColor.black
        emailField.text = p.email
        emailField.textColor = UIColor.black
        
        usernameField.clearsOnBeginEditing = false
        firstnameField.clearsOnBeginEditing = false
        lastnameFIeld.clearsOnBeginEditing = false
        phoneField.clearsOnBeginEditing = false
        emailField.clearsOnBeginEditing = false

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    @IBAction func UpdateBtn(_ sender: Any) {
        confirmation(title: "Update Account", message: "Are you sure you want to update your data?") {
            
            let updatedUsername = self.usernameField.text
            let updatedFirstname = self.firstnameField.text
            let updatedLastname = self.lastnameFIeld.text
            let updatedPhone = self.phoneField.text
            let updatedEmail = self.emailField.text
            
            // Check for nil or empty strings if necessary, depending on your validation requirements
            guard let username = updatedUsername, !username.isEmpty,
                  let firstname = updatedFirstname, !firstname.isEmpty,
                  let lastname = updatedLastname, !lastname.isEmpty,
                  let phone = updatedPhone, !phone.isEmpty,
                  let email = updatedEmail, !email.isEmpty else {
                let errorAlert = UIAlertController(title: "Error", message: "Please don't leave any fields blank.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(errorAlert, animated: true)
                return
            }
            self.p.username = username
            self.p.firstName = firstname
            self.p.lastName = lastname
            self.p.phone = phone
            self.p.email = email
            
            // confirmation alert
            let confirmAlert = UIAlertController(title: "Confirmation", message: "Data changed successfully", preferredStyle: .alert)
            confirmAlert.addAction(UIAlertAction(title: "Dismiss", style: .default) { [weak self] _ in
                self?.performSegue(withIdentifier: "Settings", sender: nil)
            })


        }
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
