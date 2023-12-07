//
//  LoginViewController.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 04/12/2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    
    var appData: AppData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        guard let appData = AppData.loadData() else {
//            displayLabel.text = "Not loaded."
//            return
//        }
//        
//        displayLabel.text = appData.patients.description
        
    }
    
    @IBAction func loadButton(_ sender: Any) {
        guard let appData = AppData.loadData() else {
            displayLabel.text = "Cant load :((("
            return
        }
        
        displayLabel.text = appData.patients.description
    }
    
    @IBAction func createButton(_ sender: Any) {
        appData = AppData(admin: User(username: "hfeuios", password: "fejsiuo", userType: UserType.admin), patients: [], facilities: [], bookings: [])
        var dob: DateComponents = DateComponents()
        dob.year = 2003
        dob.month = 12
        dob.day = 7
        appData!.patients.append(Patient(firstName: "Ali", lastName: "Mohammed", phone: "3892999", cpr: "38991993", email: "ahsjk@hf.djo", gender: Gender.male, dateOfBirth: dob, username: "windhh", password: "hunter2"))
        appData!.patients.append(Patient(firstName: "Salem", lastName: "Maki", phone: "3892999", cpr: "38991993", email: "ahsjk@hf.djo", gender: Gender.male, dateOfBirth: dob, username: "windhh", password: "hunter2"))
        
        displayLabel.text = "\(appData!.patients.description) \nHas been made."
        
        AppData.saveData(data: appData!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
