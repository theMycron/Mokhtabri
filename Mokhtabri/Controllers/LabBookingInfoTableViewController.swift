//
//  LabBookingInfoTableViewController.swift
//  Mokhtabri
//
//  Created by Nooni on 11/12/2023.
//

import UIKit

class LabBookingInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var testName: UILabel!
    var cbooking : Booking?
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var patientInfo: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var patientCell: UITableViewCell!
    
    @IBOutlet weak var labInfoLabel: UILabel!
    @IBOutlet weak var patientCellContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
        updateView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
  
    func updateData(){
        
        guard let price = cbooking?.ofMedicalService.price, let status = cbooking?.status,let patientF = cbooking?.forPatient.firstName, let patientL = cbooking?.forPatient.lastName, let openb = cbooking?.ofMedicalService.forMedicalFacility.alwaysOpen, let iden = cbooking?.forPatient.cpr, let phone = cbooking?.forPatient.phone, let city = cbooking?.ofMedicalService.forMedicalFacility.city else {
            return
        }
        
        var patientDescription = "Patient Full Name: \(patientF)  \(patientL) \nPatient Identification Number: \(iden) \nPatient Mobile Number: \(phone)"
        var time = ""
        if (openb){
            time = "Always Open"
        }else{
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            guard let startTime = cbooking?.ofMedicalService.forMedicalFacility.openingTime.hour,let closingTime = cbooking?.ofMedicalService.forMedicalFacility.closingTime.hour else {return}
            
                time = "Open From: \(startTime):00 until \(closingTime):00"
            
           
        }
        var bookingInfo = "\(city) branch\n\(time)"
        
        labInfoLabel.text = bookingInfo
        
        testName.text = cbooking?.ofMedicalService.name
        
       
        patientInfo.text = patientDescription

        statusLabel.text = "\(status)"
        let format = NumberFormatter()
        format.numberStyle = .currency
        format.maximumFractionDigits = 2
        format.locale = Locale(identifier: "en_BH")
        if let priceString = format.string(from: NSNumber(value: price)) {
            priceLabel.text = "\(priceString)"
        }
        
        
    }
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    
    func updateView(){
        
        patientCellContainer.layer.cornerRadius = 10
        patientCellContainer.layer.masksToBounds = true
        patientCellContainer.backgroundColor = UIColor.blue.withAlphaComponent(0.08)
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
