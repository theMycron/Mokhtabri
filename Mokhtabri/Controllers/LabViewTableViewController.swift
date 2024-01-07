//
//  LabViewTableViewController.swift
//  Mokhtabri
//
//  Created by Ali Husain Ateya Ali Abdulrasool on 21/12/2023.
//

import UIKit

class LabViewTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    var loggedInFacillity = AppData.loggedInUser as! MedicalFacility
    
    var displayedServices: [MedicalService] = []
    let search = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        embedSearch()
        
        // set displayed services to only the ones owned by the logged in facility
        displayedServices = AppData.tests.filter{$0.forMedicalFacility.name == loggedInFacillity.name} + AppData.packages.filter{$0.forMedicalFacility.name == loggedInFacillity.name}
        
        tableView.reloadData()
        
        filterServices(scope: 0)

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
        
        
        search.searchBar.scopeButtonTitles = ["Tests", "Packages"]
        search.searchBar.showsScopeBar = true
    }

    // MARK: - Table view data source
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterServices(scope: selectedScope)
    }

    func filterServices(scope: Int) {
       switch scope {
       
       case 0:
           displayedServices = AppData.tests.filter{$0.forMedicalFacility == loggedInFacillity}
       case 1:
           displayedServices = AppData.packages.filter{$0.forMedicalFacility == loggedInFacillity}
       default:
           return
       }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let scope = search.searchBar.selectedScopeButtonIndex
        if let query = searchController.searchBar.text?.lowercased().trimmingCharacters(in: .whitespaces), !query.isEmpty {
            if scope == 0 {
                displayedServices = AppData.tests.filter{
                    return $0.name.lowercased().contains(query)
                }.filter{$0.forMedicalFacility == loggedInFacillity}
            } else if scope == 1 {
                displayedServices = AppData.packages.filter{
                   return $0.name.lowercased().contains(query)
                }.filter{$0.forMedicalFacility == loggedInFacillity}
            }
            
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
    
    // called when returning from add/edit
    @IBAction func unwindFromEdit(unwindSegue: UIStoryboardSegue) {
        guard let source = unwindSegue.source as? LabEditTableTableViewController,
              let service = source.service
        else {return}
        
        // replace old service with updated one or just add it if it is new
        if let indexPath = tableView.indexPathForSelectedRow {
            displayedServices.remove(at: indexPath.section)
            displayedServices.insert(service, at: indexPath.section)
            tableView.deselectRow(at: indexPath, animated: true)
            AppData.editService(service: service)
        } else {
            displayedServices.append(service)
            AppData.addService(service: service)
        }
        filterServices(scope: search.searchBar.selectedScopeButtonIndex) // refresh view
        AppData.saveData()
    }
    
    // called when clicking a cell to edit
    @IBSegueAction func editService(_ coder: NSCoder, sender: Any?) -> LabEditTableTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        let service = displayedServices[indexPath.section]
        return LabEditTableTableViewController(coder: coder, service: service)
    }
    

    // configure the cells in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> LabViewTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabViewCell", for: indexPath) as! LabViewTableViewCell

        let service: MedicalService = displayedServices[indexPath.section]
        cell.update(with: service)

        return cell
    }
    
    
    // for deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           let  service = displayedServices[indexPath.section]
            tableView.beginUpdates()
            // Delete the row from the data source
            displayedServices.remove(at: indexPath.section)
            tableView.deleteSections([indexPath.section], with: .fade)
            tableView.endUpdates()

            _=AppData.deleteService(service: service)
            AppData.saveData()
        }
    }
    

    
}
