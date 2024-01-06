//
//  PatientHospitalSelectTableViewController.swift
//  Mokhtabri
//
//  Created by Fatema Ahmed Ebrahim Mohamed Naser on 19/12/2023.
//

import UIKit

class PatientHospitalSelectTableViewController: UITableViewController {
    
    @IBAction func segmentClick(_ sender: UISegmentedControl) {
        selectedIndex = sender.selectedSegmentIndex
       // loadData()
        tableView.reloadData()    }
    
    func filter(){

    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    // declare variables
    var selectedHospital: MedicalFacility?
    var listOfTests: [MedicalService] = AppData.services
    var selectedIndex = 0
    var tests : [Test] = []
    var packages: [Package] = []
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PatientBookTableViewController, let selectedRow = tableView.indexPathForSelectedRow{
            destination.sampleTest = listOfTests[selectedRow.row]
        }
    }
    override func viewDidLoad() {
        loadData()
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 160
            }
        }
        return 96
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if selectedIndex == 0{
            if section == 0 {
                return 2
            } else {
                return tests.count
            }
        } else {
            if section == 0 {
                return 2
            }else{
                return packages.count
            }
        }
        
        
    }
    
    func loadData() {
        
        //let listOfAllTests = AppData.services
        guard let hospital = selectedHospital else {
            return
        }
        
     /*   for test in listOfTests {
            if test.forMedicalFacility.name == hospital.name {
            listOfTests.append(test)
            }
        }*/
        
        for service in listOfTests {
            if service is Package && service.forMedicalFacility == hospital{
                packages.append(service as! Package)
            } else if service is Test && service.forMedicalFacility == hospital {
                tests.append(service as! Test)
            }
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedIndex == 0{
            if indexPath.section == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "PatientBooking", for: indexPath) as! PatientBookingTableViewCell

                cell.TestName.text = tests[indexPath.row].name
                cell.price.text = "\(tests[indexPath.row].price) BHD"
                cell.hospitalName.text = "\(tests[indexPath.row].forMedicalFacility.name)"

                
        
                return cell
            }
            else {
                if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "infocell", for: indexPath) as! PatientViewInfoTableViewCell
                    
                    if selectedHospital?.alwaysOpen == true {
                        if let hospitalName = selectedHospital?.name, let hospitalCity = selectedHospital?.city {
                            cell.info.text = "\(hospitalName) - \(hospitalCity) - Open 24 Hours"
                        } else {
                            // Handle the case where either name or city is nil
                            cell.info.text = "Hospital Information Not Available"
                        }
                    } else {
                        if let hospitalName = selectedHospital?.name, let hospitalCity = selectedHospital?.city, let openingTime = selectedHospital?.openingTime.hour, let closingTime = selectedHospital?.closingTime.hour {
                            cell.info.text = "\(hospitalName) - \(hospitalCity)  Timing: \(openingTime):00 - \(closingTime):00"
                        } else {
                            // if there's missing data
                            cell.info.text = "Hospital Information Not Available"
                        }
                    }
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "imagecell", for: indexPath) as! imgTableViewCell
                    cell.img.image = UIImage(named: "AlHilal")
                    cell.img.frame = CGRect(x: 76, y: 0, width: 201, height: 158)
                    return cell
                }
            }

        } else {
            if indexPath.section == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "PatientBooking", for: indexPath) as! PatientBookingTableViewCell

                cell.TestName.text = packages[indexPath.row].name
                cell.price.text = "\(packages[indexPath.row].price) BHD"
                cell.hospitalName.text = "\(packages[indexPath.row].forMedicalFacility.name)"

                
        
                return cell
            }
            else {
                if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "infocell", for: indexPath) as! PatientViewInfoTableViewCell
                    
                    if selectedHospital?.alwaysOpen == true {
                        if let hospitalName = selectedHospital?.name, let hospitalCity = selectedHospital?.city {
                            cell.info.text = "\(hospitalName) - \(hospitalCity) - Open 24 Hours"
                        } else {
                            // Handle the case where either name or city is nil
                            cell.info.text = "Hospital Information Not Available"
                        }
                    } else {
                        if let hospitalName = selectedHospital?.name, let hospitalCity = selectedHospital?.city, let openingTime = selectedHospital?.openingTime.hour, let closingTime = selectedHospital?.closingTime.hour {
                            cell.info.text = "\(hospitalName) - \(hospitalCity)  Timing: \(openingTime):00 - \(closingTime):00"
                        } else {
                            // if there's missing data
                            cell.info.text = "Hospital Information Not Available"
                        }
                    }
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "imagecell", for: indexPath) as! imgTableViewCell
                    cell.img.image = UIImage(named: "AlHilal")
                    cell.img.frame = CGRect(x: 76, y: 0, width: 201, height: 158)
                    return cell
                }
            }

        }
    }

}
