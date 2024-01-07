//
//  AdminEditTableViewController.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 12/12/2023.
//

import UIKit
import FirebaseStorage
import Kingfisher
import FirebaseAuth
import Firebase

class AdminEditTableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var btnSave: UIBarButtonItem!
    
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
    
    var hasChanges: Bool = false
    
    init?(coder: NSCoder, facility: MedicalFacility?) {
        self.facility = facility
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.facility = nil
        super.init(coder: coder)
    }
    
    
    // fills input fields based on selected facility (when editing a facility)
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
        print(toggleAlwaysOpen.isOn)
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
        
        // disable email field as it cannot be changed
        txtUsername.isEnabled = false
        
        // load image
        getImageFromFirebase()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // this delegate will control the sheet, and will stop the user from dismissing if changes were made
        presentationController?.delegate = self
        updateView()
    }
    

    @IBAction func btnCancelPressed(_ sender: Any) {
        // dismiss modal without saving
        performSegue(withIdentifier: "unwindToView", sender: self)
    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
        validateImage()
        // validate fields and save
        // do not continue if there was an invalid input
        proceedWithImage()
    }
    
    func proceedWithImage() {
        
        guard validateFields() else {
            return
        }
        
        performSegue(withIdentifier: "unwindToView", sender: self)
    }
    
    func validateImage() {
        // display warning if no image was selected, can proceed with no image
        if imgDisplay.image == nil {
            let alert = UIAlertController(title: "Missing Image", message: "Are you sure you want to save without an image?", preferredStyle: .alert)
            // if user wants to add image, cancel upload
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            // if user wants to continue without image, cancel upload and consider it successful
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
                self.proceedWithImage()
            }))
            self.present(alert, animated: true)
        }
    }
    
    func displayError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func validateFields() -> Bool {
        // create new facility and save, show alert if data is invalid
        var oldId: UUID?
        
        guard let name: String = txtName.text,
              !name.isEmpty else {
            displayError(title: "Missing Name", message: "Please enter a name.")
            return false
        }
        
        guard let phone: String = txtPhone.text,
              !phone.isEmpty else {
            displayError(title: "Missing Phone Number", message: "Please enter a phone number.")
            return false
        }
        guard let city: String = txtCity.text,
              !city.isEmpty else {
            displayError(title: "Missing City", message: "Please enter a city.")
            return false
        }
        guard let website: String = txtWebsite.text,
            !website.isEmpty else {
            displayError(title: "Missing Website", message: "Please enter a website.")
            return false
        }
        let type: FacilityType = segmentType.selectedSegmentIndex == 0 ? FacilityType.hospital : FacilityType.lab
        let alwaysopen: Bool = toggleAlwaysOpen.isOn
        
        let calendar = Calendar.current
        let openingTimeRaw: Date = timeOpening.date
        var openingTime: DateComponents = DateComponents()
        openingTime = calendar.dateComponents(in: calendar.timeZone, from: openingTimeRaw)
        let closingTimeRaw: Date = timeClosing.date
        var closingTime: DateComponents = DateComponents()
        closingTime = calendar.dateComponents(in: calendar.timeZone, from: closingTimeRaw)
        
        guard let username: String = txtUsername.text,
              !username.isEmpty else {
            displayError(title: "Missing Email", message: "Please enter an email.")
            return false
        }
        // check if email is valid format
        let emailRegex = "[A-Za-z0-9._%+-]+@mokhtabri\\.com"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: username) else {
            displayError(title: "Invalid Email", message: "Please enter a valid email address for the facility (ending in @mokhtabri.com)")
            return false
        }
        // check if email already in use
        if let usedEmail = AppData.getUserFromEmail(email: username)?.username  {
            // dont mind if it is the same as the facility's current email
            if (usedEmail != facility?.username) {
                displayError(title: "Email In Use", message: "The email you entered is being used by another user. Please try a different email.")
                return false
            }
        }
        
        guard let password: String = txtPassword.text,
              !password.isEmpty else {
            displayError(title: "Missing Password", message: "Please enter a password.")
            return false
        }
        guard password.count >= 8 else {
            displayError(title: "Invalid Password", message: "Please enter a password with at least 8 characters.")
            return false
        }
        
        guard let confirm: String = txtConfirm.text,
              password == confirm else {
            // throw error if not matching
            displayError(title: "Passwords Not Matching", message: "Please re-enter your passwords and make sure they match.")
            return false
        }
        
        
        
        // if editing an existing facility, save id to replace it later
        if let facility = facility {
            oldId = facility.uuid
            
            // update password if it was changed
            let currentUser = Auth.auth().currentUser
            if (password != facility.password) {
                currentUser?.updatePassword(to: password) {error in
                    if error != nil {
                        print("Error while updating user password: \(String(describing: error))")
                    }
                }
            }
        }
        facility = MedicalFacility(name: name, phone: phone, city: city, website: website, alwaysOpen: alwaysopen, type: type, openingTime: openingTime, closingTime: closingTime, image: facility?.imageDownloadURL, username: username, password: password)
        if let oldId = oldId {
            facility!.uuid = oldId // replace new uuid with old one if editing to ensure they are the same facility
            
        } else {
            //if this is a new facility, add to firebase
            Auth.auth().createUser(withEmail: username, password: password) { (authResult, error) in
                //check the auth result to make sure that the user is created
                guard let _ = authResult?.user, error == nil else{
                    //if user is not created, display the error.
                    print("Error \(String(describing: error?.localizedDescription))")
                    return
                }
            }
        }
        
        // upload image
        if !uploadImageToFirebase() {
            return false
        }
        return true
    }
    
    
    @IBAction func btnAddPhotoPressed(_ sender: Any) {
        showImagePickerOptions()
    }
    
    
    func uploadImageToFirebase() -> Bool {
        
        // get selected image and upload to firebase
        guard let image = imgDisplay.image?.jpegData(compressionQuality: 0.9) else {return true}
        // format filename with lowercased letters and underscores instead of spaces
        let filename = facility!.defaultFirebaseImageFilename
        
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
                        self.facility!.imageDownloadURL = downloadURL
                        // update facility in appdata
                        AppData.editUser(user: self.facility!)
                    }
                })
            }
        }
        
        return true
    }
    
    func getImageFromFirebase() {
        guard let facility = facility,
                let downloadURL = facility.imageDownloadURL else {return}
        // Use KingFisher library to store and cache the image
        imgDisplay.kf.indicatorType = .activity
        imgDisplay.kf.setImage(with: downloadURL)
    }
    
    func showImagePickerOptions() {
        let alert = UIAlertController(title: "Select Image", message: "Select image from library or capture from camera", preferredStyle: .actionSheet)
        // camera causes a crash using simulator, disabled now
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // hide opening time and closing time cells if facility is initially set to always open
        if indexPath.section == 2 && (indexPath.row == 1 || indexPath.row == 2) {
            return toggleAlwaysOpen.isOn ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    
    @IBAction func madeChanges() {
        hasChanges = true
        isModalInPresentation = hasChanges
        btnSave.isEnabled = hasChanges
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

extension AdminEditTableViewController: UIAdaptivePresentationControllerDelegate {
    
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Discard Changes", style: .destructive) { _ in
            self.performSegue(withIdentifier: "unwindToView", sender: self)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        
        self.present(alert, animated: true, completion: nil)
    }
}

