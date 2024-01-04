//
//  LabEditTableTableViewController.swift
//  Mokhtabri
//
//  Created by Ali Husain Ateya Ali Abdulrasool on 22/12/2023.
//

import UIKit
import FirebaseStorage

class LabEditTableTableViewController: UITableViewController, UIAdaptivePresentationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    @IBOutlet weak var txtCategory: UITextField!
    
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
        
        if service is Test{
            let test: Test = service as! Test
            txtCategory.text = test.category.name
            segmentedControl.selectedSegmentIndex = 0
        }
        if service is Package{
            let package: Package = service as! Package
            if let expiryDateComponents = package.expiryDate {
               let date = Calendar.current.date(from: expiryDateComponents)
                DateExpiry.date = date ?? date!
                getImageFromFirebase()
                segmentedControl.selectedSegmentIndex = 1
            }
            
        }
     
    }
    
    


    
    @IBAction func segmetedSelect(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            DateExpiry.isHidden = true
            //cellSelect.isHidden = true
            txtPhone.isHidden = false
            txtName.isHidden = false
            viewselecter.isHidden = true
//            cellCategory.isHidden = false
        case 1 :
            DateExpiry.isHidden = false
           // cellSelect.isHidden = false
            txtPhone.isHidden = false
            txtName.isHidden = false
            viewselecter.isHidden = false
//            cellCategory.isHidden = true
            
        default:
            break
        }
        updateCells()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewselecter.isHidden = true
        DateExpiry.isHidden = true
        //cellSelect.isHidden = true
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
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBSegueAction func selectTestsSegue(_ coder: NSCoder) -> LabSelectTestsTableViewController? {
        return LabSelectTestsTableViewController(coder: coder )
    }
    
    func updateCells() {
        // used to update opening time and closing time cells when 24 hour is enabled
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source

   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // hide opening time and closing time cells if facility is initially set to always open
        if indexPath.section == 1 && (indexPath.row == 4) {
            return (segmentedControl.selectedSegmentIndex == 0) ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        }
        if indexPath.section == 1 && (indexPath.row == 3) {
            return (segmentedControl.selectedSegmentIndex == 1) ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        }
       if indexPath.section == 0  {
           return (segmentedControl.selectedSegmentIndex == 0) ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
       }
       if indexPath.section == 3  {
           return (segmentedControl.selectedSegmentIndex == 0) ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
       }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    
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
    
    func uploadImageToFirebase() -> Bool {
        // display warning if no image was selected, can proceed with no image
        var cancelled: Bool = false
        if let image = imgDisplay.image,
           image.isEqual(UIImage(named: "noPhoto")){
            let alert = UIAlertController(title: "Missing Image", message: "Are you sure you want to save without an image?", preferredStyle: .alert)
            // if user wants to add image, cancel upload
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
                cancelled = true
            }))
            // if user wants to continue without image, cancel upload and consider it successful
            alert.addAction(UIAlertAction(title: "Continue", style: .default))
            self.present(alert, animated: true)
            if cancelled {
                return false
            }
            return true
        }
        // dont continue if user wants to choose image
        
        // get selected image and upload to firebase
        guard let image = imgDisplay.image?.jpegData(compressionQuality: 0.9) else {return false}
        // format filename with lowercased letters and underscores instead of spaces
        let filename = service!.defaultFirebaseImageFilename
        
        let storageRef = Storage.storage().reference().child(filename)
        // upload image
        // This function is ASYNCRONOUS, which means it may take time to upload while the app continues running
        _ = storageRef.putData(image) {(metadata, error) in
            if error != nil {
                // handle errors
                let alert = UIAlertController(title: "Image Upload Failed", message: "The image could not be uploaded to the server.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } else {
                // no errors, add imagePath to facility
                storageRef.downloadURL(completion: {(url, error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Image Upload Failed", message: "The image could not be uploaded to the server.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    } else if let downloadURL = url {
                        self.service!.imageDownloadURL = downloadURL
                        // update facility in appdata
                        AppData.editService(service: self.service!)
                    }
                })
            }
        }
        
        return true
    }
    
    func getImageFromFirebase() {
        guard let service = service,
                let downloadURL = service.imageDownloadURL else {return}
        // Use KingFisher library to store and cache the image
        imgDisplay.kf.indicatorType = .activity
        imgDisplay.kf.setImage(with: downloadURL)
    }
    
    func showImagePickerOptions() {
        let alert = UIAlertController(title: "Select Image", message: "Select image from library or capture from camera", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
            guard let self = self else {return}
            let cameraPicker = self.imagePicker(sourceType: .camera)
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true)
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] (action) in
            guard let self = self else {return}
            let libraryPicker = self.imagePicker(sourceType: .photoLibrary)
            libraryPicker.delegate = self
            self.present(libraryPicker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as!UIImage
        imgDisplay.image = image
        madeChanges()
        self.dismiss(animated: true)
    }

}
