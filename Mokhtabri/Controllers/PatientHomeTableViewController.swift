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
    var hospitals:  [MedicalFacility] = AppData.facilities
    var services: [MedicalService] = AppData.services
    
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return hospitals.count
        }else {
            return services.count
        }
        
    }

    
    // change data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PatientBooking", for: indexPath) as! PatientBookingTableViewCell
            
            let service = services[indexPath.row]
            cell.TestName.text = service.name
            cell.hospitalName.text = service.forMedicalFacility.name
            cell.price.text = "\(service.price)BHD"
            if service is Test {
                //cell.type.text = "Test"
            }else{
                //cell.type.text = "Package"
            }
            return cell
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            PatientHospitalSelectTableViewController, let selectedRow = tableView.indexPathForSelectedRow {
            destination.selectedHospital = hospitals[selectedRow.row]
        } else if let destination = segue.destination as? PatientBookTableViewController, let selected = tableView.indexPathForSelectedRow {
            destination.sampleTest = services[selected.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Hospitals/Labs"
        }else{
            return "Tests/Packages"
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
