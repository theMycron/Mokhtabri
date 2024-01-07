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
        AppData.loadHospitalPhotos()
     //   filterTests()
      //  filterPackages()
        AppData.loadServicesImages() {
            
        }
        //filterLabs()
        //filterHospital()
    }
    
  /*  guard let term = searchController.searchBar.text?.lowercased() else {
        reloadOriginalData()
        return
    }
    if term.isEmpty {
        reloadOriginalData()
    } else {
        switch selectedSegmentIndex {
        case 0:
            activeBookings = activeBookings.filter{
                $0.forPatient.name.lowercased().contains(term) || $0.ofMedicalService.name.lowercased().contains(term)
            }
            
        case 1:                 completedBookings = completedBookings.filter{
            $0.forPatient.name.lowercased().contains(term) || $0.ofMedicalService.name.lowercased().contains(term)
        }
        case 2: cancelledBookings = cancelledBookings.filter{
            $0.forPatient.name.lowercased().contains(term) || $0.ofMedicalService.name.lowercased().contains(term)
        }            default:
            break
        }
    }
    tableView.reloadData()*/
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let term = searchController.searchBar.text?.lowercased() else {
            reCategorize()
            tableView.reloadData()
            return
        }
        if term.isEmpty {
            reCategorize()
            tableView.reloadData()
        } else {
            switch selectedSegmentIndex {
            case 0: tests = tests.filter{
                $0.name.lowercased().contains(term) || $0.forMedicalFacility.name.lowercased().contains(term)}
                packages = packages.filter{$0.name.lowercased().contains(term) || $0.forMedicalFacility.name.lowercased().contains(term)}
                hospitals = hospitals.filter{$0.name.lowercased().contains(term) || $0.city.lowercased().contains(term)}
                labs = labs.filter{
                    $0.name.lowercased().contains(term) || $0.city.lowercased().contains(term)
                }
            case 1:   hospitals = hospitals.filter{$0.name.lowercased().contains(term) || $0.city.lowercased().contains(term)}
            case 2:                 labs = labs.filter{
                $0.name.lowercased().contains(term) || $0.city.lowercased().contains(term)
            }
            case 3: tests = tests.filter{
                $0.name.lowercased().contains(term) || $0.forMedicalFacility.name.lowercased().contains(term)}
            case 4:                 packages = packages.filter{$0.name.lowercased().contains(term) || $0.forMedicalFacility.name.lowercased().contains(term)}
                
                
            default: break
            }
            }
        
        tableView.reloadData()
        }
    
    func reCategorize(){
         labs = AppData.facilities.filter{$0.type == FacilityType.lab}
        hospitals = AppData.facilities.filter{$0.type == FacilityType.hospital}
        tests = AppData.tests
        packages = AppData.packages
    }
    
    @IBAction func segmentClick2(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        tableView.reloadData()
    }
    
    
    @IBOutlet weak var Filter2: UISegmentedControl!    
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
    var labs: [MedicalFacility] = AppData.facilities.filter{$0.type == FacilityType.lab}
    var hospitals: [MedicalFacility] = AppData.facilities.filter{$0.type == FacilityType.hospital}
    var tests: [Test] = AppData.tests
    func filterTests() {
        for service in services {
            if service is Test {
                tests.append(service as! Test)
            }
        }
    }
    var packages: [Package] = AppData.packages
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
        if selectedSegmentIndex == 0 {
            return 4
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Filter2.selectedSegmentIndex == 1 {
            return hospitals.count
        } else if Filter2.selectedSegmentIndex == 2 {
            return labs.count
        } else if Filter2.selectedSegmentIndex == 3 {
            return tests.count
        } else if Filter2.selectedSegmentIndex == 4 {
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
        // for tests
        if selectedSegmentIndex == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PatientBooking", for: indexPath) as! HomeViewPTTableViewCell
            
            let service = tests[indexPath.row]
            cell.TestName.text = service.name
            cell.hospitalName.text = service.forMedicalFacility.name
            cell.price.text = "\(service.price)BHD"
            guard let img1 = service.photo else {
                return cell
            }
            cell.img.image = img1
            return cell
        } 
        // for labs
        else if selectedSegmentIndex == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HospitCell", for: indexPath) as! PatientHospitalViewTableViewCell
            let lab = labs[indexPath.row]
            guard let img1 = lab.photo else {
                return cell
            }
            cell.photo.image = img1
            cell.photo.image = img1
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
                cell.openingTime.text = "From \(hour):00 - \(chour):00"

            }
      
            
            return cell
        } // for packages
        else if selectedSegmentIndex == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PatientBooking", for: indexPath) as! HomeViewPTTableViewCell
            
            let service = packages[indexPath.row]
            cell.TestName.text = service.name
            cell.hospitalName.text = service.forMedicalFacility.name
            cell.price.text = "\(service.price)BHD"
            guard let img = service.photo else {
                return cell
            }
            cell.img.image = img
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
                guard let photo = hospital.photo else {
                    return cell
                }
                cell.photo.image = photo
                return cell
            } // for tests
            else if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PatientBooking", for: indexPath) as! HomeViewPTTableViewCell
                
                let service = tests[indexPath.row]
                cell.TestName.text = service.name
                cell.hospitalName.text = service.forMedicalFacility.name
                cell.price.text = "\(service.price)BHD"
                guard let img = service.photo else {
                    return cell
                }
                cell.img.image = img
                return cell
            }
            // for packages
            else if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PatientBooking", for: indexPath) as! HomeViewPTTableViewCell
                let service = packages[indexPath.row]
                cell.TestName.text = service.name
                cell.hospitalName.text = service.forMedicalFacility.name
                cell.price.text = "\(service.price)BHD"
                guard let img = service.photo else {
                    return cell
                }
                cell.img.image = img
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
                guard let photo = lab.photo else {
                    return cell
                }
                cell.photo.image = photo
                return cell
            }
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
        
        
        if let destination = segue.destination as?
            PatientHospitalSelectTableViewController, let selectedRow = tableView.indexPathForSelectedRow {

            if Filter2.selectedSegmentIndex == 0 {
                if selectedRow.section == 0 {
                    destination.selectedHospital = hospitals[selectedRow.row]
               } else {
                   destination.selectedHospital = labs[selectedRow.row]
               }
            } else if Filter2.selectedSegmentIndex == 1 {
                destination.selectedHospital = hospitals[selectedRow.row]
            } else {
                destination.selectedHospital = labs[selectedRow.row]
            } 
        } else if let destination = segue.destination as? PatientBookTableViewController, let selected = tableView.indexPathForSelectedRow {
            if Filter2.selectedSegmentIndex == 0 {
                 if selected.section == 2 {
                    destination.sampleTest = tests[selected.row]
                } else {
                    destination.sampleTest = packages[selected.row]
                }

            } else if Filter2.selectedSegmentIndex == 3 {
                destination.sampleTest = tests[selected.row]
            }
            else {
                destination.sampleTest = packages[selected.row]
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if Filter2.selectedSegmentIndex == 0 {
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

}
