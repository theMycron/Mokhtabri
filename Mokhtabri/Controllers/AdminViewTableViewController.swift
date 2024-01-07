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
        embedSearch()
        
        filterFacilities(scope: 0)
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
    
    // this is used for search functionality
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

    // this is called when returning from the edit view
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
    
    // this is called when a cell is clicked
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
            let facility = displayedFacilities[indexPath.section]
            tableView.beginUpdates()
            // Delete the row from the data source
            displayedFacilities.remove(at: indexPath.section)
            tableView.deleteSections([indexPath.section], with: .fade)
            tableView.endUpdates()
            _=AppData.deleteUser(user: facility)
            AppData.saveData()
        }
    }
}
