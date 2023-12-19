//
//  PatientHomeTableViewController.swift
//  Mokhtabri
//
//  Created by Fatema Ahmed Ebrahim Mohamed Naser on 14/12/2023.
//

import UIKit

class PatientHomeTableViewController: UITableViewController,UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    // declaring elements
    
    // search bar
    fileprivate func embedSearch(){
        navigationItem.searchController = UISearchController()
        navigationItem.searchController?.searchBar.placeholder = "Search"
        navigationItem.searchController?.searchResultsUpdater = self
        
        //scope
        navigationItem.searchController?.searchBar.scopeButtonTitles = ["All", "Hospitals","Labs","Tests", "Packages"]
        navigationItem.searchController?.automaticallyShowsScopeBar = false
    }
    
    //sample data
    var hospitals:  [MedicalFacility] = [MedicalFacility(name: "Alsalam Hospital", phone: "13101010", city: "Riffa", website: "https://www.alsalam.care", alwaysOpen: true, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 0, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 0, minute: 0), username: "Alsalam", password: "1234")
    , MedicalFacility(name: "ALHilal Hospital", phone: "17495555", city: "Riffa", website: "https://www.alhilalhealthcare.com", alwaysOpen: false, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 10, minute: 0), username: "AlHilal", password: "4321")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embedSearch()

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
        return hospitals.count
    }

    
    // change data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HospitCell", for: indexPath) as! PatientHospitalViewTableViewCell
        
        
        
        let hospital = hospitals[indexPath.row]
        cell.HospitalName.text = hospital.name
        cell.location.text = hospital.city
        if hospital.alwaysOpen == true {
            cell.openingTime.text = "Open 24 Hours"
        } else {
            guard let hour = hospital.openingTime.hour,
                  let chour = hospital.closingTime.hour
            else {
                return cell
            }
            cell.openingTime.text = "From \(hour) am - \(chour) pm"
        }
        
        // Configure the cell...

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            PatientHospitalSelectTableViewController, let selectedRow = tableView.indexPathForSelectedRow {
            destination.selectedHospital = hospitals[selectedRow.row]
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
