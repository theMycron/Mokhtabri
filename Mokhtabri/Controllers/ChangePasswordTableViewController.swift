//
//  ChangePasswordTableViewController.swift
//  Mokhtabri
//
//  Created by Fatima ahmed on 17/12/2023.
//

import UIKit

class ChangePasswordTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        confirmation(title: "Change Password", message: "Are you sure you want to change your password?") {
            [weak self] in
                    guard let self = self else { return }
                    self.performSegue(withIdentifier: "Settings", sender: nil)
        }
    }
    
    
}
