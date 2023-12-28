//
//  LabEditTableTableViewController.swift
//  Mokhtabri
//
//  Created by Ali Husain Ateya Ali Abdulrasool on 22/12/2023.
//

import UIKit

class LabEditTableTableViewController: UITableViewController, UIAdaptivePresentationControllerDelegate {

    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var imgDisplay: UIImageView!
    
    @IBOutlet weak var txtDescription: UITextField!
    
    @IBOutlet weak var txtInstruction: UITextField!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var DateExpiry: UIDatePicker!
    
    @IBOutlet weak var cellSelect: UITableViewCell!
    
    @IBOutlet weak var cellCategory: UITableViewCell!
    
    @IBOutlet weak var viewselecter: UITableViewCell!
    
    
    var service: MedicalService?
    
    var hasChanges: Bool = false
    
    init?(coder: NSCoder, facility: MedicalService?) {
        self.service = facility
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.service = nil
        super.init(coder: coder)
    }
    
    func updateView() {
        guard let service = service else {return}
        txtName.text = service.name
        txtPhone.text = "\(service.price)"
        txtDescription.text = description
        txtDescription.text = service.serviceDescription
        txtInstruction.text = service.instructions
     
    }
    
    


    
    @IBAction func segmetedSelect(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            DateExpiry.isHidden = true
            cellSelect.isHidden = true
            txtPhone.isHidden = false
            txtName.isHidden = false
            viewselecter.isHidden = true
        case 1 :
            DateExpiry.isHidden = false
            cellSelect.isHidden = false
            txtPhone.isHidden = false
            txtName.isHidden = false
            viewselecter.isHidden = false
            
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewselecter.isHidden = true
        DateExpiry.isHidden = true
        cellSelect.isHidden = true
        tableView.reloadData()
        // this delegate will control the sheet, and will stop the user from dismissing if changes were made
        navigationController?.presentationController?.delegate = self
        updateView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        // dismiss modal without saving
        performSegue(withIdentifier: "unwindToView", sender: self)
    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
        // create new facility and save, show alert if data is invalid
        // TODO: implement input validation
        var oldId: UUID?
        
        let name: String? = txtName.text
        let price: Float? = Float(txtPhone.text ?? "")
        let description :String? = txtDescription.text
        let instructions :String? = txtInstruction.text
        var selectedServiceType: MedicalService.ServiceType? {
           switch segmentedControl.selectedSegmentIndex {
           case 0:
               return .test
           case 1:
               return .package
           default:
               return nil
           }
        }
        // TODO: add image as well
        
        
        //i Changed price type from Float to String
        if let facility = service {
            oldId = facility.id
        }
        service = MedicalService(name: name ?? "", price: price ?? 0.0 , description: description ?? "", instructions: instructions ?? "", forMedicalFacility: AppData.alhilal, serviceType : selectedServiceType! )
        
        
        if let oldId = oldId {
            service!.id = oldId
        }
        performSegue(withIdentifier: "unwindToView", sender: self)
        
    }
    
    @IBAction func btnAddPhotoPressed(_ sender: Any) {
        
    }
    
    @IBAction func toggleChanged(_ sender: Any) {
        updateCells()
        madeChanges()
    }
    
    func updateCells() {
        // used to update opening time and closing time cells when 24 hour is enabled
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source

  /*  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // hide opening time and closing time cells if facility is initially set to always open
        if indexPath.section == 2 && (indexPath.row == 1 || indexPath.row == 2) {
            return toggleAlwaysOpen.isOn ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    */
    
    @IBAction func madeChanges() {
        hasChanges = true
        isModalInPresentation = hasChanges
        btnSave.isEnabled = hasChanges
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
