//
//  PatientViewBookingDetailsTableViewController.swift
//  Mokhtabri
//
//  Created by Noora Qasim on 17/12/2023.
//

import UIKit

class PatientViewBookingDetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var images: UIImageView!
    @IBOutlet weak var celltrial: PatientInfoTableViewCell!
    var booking : Booking?
    @IBOutlet weak var info: UILabel!
    
    @IBOutlet weak var btn: UIBarButtonItem!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var testName: UILabel!
    @IBOutlet weak var status: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        checkBtn()

        

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
        return 4
    }
    func updateView(){
        guard let stat = booking?.status, let tname = booking?.ofMedicalService.name, let tprice = booking?.ofMedicalService.price  else {
            return
        }
        status.text = "\(stat)"
        testName.text = tname
        price.text = "\(tprice) BHD"
        let testorPackage = booking?.ofMedicalService
        if testorPackage is Test{
            updateTest()
        }else {
            updatePackage()
        }
    }
    
    func updateTest(){
        guard let year = booking?.bookingDate.year,let month = booking?.bookingDate.month, let day = booking?.bookingDate.day, let branch = booking?.ofMedicalService.forMedicalFacility.city, let specialInfo = booking?.ofMedicalService.instructions else {
            return
        }
        info.text = "\(branch) branch\nBooking Date: \(day)-\(month)-\(year)\nSpecial Information: \(specialInfo)"
        
        guard let img = booking?.ofMedicalService.photo else {
            return
        }
        images.image = img
    }
    
    func updatePackage(){
        guard let year = booking?.bookingDate.year,let month = booking?.bookingDate.month, let day = booking?.bookingDate.day, let branch = booking?.ofMedicalService.forMedicalFacility.city, let specialInfo = booking?.ofMedicalService.instructions else {
            return
        }
        let package = booking?.ofMedicalService as! Package
        let packageTests = package.tests
        var list = ""
        for test in packageTests {
            list += "-\(test.name)\n"
        }
        info.text = "\(branch) branch\nBooking Date: \(day)-\(month)-\(year)\nSpecial Information: \(specialInfo)\n Tests Included:\n\(list) "
        guard let img = booking?.ofMedicalService.photo else {
            return
        }
        images.image = img
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        confirmation(title: "Confirm Cancellation", message: "Do you want to confirm the cancellation of your \(booking?.ofMedicalService.name ?? "") booking?"){
            guard let booking = self.booking else{
                return
            }
            booking.status = .Cancelled
            for bookin in AppData.bookings {
                if bookin.id == self.booking?.id{
                    bookin.status = .Cancelled
                }
            }
            self.checkBtn()
            self.status.text = "\(booking.status)"
            
            for bookin in AppData.listOfBookingsLab{
                if bookin.id == booking.id{
                    bookin.status = .Cancelled
                }
            }
            
            for bookin in AppData.listOfBookingsPatient{
                if bookin.id == booking.id{
                    bookin.status = .Cancelled
                }
            }
            AppData.saveData()
        }
        

    
    }
    
    func checkBtn(){
        guard let stat = booking?.status else {
            return
        }
        if stat == .Active{
            btn.isHidden = false
        }else{
            btn.isHidden = true
        }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
