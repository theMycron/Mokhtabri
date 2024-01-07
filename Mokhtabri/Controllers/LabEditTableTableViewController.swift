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
    var listOfTests: [Test] = []
    
    init?(coder: NSCoder, service: MedicalService?) {
        self.service = service
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
        
        let s1 = AppData.loadPicture(medic: service)
        guard let img = s1.photo else {
            return
        }
        imgDisplay.image = img
        
        if service is Test{
            let test: Test = service as! Test
            txtCategory.text = test.category
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
    
    // when returning from select tests
    @IBAction func unwindFromSelect(unwindSegue: UIStoryboardSegue){
        guard let source = unwindSegue.source as? LabSelectTestsTableViewController
        else {return}
        madeChanges()
        let selectedTests: [Test] = source.selectedTests
        listOfTests = selectedTests
    }
    
    // go to select tests only as package
    @IBSegueAction func selectTestSegue(_ coder: NSCoder) -> LabSelectTestsTableViewController? {
        let package: Package? = service as? Package
        return LabSelectTestsTableViewController(coder: coder, package: package)
    }
    

    // hide and unhide test/package specific cell when
    @IBAction func segmetedSelect(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            DateExpiry.isHidden = true
            txtPhone.isHidden = false
            txtName.isHidden = false
            viewselecter.isHidden = true
        case 1 :
            DateExpiry.isHidden = false
            txtPhone.isHidden = false
            txtName.isHidden = false
            viewselecter.isHidden = false
            
        default:
            break
        }
        updateCells()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if service is Package{
            viewselecter.isHidden = false
            DateExpiry.isHidden = false
        }
        if service is Test{
            viewselecter.isHidden = true
            DateExpiry.isHidden = true
        }
        tableView.reloadData()
        // this delegate will control the sheet, and will stop the user from dismissing if changes were made
        presentationController?.delegate = self
        updateView()
        

    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        // dismiss modal without saving
        performSegue(withIdentifier: "unwindToView", sender: self)
    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
        // create new service and save, show alert if data is invalid
        // TODO: implement input validation
        var oldId: UUID?
        
        let name: String? = txtName.text
        let price: Float? = Float(txtPhone.text ?? "")
        let description :String? = txtDescription.text
        let instructions :String? = txtInstruction.text
        let category: String? = txtCategory.text
        let expiryDate: Date = DateExpiry.date
        let expiryDateComponents: DateComponents = Calendar.current.dateComponents(in: Calendar.current.timeZone, from: expiryDate)
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
        
        
        if let service = service {
            oldId = service.id
        }
        // create service based on type
        if (selectedServiceType == .test) {
            service = Test(category: category!,name: name ?? "", price: price ?? 0.0 , description: description ?? "", instructions: instructions ?? "", forMedicalFacility: AppData.loggedInUser as! MedicalFacility, serviceType : selectedServiceType!, storageLink: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/testImages%2Frbc-alsalam.jpeg?alt=media&token=71a9c05b-52fb-4b26-a2f9-b78c2604bca1") )
        } else if (selectedServiceType == .package) {
            service = Package(expiryDate: expiryDateComponents, tests: listOfTests,name: name ?? "", price: price ?? 0.0 , description: description ?? "", instructions: instructions ?? "", forMedicalFacility: AppData.loggedInUser as! MedicalFacility, serviceType : selectedServiceType!, storageLink: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/testImages%2Frbc-alsalam.jpeg?alt=media&token=71a9c05b-52fb-4b26-a2f9-b78c2604bca1")!)
            _=uploadImageToFirebase()
        }
        
        
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
        // used to update
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source

    //this function hides views that are not needed between package and test page
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // remove "select tests" cell if editing test
        if indexPath.section == 1 && (indexPath.row == 4) {
            return (segmentedControl.selectedSegmentIndex == 0) ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        }
       // remove "category" cell if editing package
        if indexPath.section == 1 && (indexPath.row == 3) {
            return (segmentedControl.selectedSegmentIndex == 1) ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        }
       // remove expiry date when editing test
       if indexPath.section == 3  {
           return (segmentedControl.selectedSegmentIndex == 0) ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
       }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    // called when changes are made to enable save button
    @IBAction func madeChanges() {
        hasChanges = true
        isModalInPresentation = hasChanges
        btnSave.isEnabled = hasChanges
    }
    
    
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
                // no errors, add imagePath to service
                storageRef.downloadURL(completion: { result in
                   switch result {
                   case .failure( _):
                       let alert = UIAlertController(title: "Image Upload Failed", message: "The image could not be uploaded to the server.", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "OK", style: .default))
                       self.present(alert, animated: true)
                   case .success(let url):
                       guard self.service != nil else {return}
                       self.service!.storageLink = url
                           // update service in appdata
                       AppData.editService(service: self.service!)
                       
                   }
                })
            }
        }
        
        return true
    }
    
    func getImageFromFirebase() {
        guard let service: Package = service as? Package,
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
