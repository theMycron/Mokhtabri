//
//  SettingsTableViewController.swift
//  Mokhtabri
//
//  Created by Noora Qasim on 11/12/2023.
//

import UIKit

class SettingsTableViewController: UITableViewController{
    var loggedInUser: User? = AppData.loggedInUser
    var patientLog: Patient?
    
    // declaration
    
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var lblChangePassword: UILabel!
    
    @IBOutlet weak var lblContactUs: UILabel!
    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    
    // log out button
    @IBAction func logoutBtn(_ sender: Any) {
        logoutAlert()
    }
    

    
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
        return 5
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row after tapping
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    // for the navigation bar to appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
