//
//  AppData.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 06/12/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class AppData {
    static var admin: [User] = []
    static var facilities: [MedicalFacility] = []
    static var services: [MedicalService] = []
    static var tests: [Test] = [test1,test2,test3]
    static var packages: [Package] = [Pack1,Pack2,Pack3]
    static var bookings: [Booking] = []
    static var categories: [Category] = []
    // with sample data
    static var patients: [Patient] = [patient1, patient2, pat3]
    static var listOfTests = [test1,test2,test3,test4,test5,test6,Pack1,Pack2,Pack3]
    static var hospitals = [alhilal,alsalam,royal]
    static var labs: [MedicalFacility] = [BML, expMed, gulfLab, manara]
    
    static var loggedInUser: User?
    
    static func wipe() {
        admin = []
        patients = []
        facilities = []
        services = []
        bookings = []
        categories = []
    }
    
    // Methods to manage users
    
    static func getUser(username: String) -> User? {
        let allUsers: [User] = admin + patients + facilities
        return allUsers.first(where: { $0.username == username })
    }
    static func getUser(uuid: UUID) -> User? {
        let allUsers: [User] = admin + patients + facilities
        return allUsers.first(where: { $0.uuid == uuid })
    }
    
    static func addUser(user: User) {
        if user is Patient {
            patients.append(user as! Patient)
        } else if user is MedicalFacility {
            facilities.append(user as! MedicalFacility)
        } else {
            admin.append(user)
        }
        saveData()
    }
    
    // editUser will not work if equivalence is based on UUIDs (they will change
    // if user is edited), so it was changed to be based on username. This also
    // means that username cannot be changed.
    static func editUser(user: User) {
        if user is Patient {
            if let userIndex = patients.firstIndex(of: user as! Patient) {
                patients.remove(at: userIndex)
                patients.insert(user as! Patient, at: userIndex)
                saveData()
            }
        } else if user is MedicalFacility {
            if let userIndex = facilities.firstIndex(of: user as! MedicalFacility) {
                facilities.remove(at: userIndex)
                facilities.insert(user as! MedicalFacility, at: userIndex)
                saveData()
            }
        } else {
            if let userIndex = admin.firstIndex(of: user) {
                admin.remove(at: userIndex)
                admin.insert(user, at: userIndex)
                saveData()
            }
        }
    }
    
    //this method to manage services
//    static func getService(serviceID: UUID) -> MedicalService? {
//       return services.first(where: { $0.id == serviceID })
//    }

    static func addService(service: MedicalService) {
        if (service is Test) {
            tests.append(service as! Test)
            saveData()
        } else if (service is Package) {
            packages.append(service as! Package)
            saveData()
        }
    }

    static func editService(service: MedicalService) {
        if (service is Test) {
            let test = service as! Test
            if let serviceIndex = tests.firstIndex(of: test) {
                tests.remove(at: serviceIndex)
                tests.insert(test, at: serviceIndex)
                saveData()
            }
        } else if (service is Package) {
            let package = service as! Package
            if let serviceIndex = packages.firstIndex(of: package) {
                packages.remove(at: serviceIndex)
                packages.insert(package, at: serviceIndex)
                saveData()
            }
        }
    }

    static func deleteService(service: MedicalService) -> Bool {
        if (service is Test) {
            if let serviceIndex = tests.firstIndex(of: service as! Test) {
                tests.remove(at: serviceIndex)
                saveData()
                return true
            }
        } else if (service is Package) {
            if let serviceIndex = packages.firstIndex(of: service as! Package) {
                packages.remove(at: serviceIndex)
                saveData()
                return true
            }
        }
       return false
    }
    /*
     For user deletion, Ms. Maleeha only allowed deletion if the user did not have
     a relationship with another object. In our case, that would if a patient had a booking.
     We could do the same thing, but we can also 'cascade' the deletion and delete
     objects in the relationship. So that would mean deleting the Booking if the Patient is
     deleted. But in that case, the facility would also lose the booking. The same goes if
     a facility is deleted, all patients bookings would be deleted too.
     
     TODO: figure this out
     */
    
    static func deleteUser(user: User) -> Bool {
        if user is Patient {
            
        } else if user is MedicalFacility {
            
        } else {
            
        }
        
        return false
    }
    
    
    
    //patient sample
    static var patient1 = Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#78")
    
    static var patient2 = Patient(firstName: "Fatima", lastName: "Naser", phone: "87654321", cpr: "020500000", email: "fatima@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2002, month: 05, day: 09), username: "FatimaN", password: "1234#678")
    
    static var pat3 = Patient(firstName: "Ahmed", lastName: "Faisal", phone: "33992299", cpr: "910200000", email: "AhFai@gmail.com", gender: Gender.male, dateOfBirth: DateComponents(calendar: Calendar.current, year: 1991, month: 04, day: 25), username: "AhmFAi", password: "87651234")
    
    //bookings sample
    static var sampleBookings = [
        
        Booking(forPatient: patient1
                , ofMedicalService: test1, bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 1, day: 10)),
        
        
        Booking(forPatient: patient1
                , ofMedicalService: Pack2 ,bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 2, day: 15)),
        
        
        Booking(forPatient: patient1
                , ofMedicalService: test3,bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 3, day: 20)),
        
        Booking(forPatient: pat3, ofMedicalService: Pack1, bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 09, day: 17))
    ]
    

    
    static var alhilal = MedicalFacility(name: "ALHilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: false, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "alhilalER", password: "alhilal")
    
    
    static var alsalam = MedicalFacility(name: "Alsalam Hospital", phone: "13101010", city: "Riffa", website: "https://www.alsalam.care", alwaysOpen: true, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 0, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 0, minute: 0), username: "alsalam", password: "1234")
     
    static var royal = MedicalFacility(name: "Royal Bahrain Hospital", phone: "17246800", city: "Salmaniya", website: "www.royalbarainhospital.com", alwaysOpen: true, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 0, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 0, minute: 0), username: "royal", password: "1432")
    
    static var test1 = Test(category: "Blood Test", name: "VitaminB12", price: 10, description: "blood test for vitaminb12", instructions: "fasting 8-12 hours prior is mandatory", forMedicalFacility:  alhilal , serviceType: MedicalService.ServiceType(rawValue: "Test")!)
    
    static var test2 =  Test(category: "Viral Test", name: "Covid 19 PCR", price: 15, description: "Covid 19 Test", instructions: "None", forMedicalFacility: alhilal , serviceType: MedicalService.ServiceType(rawValue: "Test")!)
    
    static var test3 = Test(category: "Blood Test", name: "Vitamin D", price: 10, description: "blood test for vitamin D", instructions: "fasting 8-12 hours prior is mandatory", forMedicalFacility:  alhilal , serviceType: MedicalService.ServiceType(rawValue: "Test")!)
    
    static var test4 = Package(expiryDate: DateComponents(calendar: Calendar.current, day: 29), tests: [test1,test3], name: "ALH Vitamin D & B12", price: 5, description: "Dual", instructions: "Fasting is mandatory", forMedicalFacility: alhilal , serviceType: MedicalService.ServiceType(rawValue: "Test")!)
    
    static var test5 = Test(category: "Blood Test", name: "RBC Level", price: 4, description: "Blood test to check the Red Blood Cells level in the blood", instructions: "No instructions", forMedicalFacility: alsalam , serviceType: MedicalService.ServiceType(rawValue: "Test")!)
    
    static var test6 = Test(category: "Blood Test", name: "Iron and HB level", price: 4, description: "Blood test to check the Iron and Haemoglobin level", instructions: "No instructions", forMedicalFacility: alsalam, serviceType: MedicalService.ServiceType(rawValue: "Test")!)
    
    static var Pack1 = Package(expiryDate: DateComponents(calendar: Calendar.current, day: 29), tests: [test1,test2], name: "Vitamin B12 and Covid 19", price: 8, description: "Covid test and blood test for Vitamin B12", instructions: "Fasting is mandatory for 8 - 10 hours", forMedicalFacility: BML, serviceType: MedicalService.ServiceType(rawValue: "Package")!)
    
    static var Pack2 = Package(expiryDate: DateComponents(calendar: Calendar.current, day: 31), tests: [test2,test3], name: "Vitamin D and Covid 19", price: 8, description: "Covid test and blood test for Vitamin D", instructions: "Fasting is mandatory for 8 hours", forMedicalFacility: expMed, serviceType: MedicalService.ServiceType(rawValue: "Package")!)
    
    static var Pack3 = Package(expiryDate: DateComponents(calendar: Calendar.current, day: 27), tests: [test5,test6], name: "Iron deficiency Pack", price: 8, description: "Blood test to check for iron deficiency", instructions: "No instructions", forMedicalFacility: gulfLab, serviceType: MedicalService.ServiceType(rawValue: "Package")!)
    
    
    // labs declaration
    
    static var BML = MedicalFacility(name: "Bahrain Medical Laboratory", phone: "17255522", city: "Salmaniya", website: "https://bahrainmedicallab.com/", alwaysOpen: false, type: .lab, openingTime: DateComponents(calendar: Calendar.current, hour: 7, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "BMLab", password: "Bahrain22")
    
    static var expMed = MedicalFacility(name: "Express Med Labs", phone: "77298888", city: "Zinj", website: "https://www.expressmedlabs.com/", alwaysOpen: false, type: .lab, openingTime: DateComponents(calendar: Calendar.current, hour: 8, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 20, minute: 0), username: "expMed", password: "Zinj1234")
    
    static var gulfLab = MedicalFacility(name: "Gulf Medical Laboratories", phone: "17263999", city: "Manama", website: "https://www.gulflab.com/", alwaysOpen: false, type: .lab, openingTime: DateComponents(calendar: Calendar.current, hour: 8, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 20, minute: 0), username: "gLab", password: "gulfLabs")
    
    static var manara = MedicalFacility(name: "Manara Medical Laboratories", phone: "17722999", city: "Zinj", website: "https://www.eurofins.com/", alwaysOpen: false, type: .lab, openingTime: DateComponents(calendar: Calendar.current, hour: 8, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 20, minute: 0), username: "mmL", password: "manara123")
    
    

    

    
    static func load(){
        if bookings.isEmpty {
            bookings = sampleBookings
            services = listOfTests
            facilities = hospitals
            patients = [patient1]
        }
    }}
