//
//  PatientBookTableViewController.swift
//  Mokhtabri
//
//  Created by Nooni on 19/12/2023.
//

import UIKit

class PatientBookTableViewController: UITableViewController {
    var sampleTest = Test(category: Category(name: "Blood Test"), name: "VitaminB12", price: 10, description: "blood test for vitaminb12", instructions: "fasting 8-12 hours prior is mandatory", forMedicalFacility:  MedicalFacility(name: "Al Hilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: false, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "AlHihalEastRiffa", password: "alhilal"))
    
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
        return 6
    }
    
    func updateView(){
        branch.text = "\(sampleTest.forMedicalFacility.city)"
        price.text = "\(sampleTest.price) BHD"
        hospitalName.text = "\(sampleTest.forMedicalFacility.name)"
        testName.text = "\(sampleTest.name)"
        datePicker.date = Date()
        Description.text = "Special Instructions:\(sampleTest.instructions)"
    }

    @IBAction func bookClicked(_ sender: Any) {
        let selectedDate = datePicker.date
            let currentDate = Date()
        if selectedDate >= currentDate{
            confirmation(title: "Confirm Booking", message: "Do you want to confirm your booking of the \(sampleTest.name) test/package"){
                
            }
        }else{
            confirmation(title: "Invalid", message: "Please select Valid Date"){
                
            }
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
