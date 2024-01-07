//
//  LabSelectTestsTableViewController.swift
//  Mokhtabri
//
//  Created by Ali Husain Ateya Ali Abdulrasool on 31/12/2023.
//

import UIKit
import SwiftUI

class LabSelectTestsTableViewController: UITableViewController, UIAdaptivePresentationControllerDelegate {
    var selectedRows = Set<Int>()
    var package: Package?
    var selectedTests: [Test] = []
    let facility: MedicalFacility = AppData.loggedInUser as! MedicalFacility
    init?(coder: NSCoder, package: Package?) {
        self.package = package

        
        displayedTests = []
        super.init(coder: coder)
        displayedTests = AppData.tests.filter{$0.forMedicalFacility == self.facility}
        
        if let package = package {
            selectedTests = package.tests
            guard selectedTests.count > 0 else {return}
            for i in 0...selectedTests.count-1{
                if displayedTests.contains(selectedTests[i]) {
                    selectedRows.insert(displayedTests.firstIndex(of: selectedTests[i])!)
                }
            }
        }
        
    }
    required init?(coder: NSCoder) {
        displayedTests = []
        
        displayedTests = []
        super.init(coder: coder)
        displayedTests = AppData.tests.filter{$0.forMedicalFacility == self.facility}
    }
    


    
    
    var displayedTests: [Test]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentationController?.delegate = self
        isModalInPresentation = true
            tableView.allowsMultipleSelection = true
            tableView.allowsMultipleSelectionDuringEditing = true
        for row in selectedRows {
               tableView.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: .none)
           }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.performSegue(withIdentifier: "unwindFromSelect", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return displayedTests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as! LabSelectTestTableViewCell

       let test: Test = displayedTests[indexPath.row]
       cell.update(with: test)

       if selectedRows.contains(indexPath.row) {
           // Update the cell's appearance to indicate it's selected
       
           cell.isSelected = true
       } else {
           // Update the cell's appearance to indicate it's not selected
         
           cell.isSelected = false
       }

       return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRows.insert(indexPath.row)
        selectedTests.append(displayedTests[indexPath.row])
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedRows.remove(indexPath.row)
        selectedTests.remove(at: selectedTests.firstIndex(of: displayedTests[indexPath.row])!)
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
