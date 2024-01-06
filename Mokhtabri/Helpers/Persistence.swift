//
//  Persistence.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 11/12/2023.
//

import Foundation

extension AppData {
    
    fileprivate enum FileName: String {
        case admins, patients, facilities, bookings, packages, tests, categories
    }
    
    // get the URL for data storage
    fileprivate static func archiveURL(_ fileName: FileName) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(fileName.rawValue).appendingPathExtension("plist")
    }
    
    static func loadSampleData() {
        // make sure there is no existing data before loading sample data
        guard facilities.count > 0,
              patients.count > 0,
              bookings.count > 0,
              tests.count > 0,
              packages.count > 0
        else { return }
        
        AppData.patients = AppData.samplePatients
        AppData.facilites = AppData.sampleFacilities
        AppData.tests = AppData.generateSampleTests(forFacilities: AppData.facilites)
        AppData.packages = AppData.samplePackages
        AppData.bookings = AppData.sampleBookings
        //load additional bookings with tests
        // have to do this because sample tests are loaded dynamically (using a function instead of a static list)
        AppData.bookings.append(
            Booking(forPatient: samplePatients[0], ofMedicalService: AppData.tests[3], bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 1, day: 1), BookingStatus.Completed)
        )
        AppData.bookings.append(
            Booking(forPatient: samplePatients[0], ofMedicalService: AppData.tests[14], bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 2, day: 1), BookingStatus.Active)
        )
        AppData.bookings.append(
            Booking(forPatient: samplePatients[0], ofMedicalService: AppData.tests[17], bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 2, day: 16), BookingStatus.Cancelled)
        )
        AppData.bookings.append(
            Booking(forPatient: samplePatients[0], ofMedicalService: AppData.tests[19], bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 1, day: 16), BookingStatus.Cancelled)
        )
        AppData.bookings.append(
            Booking(forPatient: samplePatients[1], ofMedicalService: AppData.tests[0], bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 1, day: 4), BookingStatus.Completed)
        )

    }
    
    // use this function to save data after any data manipulation happens
    static func saveData() {
        saveUsers(toFile: .admins)
        saveUsers(toFile: .patients)
        saveUsers(toFile: .facilities)
        saveServices(toFile: .packages)
        saveServices(toFile: .tests)
        saveBookings()
    }
    
    // loadData will wipe all AppData arrays to prevent duplication, make sure to call it only once at app startup
    static func loadData() {
        AppData.wipe()
        loadUsers(fromFile: .admins)
        loadUsers(fromFile: .patients)
        loadUsers(fromFile: .facilities)
        loadServices(fromFile: .packages)
        loadServices(fromFile: .tests)
        loadBookings()
        loadSampleData() // only loads if no data is found
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
