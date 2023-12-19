//
//  PatientHospitalSelectTableViewController.swift
//  Mokhtabri
//
//  Created by Fatema Ahmed Ebrahim Mohamed Naser on 19/12/2023.
//

import UIKit

class PatientHospitalSelectTableViewController: UITableViewController {
    
    
    // declare variables
    var selectedHospital: MedicalFacility?
    var listOfTests: [MedicalService]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 160
            }
        }
        return 96
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 2
        }else {
            return listOfTests?.count ?? 1
        }
    }
    
    func loadData() {
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PatientBooking", for: indexPath) as! PatientBookingTableViewCell
            cell.TestName.text = "ay"
            return cell
        }else {
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "infocell", for: indexPath) as! PatientViewInfoTableViewCell
                cell.info.text = "hello"
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "imagecell", for: indexPath) as! imgTableViewCell
                cell.img.image = UIImage(named: "AlHilal")
                cell.img.frame = CGRect(x: 76, y: 0, width: 201, height: 158)
                //self.view.addSubview(cell.img)
                
                return cell
            }
            
            
        }
        
        
        
        // Configure the cell...
        
        
        
        //return cell
        
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
    

}
