//
//  LabBookingInfoTableViewController.swift
//  Mokhtabri
//
//  Created by Noora Qasim on 11/12/2023.
//

import UIKit

class LabBookingInfoTableViewController: UITableViewController {
    
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var btnContent: UIView!
    
    @IBOutlet weak var testName: UILabel!
    var cbooking : Booking?
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var patientInfo: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var patientCell: UITableViewCell!
    
    @IBOutlet weak var labInfoLabel: UILabel!
    @IBOutlet weak var patientCellContainer: UIView!
    
    
    func performUnwindSegue() {
           performSegue(withIdentifier: "showInfo", sender: self)
       }

    @IBAction func btnPress(_ sender: Any) {
        //call the confirmation
        confirmation(title: "Confirm Completion", message: "do you want to confirm the completion of \(cbooking?.ofMedicalService.name ?? "") test/package"){
            self.updateStatus()
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        //call the cancellation
        confirmation(title: "Confirm Cancellation", message: "do you want to confirm the cancellation of \(cbooking?.ofMedicalService.name ?? "") test/package"){
            self.updateStatus2()
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateData()
        updateView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateData()
        updateView()

    }

    // MARK: - Table view data source
  
    func updateData(){

        // take away optionals
        // make sure theres data
        guard let price = cbooking?.ofMedicalService.price, let status = cbooking?.status,let patientF = cbooking?.forPatient.firstName, let patientL = cbooking?.forPatient.lastName, let openb = cbooking?.ofMedicalService.forMedicalFacility.alwaysOpen, let city = cbooking?.ofMedicalService.forMedicalFacility.city, let date = cbooking?.bookingDate, let info = cbooking?.ofMedicalService.instructions else {
            return
        }
        
        let patientDescription = " Patient Full Name: \(patientF)  \(patientL)"
        var time = ""
        if (openb){
            time = "Always Open"
        }else{
            guard let startTime = cbooking?.ofMedicalService.forMedicalFacility.openingTime.hour,let closingTime = cbooking?.ofMedicalService.forMedicalFacility.closingTime.hour else {return}
            
                time = "Open From: \(startTime):00 until \(closingTime):00"
            
           
        }
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date2 = Calendar.current.date(from: date){
            dateString = dateFormatter.string(from: date2)
        }
            
        
        let bookingInfo = " \(city) branch\n \(time)\n Booking Date: \(dateString)\n Special Information: \(info)"
        
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
        
        //image is loaded on booking
        guard let img = cbooking?.ofMedicalService.photo else{
            return
        }
        image.image = img
        
    }
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    
    @IBOutlet weak var cancelbtnO: UIBarButtonItem!
   
    
    func updateStatus() {
        statusLabel.text = "Completed"
        cbooking?.status = .Completed
        btnContent.isHidden = true
        cancelbtnO.isHidden = true
        guard let cbooking = cbooking else { return }

        if let index = AppData.bookings.firstIndex(where: { $0.id == cbooking.id }) {
            AppData.bookings[index].status = .Completed
        }
        
        if let index = AppData.listOfBookingsLab.firstIndex(where: { $0.id == cbooking.id }) {
            AppData.listOfBookingsLab[index].status = .Completed
        }
        if let index = AppData.listOfBookingsPatient.firstIndex(where: { $0.id == cbooking.id }) {
            AppData.listOfBookingsPatient[index].status = .Completed
        }
        AppData.saveData()
    }

    func updateStatus2() {
        statusLabel.text = "Cancelled"
        cbooking?.status = .Cancelled
        btnContent.isHidden = true
        cancelbtnO.isHidden = true
        guard let cbooking = cbooking else { return }

        if let index = AppData.bookings.firstIndex(where: { $0.id == cbooking.id }) {
            AppData.bookings[index].status = .Cancelled
        }
        //cancels it in both lab and patient
        if let index = AppData.listOfBookingsLab.firstIndex(where: { $0.id == cbooking.id }) {
            AppData.listOfBookingsLab[index].status = .Cancelled
        }
        if let index = AppData.listOfBookingsPatient.firstIndex(where: { $0.id == cbooking.id }) {
            AppData.listOfBookingsPatient[index].status = .Cancelled
        }
        AppData.saveData()
    }
    
    
    func updateView(){
        if cbooking?.status == .Cancelled || cbooking?.status == .Completed{
            btnContent.isHidden = true
            cancelbtnO.isHidden = true
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
