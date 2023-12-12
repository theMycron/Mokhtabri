//
//  LoginViewController.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 04/12/2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    
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
        AppData.loadData()
        guard AppData.facilities.count > 0 else {return}
        displayLabel.text = "\(AppData.bookings.count) loaded bookings"
    }
    
    @IBAction func createButton(_ sender: Any) {
        AppData.admin.append(User(username: "hfeuios", password: "fejsiuo", userType: UserType.admin))
        var dob: DateComponents = DateComponents()
        dob.year = 2003
        dob.month = 12
        dob.day = 7
        var patient1 = Patient(firstName: "Ali", lastName: "Mohammed", phone: "3892999", cpr: "38991993", email: "ahsjk@hf.djo", gender: Gender.male, dateOfBirth: dob, username: "windhh", password: "hunter2")
        AppData.patients.append(patient1)
        var patient2 = Patient(firstName: "Salem", lastName: "Maki", phone: "3892999", cpr: "38991993", email: "ahsjk@hf.djo", gender: Gender.male, dateOfBirth: dob, username: "windhh", password: "hunter2")
        AppData.patients.append(patient2)
        var facility1 = MedicalFacility(name: "Alhilal", phone: "37829", city: "BF", website: "fheiso", alwaysOpen: true, type: FacilityType.hospital, openingTime: dob, closingTime: dob, username: "wahoo", password: "ahil")
        AppData.facilities.append(facility1)
        var service1 = MedicalService(name: "Bloooody test", price: 2, description: "IMPOREKHS", instructions: "EAT ITIII", forMedicalFacility: facility1)
        AppData.services.append(service1)
//        facility1.bookings.append(Booking(forPatient: patient1, ofMedicalService: service1, bookingDate: dob))
        AppData.bookings.append(Booking(forPatient: patient1, ofMedicalService: service1, bookingDate: dob))
        displayLabel.text = "\(AppData.bookings.count) \nHas been made."
        
        AppData.saveData()
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
