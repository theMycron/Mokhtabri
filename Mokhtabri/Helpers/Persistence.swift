//
//  Persistence.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 11/12/2023.
//

import Foundation

extension AppData {
    
    fileprivate enum FileName: String {
        case admins, patients, facilities, bookings, services, categories
    }
    
    fileprivate static func archiveURL(_ fileName: FileName) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(fileName.rawValue).appendingPathExtension("plist")
    }
    
    // use this function to save data after any data manipulation happens
    static func saveData() {
        saveUsers(toFile: .admins)
        saveUsers(toFile: .patients)
        saveUsers(toFile: .facilities)
        saveCategories()
        saveServices()
        saveBookings()
    }
    
    // loadData will wipe all AppData arrays to prevent duplication, make sure to call it only once at app startup
    static func loadData() {
        AppData.wipe()
        loadUsers(fromFile: .admins)
        loadUsers(fromFile: .patients)
        loadUsers(fromFile: .facilities)
        loadCategories()
        loadServices()
        loadBookings()
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
    fileprivate static func saveServices() {
        guard services.count > 0 else {return}
        let archiveURL = archiveURL(.services)
        let propertyListEncoder = PropertyListEncoder()
        do {
            let encodedData = try propertyListEncoder.encode(services)
            try encodedData.write(to: archiveURL, options: .noFileProtection)
        } catch EncodingError.invalidValue {
            print("could not encode services")
        } catch {
            print("could not write services")
        }
    }
    fileprivate static func saveBookings() {
        guard bookings.count > 0 else {return}
        let archiveURL = archiveURL(.bookings)
        let propertyListEncoder = PropertyListEncoder()
        do {
            let encodedData = try propertyListEncoder.encode(bookings)
            try encodedData.write(to: archiveURL, options: .noFileProtection)
        } catch EncodingError.invalidValue {
            print("could not encode bookings")
        } catch {
            print("could not write bookings")
        }
    }
    fileprivate static func saveCategories() {
        guard categories.count > 0 else {return}
        let archiveURL = archiveURL(.categories)
        let propertyListEncoder = PropertyListEncoder()
        do {
            let encodedData = try propertyListEncoder.encode(categories)
            try encodedData.write(to: archiveURL, options: .noFileProtection)
        } catch EncodingError.invalidValue {
            print("could not encode categories")
        } catch {
            print("could not write categories")
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
    fileprivate static func loadCategories() {
        let archiveURL = archiveURL(.categories)
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedData = try? Data(contentsOf: archiveURL) else { return }
        do {
            var decodedData: [Category] = []
            decodedData = try propertyListDecoder.decode([Category].self, from: retrievedData)
            categories.append(contentsOf: decodedData)
        } catch {
            print("could not load data: \(error)")
        }
    }
    fileprivate static func loadServices() {
        let archiveURL = archiveURL(.services)
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedData = try? Data(contentsOf: archiveURL) else { return }
        do {
            var decodedData: [MedicalService] = []
            decodedData = try propertyListDecoder.decode([MedicalService].self, from: retrievedData)
            services.append(contentsOf: decodedData)
        } catch {
            print("could not load data: \(error)")
        }
    }
    fileprivate static func loadBookings() {
        let archiveURL = archiveURL(.bookings)
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedData = try? Data(contentsOf: archiveURL) else { return }
        do {
            var decodedData: [Booking] = []
            decodedData = try propertyListDecoder.decode([Booking].self, from: retrievedData)
            bookings.append(contentsOf: decodedData)
        } catch {
            print("could not load data: \(error)")
        }
    }
}
