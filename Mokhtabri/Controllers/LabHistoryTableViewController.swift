//
//  LabHistoryTableViewController.swift
//  Mokhtabri
//
//  Created by Noora Qasim on 09/12/2023.
//

import UIKit

class LabHistoryTableViewController: UITableViewController, UISearchBarDelegate {
    // Create a patient
    var patient = Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#")
    
    var searchBar: UISearchBar!

    // Create an array to store the bookings
    var bookings = [
        
        Booking(forPatient: Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#")
    , ofMedicalService: MedicalService(name: "VitaminB12", price: 10, description: "Blood test for vitamin B12", instructions: "Fasting required for 8 to 12 hours", forMedicalFacility: MedicalFacility(name: "Al Hilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: true, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "AlHihalEastRiffa", password: "alhilal")), bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 1, day: 10)),
                    
                    
                    Booking(forPatient: Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#")
                , ofMedicalService: MedicalService(name: "Vitamin D", price: 10, description: "Blood test for vitamin B12", instructions: "Fasting required for 8 to 12 hours", forMedicalFacility: MedicalFacility(name: "Al Hilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: true, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "AlHihalEastRiffa", password: "alhilal")), bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 2, day: 15)),
    
    
                    Booking(forPatient: Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#")
                , ofMedicalService: MedicalService(name: "Iron and Hb", price: 10, description: "Blood test for vitamin B12", instructions: "Fasting required for 8 to 12 hours", forMedicalFacility: MedicalFacility(name: "Al Hilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: true, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "AlHihalEastRiffa", password: "alhilal")), bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 3, day: 20))]


    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 0 || section == 1){
            return 0
        }else {
            return bookings.count
        }
        
    }
    
  
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientViewCell", for: indexPath) as! LabBookingTableViewCell
        
        // Configure the cell...
        // Assuming your cell has labels named 'patientNameLabel' and 'bookingDateLabel'
        let booking = bookings[indexPath.row]
        let patientName = "\(booking.forPatient.firstName) \(booking.forPatient.lastName)"
        let bookingDate = booking.bookingDate
        
        // Configure your cell's labels with the booking information
        cell.name.text = booking.ofMedicalService.name
        cell.patient.text = patientName
        if let year = bookingDate.year, let month = bookingDate.month, let day = bookingDate.day {
            cell.bookingDate.text = "Booking date: \(year)-\(month)-\(day)"
        } else {
            // Handle the case where one or more components are nil (optional)
            cell.bookingDate.text = "Booking date: N/A" // Or any other suitable placeholder
        }
        
        return cell
    }
    
    func createSearchBarHeaderView() -> UIView {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        // Customize the appearance of the search bar if needed
        return searchBar
    }

    func createSegmentedControlHeaderView() -> UIView {
        let segmentedControl = UISegmentedControl(items: ["Active", "Completed","Cancelled"])
        segmentedControl.selectedSegmentIndex = 0 // Set the initial selected index
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        // Customize the appearance of the segmented control if needed
        
        return segmentedControl
    }

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // Handle Option 1 selection
            break
        case 1:
            // Handle Option 2 selection
            break
        default:
            break
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return createSearchBarHeaderView()
        case 1:
            return createSegmentedControlHeaderView()
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 2){
            return 10
        }else{
            return 44 // Adjust the height as needed
        }}


   


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
