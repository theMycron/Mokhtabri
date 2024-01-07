//
//  Persistence.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 11/12/2023.
//

import Foundation

extension AppData {
    
    fileprivate enum FileName: String {
        case admins, patients, facilities, bookings, packages, tests, categories, bookingsLab, bookingsPatient
    }
    
    // get the URL for data storage
    fileprivate static func archiveURL(_ fileName: FileName) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(fileName.rawValue).appendingPathExtension("plist")
    }
    
    // use this function to save data after any data manipulation happens
    static func saveData() {
        saveUsers(toFile: .admins)
        saveUsers(toFile: .patients)
        saveUsers(toFile: .facilities)
        saveServices(toFile: .packages)
        saveServices(toFile: .tests)
        saveBookings(toFile: .bookingsLab)
        saveBookings(toFile: .bookingsPatient)
    }
    
    // loadData will wipe all AppData arrays to prevent duplication, make sure to call it only once at app startup
    static func loadData() {
        AppData.wipe()
        loadUsers(fromFile: .admins)
        loadUsers(fromFile: .patients)
        loadUsers(fromFile: .facilities)
        loadServices(fromFile: .packages)
        loadServices(fromFile: .tests)
        loadBookings(fromFile: .bookingsLab)
        loadBookings(fromFile: .bookingsPatient)
        loadSampleData() // only loads if no data was found
        AppData.loadServicesImages() {
            
        }
        AppData.loadBookingImages() {
            
        }
    }
    
    fileprivate static func saveUsers(toFile: FileName) {
        let archiveURL = archiveURL(toFile)
        let propertyListEncoder = PropertyListEncoder()
        do {
            if toFile == .patients {
                guard patients.count > 0 else {return}
                let encodedData = try propertyListEncoder.encode(patients)
                try encodedData.write(to: archiveURL, options: .noFileProtection)
            } else if toFile == .facilities {
                guard facilities.count > 0 else {return}
                let encodedData = try propertyListEncoder.encode(facilities)
                try encodedData.write(to: archiveURL, options: .noFileProtection)
            } else if toFile == .admins {
                guard admin.count > 0 else {return}
                let encodedData = try propertyListEncoder.encode(admin)
                try encodedData.write(to: archiveURL, options: .noFileProtection)
            }
        } catch EncodingError.invalidValue {
            print("could not encode users")
        } catch {
            print("could not write users")
        }
    }
    fileprivate static func saveServices(toFile: FileName) {
        let archiveURL = archiveURL(toFile)
        let propertyListEncoder = PropertyListEncoder()
        do {
            if toFile == .tests {
                guard tests.count > 0 else {return}
                let encodedData = try propertyListEncoder.encode(tests)
                try encodedData.write(to: archiveURL, options: .noFileProtection)
            } else if toFile == .packages {
                guard packages.count > 0 else {return}
                let encodedData = try propertyListEncoder.encode(packages)
                try encodedData.write(to: archiveURL, options: .noFileProtection)
            }
//            let encodedData = try propertyListEncoder.encode(services)
//            try encodedData.write(to: archiveURL, options: .noFileProtection)
        } catch EncodingError.invalidValue {
            print("could not encode services")
        } catch {
            print("could not write services")
        }
    }
    fileprivate static func saveBookings(toFile: FileName) {
        let archiveURL = archiveURL(toFile)
        let propertyListEncoder = PropertyListEncoder()
        do {
            if toFile == .bookingsLab {
                guard listOfBookingsLab.count > 0 else {return}
                let encodentData = try propertyListEncoder.encode(listOfBookingsLab)
                try encodentData.write(to: archiveURL, options: .noFileProtection)
            }else if toFile == .bookingsPatient{
                guard listOfBookingsLab.count > 0 else {return}
                let encodentData = try propertyListEncoder.encode(listOfBookingsPatient)
                try encodentData.write(to: archiveURL, options: .noFileProtection)
            }
        
        } catch EncodingError.invalidValue {
            print("could not encode bookings")
        } catch {
            print("could not write bookings")
        }
    }
    
    
    
    fileprivate static func loadUsers(fromFile: FileName) {
        let archiveURL = archiveURL(fromFile)
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedData = try? Data(contentsOf: archiveURL) else {
            print("No user data found")
            return
        }
        do {
            if fromFile == .patients {
                var decodedData: [Patient] = []
                decodedData = try propertyListDecoder.decode([Patient].self, from: retrievedData)
                patients.append(contentsOf: decodedData)
            } else if fromFile == .facilities {
                var decodedData: [MedicalFacility] = []
                decodedData = try propertyListDecoder.decode([MedicalFacility].self, from: retrievedData)
                facilities.append(contentsOf: decodedData)
            } else if fromFile == .admins {
                var decodedData: [User] = []
                decodedData = try propertyListDecoder.decode([User].self, from: retrievedData)
                admin.append(contentsOf: decodedData)
            }
        } catch {
            print("could not load data: \(error)")
        }
    }
    fileprivate static func loadServices(fromFile: FileName) {
        let archiveURL = archiveURL(fromFile)
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedData = try? Data(contentsOf: archiveURL) else { return }
        do {
            if fromFile == .tests {
                var decodedData: [Test] = []
                decodedData = try propertyListDecoder.decode([Test].self, from: retrievedData)
                tests.append(contentsOf: decodedData)
            } else if fromFile == .packages {
                var decodedData: [Package] = []
                decodedData = try propertyListDecoder.decode([Package].self, from: retrievedData)
                packages.append(contentsOf: decodedData)
            }
//            var decodedData: [MedicalService] = []
//            decodedData = try propertyListDecoder.decode([MedicalService].self, from: retrievedData)
//            services.append(contentsOf: decodedData)
        } catch {
            print("could not load data: \(error)")
        }
    }
    fileprivate static func loadBookings(fromFile: FileName) {
        let archiveURL = archiveURL(fromFile)
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedData = try? Data(contentsOf: archiveURL) else { return }
        do {
            if fromFile == .bookingsLab{
                
                
                var decodedData: [Booking] = []
                decodedData = try propertyListDecoder.decode([Booking].self, from: retrievedData)
                listOfBookingsLab.append(contentsOf: decodedData)}
            
            else if fromFile == .bookingsPatient{
                    var decodedData: [Booking] = []
                    decodedData = try propertyListDecoder.decode([Booking].self, from: retrievedData)
                    listOfBookingsPatient.append(contentsOf: decodedData)
                }
        } catch {
            print("could not load data: \(error)")
        }
    }
}
