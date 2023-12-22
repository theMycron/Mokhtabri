//
//  LabViewTableViewController.swift
//  Mokhtabri
//
//  Created by Ali Husain Ateya Ali Abdulrasool on 21/12/2023.
//

import UIKit

class LabViewTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    var displayedFacilities: [MedicalFacility] = AppData.facilities
    let search = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        embedSearch()
        
        // remove later
        AppData.loadData()
        
        filterFacilities(scope: 0)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func embedSearch(){
        // might need to use a different controller for the search functionality
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
//        navigationController?.hidesBarsOnSwipe = false
        search.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.preferredSearchBarPlacement = .stacked
        search.searchBar.searchFieldBackgroundPositionAdjustment = .zero
        
        
        search.searchBar.scopeButtonTitles = [ "Tests", "Packages"]
        search.searchBar.showsScopeBar = true
    }

    // MARK: - Table view data source
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterFacilities(scope: selectedScope)
    }

    func filterFacilities(scope: Int) {
        switch scope {
        case 0:
            displayedFacilities = AppData.facilities
        case 1:
            displayedFacilities = AppData.facilities.compactMap{$0.type == FacilityType.hospital ? $0 : nil}
        case 2:
            displayedFacilities = AppData.facilities.compactMap{$0.type == FacilityType.lab ? $0 : nil}
        default:
            return
        }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let scope = search.searchBar.selectedScopeButtonIndex
        if let query = searchController.searchBar.text?.lowercased().trimmingCharacters(in: .whitespaces), !query.isEmpty {
            if scope == 0 {
                displayedFacilities = AppData.facilities.filter{
                    return $0.name.lowercased().contains(query) || $0.city.lowercased().contains(query)
                }
            } else if scope == 1 {
                displayedFacilities = AppData.facilities.filter{
                    return $0.type == FacilityType.hospital && ($0.name.lowercased().contains(query) || $0.city.lowercased().contains(query))
                }
            } else if scope == 2 {
                displayedFacilities = AppData.facilities.filter{
                    return $0.type == FacilityType.lab && ($0.name.lowercased().contains(query) || $0.city.lowercased().contains(query))
                }
            }
        } else {
            filterFacilities(scope: scope)
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return displayedFacilities.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    // this is my checkpoint for now
    
    //Edit AdminEditTableViewController name
    @IBAction func unwindFromEdit(unwindSegue: UIStoryboardSegue) {
        guard let source = unwindSegue.source as? AdminEditTableViewController,
              let facility = source.facility
        else {return}
        
        // replace old facility with updated one or just add it if it is new
        if let indexPath = tableView.indexPathForSelectedRow {
            displayedFacilities.remove(at: indexPath.section)
            displayedFacilities.insert(facility, at: indexPath.section)
            tableView.deselectRow(at: indexPath, animated: true)
            AppData.editUser(user: facility)
        } else {
            displayedFacilities.append(facility)
            AppData.addUser(user: facility)
        }
        filterFacilities(scope: search.searchBar.selectedScopeButtonIndex) // refresh view
        AppData.saveData()
    }
    
    //-----------
    //Edit AdminEditTableViewController name
    @IBSegueAction func editFacility(_ coder: NSCoder, sender: Any?) -> AdminEditTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        let facility = displayedFacilities[indexPath.section]
        return AdminEditTableViewController(coder: coder, facility: facility)
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
