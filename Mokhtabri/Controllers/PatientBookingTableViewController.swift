//
//  PatientBookingTableViewController.swift
//  Mokhtabri
//
//  Created by Noora Qasim on 17/12/2023.
//

import UIKit

class PatientBookingTableViewController: UITableViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    

    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        selectedSegement = sender.selectedSegmentIndex
        categorizeBookings()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        embedSearch()
        categorizeBookings()
        //AppData.loadServicesImages(AppData)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    fileprivate func embedSearch(){
        navigationItem.searchController = UISearchController()
        navigationItem.searchController?.searchBar.placeholder = "Search Through Bookings"
        navigationItem.searchController?.searchResultsUpdater = self
        
        //scope
        navigationItem.searchController?.searchBar.scopeButtonTitles = ["Active", "Completed","Cancelled"]
        navigationItem.searchController?.automaticallyShowsScopeBar = false
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch selectedSegement{
        case 0: return activeBookings.count
        case 1: return completedBookings.count
        case 2: return cancelledBookings.count
        default: return 0
        }
    }
//declare
    var listOfBookings = AppData.bookings
    var activeBookings : [Booking] = []
    var completedBookings : [Booking] = []
    var cancelledBookings : [Booking] = []
    var selectedSegement = 0
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientBooking", for: indexPath) as! PatientBookingTableViewCell
        
        let booking: Booking
        switch selectedSegement {
        case 0: booking = activeBookings[indexPath.row]
        case 1: booking = completedBookings[indexPath.row]
        case 2: booking = cancelledBookings[indexPath.row]
        default: fatalError("Invalid segment")
        }
        guard let dateDay = booking.bookingDate.day, let dateMonth = booking.bookingDate.month, let dateYear = booking.bookingDate.year else{
            return cell
        }
        cell.bookingDate.text = "Date:\(dateDay)-\(dateMonth)-\(dateYear)"
        cell.TestName.text = booking.ofMedicalService.name
        cell.hospitalName.text = booking.ofMedicalService.forMedicalFacility.name
        cell.price.text = "\(booking.ofMedicalService.price) BHD"
        cell.type.text = "Test"
        if let img = booking.ofMedicalService.photo {
            cell.img.image = img
        }
        //gonna fix in a minute
       // if(booking.ofMedicalService.)

        // Configure the cell...

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PatientViewBookingDetailsTableViewController, let selected = tableView.indexPathForSelectedRow {
            
            let selectedBooking: Booking
            switch selectedSegement {
            case 0: selectedBooking = activeBookings[selected.row]
            case 1: selectedBooking = completedBookings[selected.row]
            case 2: selectedBooking = cancelledBookings[selected.row]
            default: fatalError("invalid segment")
            }
            destination.booking = selectedBooking
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Update the list of bookings
        
        listOfBookings = AppData.bookings
        categorizeBookings()
        // Reload the table view
        tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //TODO: fix this later when you categorize
            confirmation(title: "Confirm Deletion", message: "If you delete this booking it will be automatically cancelled"){
                
                let bookingToRemove: Booking
                switch self.selectedSegement {
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
                    self.listOfBookings.remove(at: indexInAppData)
                }
                self.categorizeBookings()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            }
        }
    
    
    func categorizeBookings(){
        activeBookings = listOfBookings.filter{
            $0.status == .Active
        }
        completedBookings = listOfBookings.filter{
            $0.status == .Completed
        }
        cancelledBookings = listOfBookings.filter{
            $0.status == .Cancelled
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        listOfBookings = AppData.bookings
        categorizeBookings()
        tableView.reloadData()
    }
    
 

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
