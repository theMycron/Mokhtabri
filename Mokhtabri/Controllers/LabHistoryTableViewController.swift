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
    
    // Create an array to store the bookings
    var bookings = AppData.bookings
    var searchBar: UISearchBar!
    //var selectedRow = 0
    var selectedSegmentIndex = 0
    
    
    
    
    var activeBookings: [Booking] = []
    var completedBookings: [Booking] = []
    var cancelledBookings: [Booking] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookings = AppData.bookings
        categorizeBookings()
        
        
        
        
        // Set up the search controller
        embedSearch()
        //tableView.reloadData()
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
            let selectedBooking: Booking
            switch selectedSegmentIndex {
            case 0:
                selectedBooking = activeBookings[selectedIndexPath.row]
            case 1:
                selectedBooking = completedBookings[selectedIndexPath.row]
            case 2:
                selectedBooking = cancelledBookings[selectedIndexPath.row]
            default:
                fatalError("Invalid segment index")
            }
            
            destinationVC.cbooking = selectedBooking
            
        }
    }
    
   /* @IBAction func prepareForUnwind(segue:UIStoryboardSegue){
        guard let source = segue.source as? LabBookingInfoTableViewController,
              let updatedBooking = source.cbooking,
              let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        for index in 0..<bookings.count {
            if bookings[index].ofMedicalService == updatedBooking.ofMedicalService && bookings[index].bookingDate == updatedBooking.bookingDate {
                bookings[index] = updatedBooking // Update the booking
                break // Exit the loop if you assume there's only one match
            }
        }
        categorizeBookings() // Recategorize bookings after updating
        tableView.reloadData()
        
    }*/
    func categorizeBookings() {
        activeBookings = bookings.filter { $0.status == .Active } // Replace .active with your actual status value for active bookings
        completedBookings = bookings.filter { $0.status == .Completed } // Replace .completed with your actual status value for completed bookings
        cancelledBookings = bookings.filter { $0.status == .Cancelled } // Replace .cancelled with your actual status value for cancelled bookings
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bookings = AppData.bookings
        categorizeBookings()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookings = AppData.bookings // Re-fetch the bookings
        categorizeBookings()
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            confirmation(title: "Delete Confirmation", message: "Are you sure you want to delete this booking, if the booking is active it will lead to automatic cancellation"){
                
                
                let bookingToRemove: Booking
                switch self.selectedSegmentIndex {
                case 0:
                    bookingToRemove = self.activeBookings[indexPath.row]
                    self.activeBookings.remove(at: indexPath.row)
                case 1:
                    bookingToRemove = self.completedBookings[indexPath.row]
                    self.completedBookings.remove(at: indexPath.row)
                case 2:
                    bookingToRemove = self.cancelledBookings[indexPath.row]
                    self.cancelledBookings.remove(at: indexPath.row)
                default:
                    return // Or handle default case appropriately
                }
                // Find the booking in AppData.bookings
                if let indexInAppData = AppData.bookings.firstIndex(where: { $0.id == bookingToRemove.id }) {
                    AppData.bookings.remove(at: indexInAppData)
                    self.bookings.remove(at: indexInAppData)
                }
                self.categorizeBookings()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

        }
    }}


  
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
   // Override to support editing the table view.

    

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


