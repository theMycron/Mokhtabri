//
//  AdminViewTableViewController.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 04/12/2023.
//

import UIKit

class AdminViewTableViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // might need to use a different controller for the search functionality
        let search = UISearchController()
        search.delegate = self
        search.searchBar.delegate = self
        self.navigationItem.searchController = search
//        navigationController?.hidesBarsOnSwipe = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.preferredSearchBarPlacement = .stacked
        search.searchBar.searchFieldBackgroundPositionAdjustment = .zero
        
        
        search.searchBar.scopeButtonTitles = ["All", "Hospitals", "Labs"]
        search.searchBar.showsScopeBar = true
        
        AppData.loadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return AppData.facilities.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    @IBAction func unwindFromEdit(unwindSegue: UIStoryboardSegue) {
        guard let source = unwindSegue.source as? AdminEditTableViewController,
              let facility = source.facility
        else {return}
        
        if let indexPath = tableView.indexPathForSelectedRow {
            AppData.facilities.remove(at: indexPath.section)
            AppData.facilities.insert(facility, at: indexPath.section)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            AppData.facilities.append(facility)
        }
        tableView.reloadData()
    }
    
    @IBSegueAction func editFacility(_ coder: NSCoder, sender: Any?) -> AdminEditTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        let facility = AppData.facilities[indexPath.section]
        return AdminEditTableViewController(coder: coder, facility: facility)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminViewCell", for: indexPath) as! AdminViewTableViewCell

        // Configure the cell...
        let facility: MedicalFacility = AppData.facilities[indexPath.section]
        cell.update(with: facility)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 5
        }
    
    
    
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            // Delete the row from the data source
            AppData.facilities.remove(at: indexPath.section)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.deleteSections([indexPath.section], with: .fade)
            tableView.endUpdates()
//            tableView.deleteSections(<#T##sections: IndexSet##IndexSet#>, with: <#T##UITableView.RowAnimation#>)
            AppData.saveData()
        }
    }
    

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
