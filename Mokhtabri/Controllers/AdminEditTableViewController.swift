//
//  AdminEditTableViewController.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 12/12/2023.
//

import UIKit

class AdminEditTableViewController: UITableViewController {

    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtCity: UITextField!
    
    @IBOutlet weak var txtWebsite: UITextField!
    
    @IBOutlet weak var segmentType: UISegmentedControl!
    
    @IBOutlet weak var toggleAlwaysOpen: UISwitch!
    
    @IBOutlet weak var timeOpening: UIDatePicker!
    
    @IBOutlet weak var timeClosing: UIDatePicker!
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtConfirm: UITextField!
    
    @IBOutlet weak var imgDisplay: UIImageView!
    
    @IBOutlet weak var openingTimeCell: UITableViewCell!
    
    @IBOutlet weak var closingTimeCell: UITableViewCell!
    
    var facility: MedicalFacility?
    
    init?(coder: NSCoder, facility: MedicalFacility?) {
        self.facility = facility
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.facility = nil
        super.init(coder: coder)
    }
    
    func updateView() {
        guard let facility = facility else {return}
        txtName.text = facility.name
        txtPhone.text = facility.phone
        txtCity.text = facility.city
        txtWebsite.text = facility.website
        if facility.type == FacilityType.hospital {
            segmentType.selectedSegmentIndex = 0
        } else {
            segmentType.selectedSegmentIndex = 1
        }
        
        toggleAlwaysOpen.isOn = facility.alwaysOpen
        tableView.reloadSections([4], with: .automatic)
        if !facility.alwaysOpen {
            let calendar = Calendar.current
            let openingComponents: DateComponents = facility.openingTime
            let closingComponents: DateComponents = facility.closingTime
            timeOpening.date = calendar.date(from: openingComponents)!
            timeClosing.date = calendar.date(from: closingComponents)!
        }
        txtUsername.text = facility.username
        txtPassword.text = facility.password
        txtConfirm.text = facility.password
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func btnCancelPressed(_ sender: Any) {
        // dismiss modal without saving
        dismiss(animated: true)
    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
        // create new facility and save, show alert if data is invalid
        // TODO: implement input validation
        
        let name: String? = txtName.text
        let phone: String? = txtPhone.text
        let city: String? = txtCity.text
        let website: String? = txtWebsite.text
        let type: FacilityType = segmentType.selectedSegmentIndex == 0 ? FacilityType.hospital : FacilityType.lab
        let alwaysopen: Bool = toggleAlwaysOpen.isOn
        
        let calendar = Calendar.current
        let openingTimeRaw: Date = timeOpening.date
        var openingTime: DateComponents = DateComponents()
        openingTime = calendar.dateComponents(in: calendar.timeZone, from: openingTimeRaw)
        let closingTimeRaw: Date = timeClosing.date
        var closingTime: DateComponents = DateComponents()
        closingTime = calendar.dateComponents(in: calendar.timeZone, from: closingTimeRaw)
        
        let username: String? = txtUsername.text
        let password: String? = txtPassword.text
        let confirm: String? = txtConfirm.text
        guard password == confirm else {
            // throw error if not matching
            return
        }
        // TODO: add image as well
        facility = MedicalFacility(name: name ?? "", phone: phone ?? "", city: city ?? "", website: website ?? "", alwaysOpen: alwaysopen, type: type, openingTime: openingTime, closingTime: closingTime, username: username ?? "", password: password ?? "")
        // if facility was created successfully, add to appdata and save
        AppData.facilities.append(facility!)
        AppData.saveData()
        performSegue(withIdentifier: "unwindToView", sender: self)
        
    }
    
    @IBAction func btnAddPhotoPressed(_ sender: Any) {
        
    }
    
    @IBAction func toggleChanged(_ sender: Any) {
//        tableView.reloadRows(at: [IndexPath(row: 1, section: 2), IndexPath(row: 2, section: 2)], with: .automatic)
        tableView.reloadSections([4], with: .automatic)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.cellForRow(at: indexPath)
        if cell == self.openingTimeCell || cell == self.closingTimeCell {
            print(toggleAlwaysOpen.isOn ? 0 : super.tableView(tableView, heightForRowAt: indexPath))
            return toggleAlwaysOpen.isOn ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 4
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
