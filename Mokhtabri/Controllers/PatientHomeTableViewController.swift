//
//  PatientHomeTableViewController.swift
//  Mokhtabri
//
//  Created by Fatema Ahmed Ebrahim Mohamed Naser on 14/12/2023.
//

import UIKit

class PatientHomeTableViewController: UITableViewController,UISearchBarDelegate, UISearchResultsUpdating {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embedSearch()

        filterTests()
        filterPackages()
        filterLabs()
        //filterHospital()
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    @IBAction func segementClick(_ sender: Any) {
    }
    @IBOutlet weak var Filter: UISegmentedControl!
    
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
    var facility:  [MedicalFacility] = AppData.facilities
    var services: [MedicalService] = AppData.services
    var labs: [MedicalFacility] = AppData.labs
    var hospitals: [MedicalFacility] = AppData.hospitals
    var tests: [Test] = []
    func filterTests() {
        for service in services {
            if service is Test {
                tests.append(service as! Test)
            }
        }
    }
    var packages: [Package] = []
    func filterPackages() {
        for service in services {
            if service is Package {
                packages.append(service as! Package)
            }
        }
    }
    func filterLabs() {
        for fac  in facility {
            if fac.type == .lab {
                labs.append(fac )
            }
        }
    }
    
    func filterHospital(){
        for fac  in facility {
            if fac.type == .hospital {
                hospitals.append(fac )
            }
        }
    }

    



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if Filter.selectedSegmentIndex == 0 {
            return 4
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Filter.selectedSegmentIndex == 1 {
            return facility.count
        } else if Filter.selectedSegmentIndex == 2 {
            return labs.count
        } else if Filter.selectedSegmentIndex == 3 {
            return tests.count
        } else if Filter.selectedSegmentIndex == 4 {
            return packages.count
        }else {
            if section == 0 {
                return hospitals.count
            } else if section == 1 {
                return labs.count
            } else if section == 2{
                return tests.count
            }else {
                return packages.count
            }
        }
    }

    
    // change data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // for hospitals
        if Filter.selectedSegmentIndex == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PatientBooking", for: indexPath) as! PatientBookingTableViewCell
            
            let service = tests[indexPath.row]
            cell.TestName.text = service.name
            cell.hospitalName.text = service.forMedicalFacility.name
            cell.price.text = "\(service.price)BHD"

            return cell
        } else if Filter.selectedSegmentIndex == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HospitCell", for: indexPath) as! PatientHospitalViewTableViewCell
            let lab = labs[indexPath.row]
            cell.HospitalName.text = lab.name
            cell.location.text = lab.city
            if lab.alwaysOpen == true {
                cell.openingTime.text = "Open 24 Hours"
            } else {
                guard let hour = lab.openingTime.hour,
                      let chour = lab.closingTime.hour
                else {
                    return cell
                }
                cell.openingTime.text = "From \(hour) am - \(chour) pm"
            }
            return cell
        }
        
        // for packages
        else if Filter.selectedSegmentIndex == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PatientBooking", for: indexPath) as! PatientBookingTableViewCell
            
            let service = packages[indexPath.row]
            cell.TestName.text = service.name
            cell.hospitalName.text = service.forMedicalFacility.name
            cell.price.text = "\(service.price)BHD"

            return cell
        } else {
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
                    cell.openingTime.text = "From \(hour):00 - \(chour):00"
                }
                
                return cell
            } // for tests
            else if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PatientBooking", for: indexPath) as! PatientBookingTableViewCell
                
                let service = tests[indexPath.row]
                cell.TestName.text = service.name
                cell.hospitalName.text = service.forMedicalFacility.name
                cell.price.text = "\(service.price)BHD"
                return cell
            }
            // for packages
            else if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PatientBooking", for: indexPath) as! PatientBookingTableViewCell
                let service = packages[indexPath.row]
                cell.TestName.text = service.name
                cell.hospitalName.text = service.forMedicalFacility.name
                cell.price.text = "\(service.price)BHD"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HospitCell", for: indexPath) as! PatientHospitalViewTableViewCell
                let lab = labs[indexPath.row]
                cell.HospitalName.text = lab.name
                cell.location.text = lab.city
                if lab.alwaysOpen == true {
                    cell.openingTime.text = "Open 24 Hours"
                } else {
                    guard let hour = lab.openingTime.hour,
                          let chour = lab.closingTime.hour,
                          let min = lab.openingTime.minute,
                            let cmin = lab.closingTime.minute
                    else {
                        return cell
                    }
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm" // 24-hour format

                    // Assuming 'hour', 'min', 'chour', and 'cmin' are integers
                    let calendar = Calendar.current

                    // Create opening time Date
                    var openingComponents = DateComponents()
                    openingComponents.hour = hour
                    openingComponents.minute = min
                    if let openingDate = calendar.date(from: openingComponents) {
                        let openingTimeString = formatter.string(from: openingDate)
                        cell.openingTime.text = "From \(openingTimeString)"
                    }

                    // Create closing time Date
                    var closingComponents = DateComponents()
                    closingComponents.hour = chour
                    closingComponents.minute = cmin
                    if let closingDate = calendar.date(from: closingComponents) {
                        let closingTimeString = formatter.string(from: closingDate)
                        cell.openingTime.text?.append(" - \(closingTimeString)")
                    }

                }
                return cell
            }
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
        
        
        if let destination = segue.destination as?
            PatientHospitalSelectTableViewController, let selectedRow = tableView.indexPathForSelectedRow {

            if Filter.selectedSegmentIndex == 0 {
                if selectedRow.section == 2 {
                    destination.selectedHospital = facility[selectedRow.row]
               } else {
                   destination.selectedHospital = labs[selectedRow.row]
               }
            } else if Filter.selectedSegmentIndex == 1 {
                destination.selectedHospital = facility[selectedRow.row]
            } else {
                destination.selectedHospital = labs[selectedRow.row]
            }
            //destination.selectedHospital = facility[selectedRow.row]
            
        } else if let destination = segue.destination as? PatientBookTableViewController, let selected = tableView.indexPathForSelectedRow {
            if Filter.selectedSegmentIndex == 0 {
                //to do, change to 2 later
                 if selected.section == 1 {
                    destination.sampleTest = tests[selected.row]
                } else {
                    destination.sampleTest = packages[selected.row]
                }

            } else if Filter.selectedSegmentIndex == 3 {
                destination.sampleTest = tests[selected.row]
            }
            else {
                destination.sampleTest = packages[selected.row]
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if Filter.selectedSegmentIndex == 0 {
            if section == 0 {
                return "Hospitals"
            } else if section == 1 {
                return "Labs"
            }
    else if section == 2 {
                return "Tests"
            } else if section == 3 {
                return "Packages"
            } else {
                return "invalid"
            }
        } else {
            return ""
        }

    }
    
    // Property to keep track of the selected segment index
    var selectedSegmentIndex: Int = 0 {
        didSet {
            tableView.reloadData()
        }
    }

    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:

            tableView.reloadData()
            break
        case 1:
            // handles hospital
            tableView.reloadData()
            break
        case 2:
            // handles lab
            tableView.reloadData()
            break
        case 3:
            // handles tests
            tableView.reloadData()
            break
            
        case 4:
            // handles packages
            tableView.reloadData()
            break
        default:
            tableView.reloadData()
            break
        }
        
    }
    
    func categorizeView() {
        
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
