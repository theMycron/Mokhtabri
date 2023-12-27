//
//  LabViewTableViewController.swift
//  Mokhtabri
//
//  Created by Ali Husain Ateya Ali Abdulrasool on 21/12/2023.
//

import UIKit

class LabViewTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    var displayedServices: [MedicalService] = AppData.services
    let search = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        embedSearch()
        
        // remove later
        AppData.loadData()
        
        filterServices(scope: 0)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func btnLogOutPressed(_ sender: Any) {
        logoutAlert()
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
        
        
        search.searchBar.scopeButtonTitles = ["All", "Tests", "Packages"]
        search.searchBar.showsScopeBar = true
    }

    // MARK: - Table view data source
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterServices(scope: selectedScope)
    }

    func filterServices(scope: Int) {
        switch scope {
        case 0:
            displayedServices = AppData.services
        case 1:
            displayedServices = AppData.services.compactMap{(($0 as? Test) != nil) ? $0 : nil}
        //case 2:
            //displayedServices = AppData.services.compactMap((($0 as? Package) != nil) ? $0 : nil)
        
        default:
            return
        }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let scope = search.searchBar.selectedScopeButtonIndex
        if let query = searchController.searchBar.text?.lowercased().trimmingCharacters(in: .whitespaces), !query.isEmpty {
            if scope == 0 {
                displayedServices = AppData.services.filter{
                    return $0.name.lowercased().contains(query)
                }
            } /*else if scope == 1 {
                displayedFacilities = AppData.services.filter{
                    return $0.type == FacilityType.hospital && ($0.name.lowercased().contains(query) || $0.city.lowercased().contains(query))
                }
            } else if scope == 2 {
                displayedFacilities = AppData.services.filter{
                    return $0.type == FacilityType.lab && ($0.name.lowercased().contains(query) || $0.city.lowercased().contains(query))
                }
            }*/
        } else {
            filterServices(scope: scope)
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return displayedServices.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    // this is my checkpoint for now
    
    //Edit AdminEditTableViewController name
    @IBAction func unwindFromEdit(unwindSegue: UIStoryboardSegue) {
        guard let source = unwindSegue.source as? LabEditTableTableViewController,
              let facility = source.service
        else {return}
        
        // replace old facility with updated one or just add it if it is new
        
        
        if let indexPath = tableView.indexPathForSelectedRow {
            displayedServices.remove(at: indexPath.section)
            displayedServices.insert(facility, at: indexPath.section)
            tableView.deselectRow(at: indexPath, animated: true)
            AppData.editService(service: facility)
        } else {
            displayedServices.append(facility)
            AppData.addService(service: facility)
        }
        filterServices(scope: search.searchBar.selectedScopeButtonIndex) // refresh view
        AppData.saveData()
    }
    
    //-----------
    @IBSegueAction func editService(_ coder: NSCoder, sender: Any?) -> LabEditTableTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        let facility = displayedServices[indexPath.section]
        return LabEditTableTableViewController(coder: coder, facility: facility)
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> LabViewTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabViewCell", for: indexPath) as! LabViewTableViewCell

        let facility: MedicalService = displayedServices[indexPath.section]
        cell.update(with: facility)

        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            // Delete the row from the data source
            displayedServices.remove(at: indexPath.section)
            tableView.deleteSections([indexPath.section], with: .fade)
            tableView.endUpdates()
            AppData.services = displayedServices
            AppData.saveData()
        }
    }
    

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
