//
//  AdminViewTableViewController.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 04/12/2023.
//

import UIKit

class AdminViewTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var displayedFacilities: [MedicalFacility] = AppData.facilities
    let search = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // code to
//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = urls[0]
        
        // simulator appdata in: file:///Users/202100937/Library/Developer/CoreSimulator/Devices/5E73E433-8F87-439B-9657-088DFF95DA7C/data/Containers/Data/Application/A1376A02-B099-497C-9014-9CE60A3D3B54/Documents/
        // TESTING PERSISTENCE
//        AppData.bookings = AppData.sampleBookings
//        AppData.tests = AppData.listOfTests.compactMap {$0 as? Test}
//        AppData.packages = AppData.listOfTests.compactMap {$0 as? Package}
//        AppData.facilities = AppData.labs
//        AppData.saveData()
        
        
        
        embedSearch()
        
        // remove later
        AppData.loadData()
        
        filterFacilities(scope: 0)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    @IBAction func btnLogOutPressed(_ sender: Any) {
        logoutAlert()
    }
    
    // MARK: - Table view data source

    func embedSearch() {
        // might need to use a different controller for the search functionality
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
//        navigationController?.hidesBarsOnSwipe = false
        search.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.preferredSearchBarPlacement = .stacked
        search.searchBar.searchFieldBackgroundPositionAdjustment = .zero
        
        
        search.searchBar.scopeButtonTitles = ["All", "Hospitals", "Labs"]
        search.searchBar.showsScopeBar = true
    }
    
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
        return displayedFacilities.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

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
//        AppData.saveData()
    }
    
    @IBSegueAction func editFacility(_ coder: NSCoder, sender: Any?) -> AdminEditTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        let facility = displayedFacilities[indexPath.section]
        return AdminEditTableViewController(coder: coder, facility: facility)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminViewCell", for: indexPath) as! AdminViewTableViewCell

        // Configure the cell...
        let facility: MedicalFacility = displayedFacilities[indexPath.section]
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
            displayedFacilities.remove(at: indexPath.section)
            tableView.deleteSections([indexPath.section], with: .fade)
            tableView.endUpdates()
            AppData.facilities = displayedFacilities
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
