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
        let archiveURL = documentsDirectory.appendingPathComponent("mokhtabri_data").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        do {
            let encodedData = try propertyListEncoder.encode(data)
            try encodedData.write(to: archiveURL, options: .noFileProtection)
        } catch EncodingError.invalidValue {
            print("could not encode")
        } catch {
            print("could not write")
        }
    }
    
    static func loadData() -> AppData? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("mokhtabri_data").appendingPathExtension("plist")
        let propertyListDecoder = PropertyListDecoder()
        print("about to load")
        guard let retrievedData = try? Data(contentsOf: archiveURL) else { return nil }
        print("retreived data")
        guard let decodedData = try? propertyListDecoder.decode(AppData.self, from: retrievedData) else { return nil }
        print("decoded data")
        return decodedData
    }
}
