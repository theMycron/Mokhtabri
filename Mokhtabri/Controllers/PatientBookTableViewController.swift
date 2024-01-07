//
//  PatientBookTableViewController.swift
//  Mokhtabri
//
//  Created by Noora Qasim on 19/12/2023.
//

import UIKit

class PatientBookTableViewController: UITableViewController {
    // declaring variables
    var loggedInPatient: Patient?
    @IBOutlet weak var image: UIImageView!
    var sampleTest : MedicalService?
    
    
    // declaring outlets
    @IBOutlet weak var btn: UIBarButtonItem!
    @IBOutlet weak var hospitalName: UILabel!
    
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var testName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var branch: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.isHidden = false
        updateView()
        loggedInPatient = AppData.patient1
        guard AppData.loggedInUser != nil else{
            return
        }
        loggedInPatient =  AppData.patients.filter{$0.username == AppData.loggedInUser?.username}[0]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    // updates data
    func updateView(){
        guard let sampleTest = sampleTest else{
            return
        }
        branch.text = "\(sampleTest.forMedicalFacility.city)"
        price.text = "\(sampleTest.price) BHD"
        hospitalName.text = "\(sampleTest.forMedicalFacility.name)"
        testName.text = "\(sampleTest.name)"
        datePicker.date = Date()
        if sampleTest is Test{
            updateDes()
        }else{
            updateDes2()
        }
        guard let img1 = sampleTest.photo else {
            return
        }
        image.image = img1
    }

    // handles the booking
    @IBAction func bookClicked(_ sender: Any) {
        guard let sampleTest = sampleTest else {
            return
        }
        guard let loggedInPatient = loggedInPatient else{
            return
        }
        let selectedDate = datePicker.date
            let currentDate = Date()
        if selectedDate >= currentDate{
            confirmation(title: "Confirm Booking", message: "Do you want to confirm your booking of the \(sampleTest.name) test/package"){
                let calendar = Calendar.current
                let selectedDateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
                let newBooking = Booking(forPatient: loggedInPatient, ofMedicalService: sampleTest, bookingDate: selectedDateComponents)
                
                AppData.bookings.append(newBooking)
                AppData.listOfBookingsLab.append(newBooking)
                AppData.listOfBookingsPatient.append(newBooking)
                AppData.saveData()
                
                self.errorAlert(title: "Booking Successful", message: "The service you selected has been successfully booked.")
            }
        }else{
            confirmation(title: "Invalid", message: "Please select Valid Date"){
                
            }
        }
    }
    
    func updateDes(){
        guard let sampleTest = sampleTest else {
            return
        }
        Description.text = "Special Instructions:\(sampleTest.instructions)"
    }
    
    func updateDes2(){
        guard let sampleTest = sampleTest else {
            return
        }
        let package = sampleTest as! Package
            var tests = ""
        for t in package.tests {
            tests += "-\(t.name)\n"
        }
            Description.text = "Special Instructions: \(sampleTest.instructions)\nTests Included:\n\(tests)"
        }
}
