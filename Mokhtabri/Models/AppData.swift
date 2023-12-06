//
//  AppData.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 06/12/2023.
//

import Foundation

class AppData : Codable {
    var admin: User
    var patients: [Patient]
    var facilities: [MedicalFacility]
    var bookings: [Booking]
    
    init(admin: User, patients: [Patient], facilities: [MedicalFacility], bookings: [Booking]) {
        self.admin = admin
        self.patients = patients
        self.facilities = facilities
        self.bookings = bookings
    }
    
    static func saveData(data: AppData) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appending(path: "mokhtabri_data.plist")
        let propertyListEncoder = PropertyListEncoder()
        let encodedData = try? propertyListEncoder.encode(data)
        try? encodedData?.write(to: archiveURL, options: .noFileProtection)
    }
    
//    static func loadData() -> AppData {
//        return AppData
//    }
}
