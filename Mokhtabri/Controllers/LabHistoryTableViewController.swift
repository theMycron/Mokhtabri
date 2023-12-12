//
//  LabHistoryTableViewController.swift
//  Mokhtabri
//
//  Created by Noora Qasim on 09/12/2023.
//

import UIKit

class LabHistoryTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
       // let scope = searchController.searchBar.selectedScopeButtonIndex
        
        
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        categorizeBookings()
        tableView.reloadData()
    }
    
    
    // Create a patient
    var patient = Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#")
    
    var searchBar: UISearchBar!
    //var selectedRow = 0
    var selectedSegmentIndex = 0
    // Create an array to store the bookings
    var bookings = [
        
        Booking(forPatient: Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#")
    , ofMedicalService: MedicalService(name: "VitaminB12", price: 10, description: "Blood test for vitamin B12", instructions: "Fasting required for 8 to 12 hours", forMedicalFacility: MedicalFacility(name: "Al Hilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: true, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "AlHihalEastRiffa", password: "alhilal")), bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 1, day: 10)),
                    
                    
                    Booking(forPatient: Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#")
                , ofMedicalService: MedicalService(name: "Vitamin D", price: 10, description: "Blood test for vitamin B12", instructions: "Fasting required for 8 to 12 hours", forMedicalFacility: MedicalFacility(name: "Al Hilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: true, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "AlHihalEastRiffa", password: "alhilal")), bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 2, day: 15)),
    
    
                    Booking(forPatient: Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#")
                , ofMedicalService: MedicalService(name: "Iron and Hb", price: 10, description: "Blood test for vitamin B12", instructions: "Fasting required for 8 to 12 hours", forMedicalFacility: MedicalFacility(name: "Al Hilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: false, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "AlHihalEastRiffa", password: "alhilal")), bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 3, day: 20))]


    
    var activeBookings: [Booking] = []
    var completedBookings: [Booking] = []
    var cancelledBookings: [Booking] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categorizeBookings()



        // Set up the search controller
        embedSearch()

    }
    
    fileprivate func embedSearch(){
        navigationItem.searchController = UISearchController()
        navigationItem.searchController?.searchBar.placeholder = "Search Through Bookings"
        navigationItem.searchController?.searchResultsUpdater = self
        
        //scope
        navigationItem.searchController?.searchBar.scopeButtonTitles = ["Active", "Completed","Cancelled"]
        navigationItem.searchController?.automaticallyShowsScopeBar = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch selectedSegmentIndex {
        case 0: return activeBookings.count
        case 1: return completedBookings.count
        case 2: return cancelledBookings.count
        default: return 0
        }
        
        
    }
    
  
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientViewCell", for: indexPath) as! LabBookingTableViewCell
        
        // Configure the cell...
        // Assuming your cell has labels named 'patientNameLabel' and 'bookingDateLabel'
            // let booking = bookings[indexPath.row]
        let booking: Booking
        switch selectedSegmentIndex {
        case 0: booking = activeBookings[indexPath.row]
        case 1: booking = completedBookings[indexPath.row]
        case 2: booking = cancelledBookings[indexPath.row]
        default: fatalError("Invalid segment index")
        }
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
    



    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        categorizeBookings()
        tableView.reloadData()
    }
  

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 2  || section == 0){
            return 10
        }else{
            return 44 // Adjust the height as needed
        }}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? LabBookingInfoTableViewController,
           let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Pass the selected Booking to the destination view controller
            destinationVC.cbooking = bookings[selectedIndexPath.row]
        }
    }
    
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue){
        guard let source = segue.source as? LabBookingInfoTableViewController,
              let updatedBooking = source.cbooking,
              let indexPath = tableView.indexPathForSelectedRow else {
            return
        }

        bookings[indexPath.row] = updatedBooking
        categorizeBookings() // Recategorize bookings after updating
        tableView.reloadData()
                
    }
    func categorizeBookings() {
        activeBookings = bookings.filter { $0.status == .Active } // Replace .active with your actual status value for active bookings
        completedBookings = bookings.filter { $0.status == .Completed } // Replace .completed with your actual status value for completed bookings
        cancelledBookings = bookings.filter { $0.status == .Cancelled } // Replace .cancelled with your actual status value for cancelled bookings
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


