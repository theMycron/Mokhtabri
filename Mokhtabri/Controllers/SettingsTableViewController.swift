//
//  SettingsTableViewController.swift
//  Mokhtabri
//
//  Created by Nooni on 11/12/2023.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    // declaration
    
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var lblChangePassword: UILabel!
    
    @IBOutlet weak var lblContactUs: UILabel!
    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    
    
    @IBAction func logoutBtn(_ sender: Any) {
        confirmation(title: "Log out", message: "Are you sure you want to log out of your account?") { [weak self] in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "login") as? LoginViewController else {
                return
            }
            viewController.modalPresentationStyle = .fullScreen
            self?.present(viewController, animated: true) {
                // Dismiss the previous view controller in settings
                self?.navigationController?.viewControllers = [viewController]
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //lblProfile.text = "Profile"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row after tapping
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 5 {
            // Show an alert
            confirmation(title: "Delete Account", message: "Are you sure you want to delete your account?") { [weak self] in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let viewController = storyboard.instantiateViewController(withIdentifier: "login") as? LoginViewController else {
                    return
                }
                viewController.modalPresentationStyle = .fullScreen
                self?.present(viewController, animated: true) {
                    // Dismiss the previous view controller in settings
                    self?.navigationController?.viewControllers = [viewController]
                }
            }
        }
    }
    
    // for the navigation bar to appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
