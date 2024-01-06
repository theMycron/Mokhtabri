//
//  AppData.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 06/12/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import Kingfisher

class AppData {
    static var admin: [User] = []
    static var facilities: [MedicalFacility] = []
    static var patients: [Patient] = []
    static var tests: [Test] = []
    static var packages: [Package] = []
    static var bookings: [Booking] = []
    // static var services: [MedicalService] = []
    // static var categories: [Category] = []
    // // with sample data
    // static var listOfTests = [test1,test2,test3,test4,test5,test6,Pack1,Pack2,Pack3,Pack4]
    // static var hospitals = [alhilal,alsalam,royal]
    // static var labs: [MedicalFacility] = [BML, expMed, gulfLab, manara]
    
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
    
    // return true if email already exists, used for registering a new user
    static func isEmailInUse(email: String) -> Bool {
        var inUse: Bool = false
        let allUsers: [User] = AppData.admin + AppData.facilities + AppData.patients
        let matchingUsers: [User] = allUsers.filter{ $0.username == email }
        if (matchingUsers.count > 0) {
            inUse = true
        }
        return inUse
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
    
    // ******* SAMPLE DATA ********
    
    //patients sample
    static let samplePatients: [Patient] = [
        Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#78"),
        Patient(firstName: "Fatima", lastName: "Naser", phone: "87654321", cpr: "020500000", email: "fatima@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2002, month: 05, day: 09), username: "FatimaN", password: "1234#678"),
        Patient(firstName: "Ahmed", lastName: "Faisal", phone: "33992299", cpr: "910200000", email: "AhFai@gmail.com", gender: Gender.male, dateOfBirth: DateComponents(calendar: Calendar.current, year: 1991, month: 04, day: 25), username: "AhmFAi", password: "87651234"),
        Patient(firstName: "Yousif", lastName: "Alhawaj", phone: "45389445", cpr: "031039304", email: "alyasfy@gmail.com", gender: Gender.male, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 20), username: "yousifito", password: "12345678"),
        Patient(firstName: "Ali", lastName: "Abdul", phone: "94000334", cpr: "000100001", email: "aliabdul@gmail.com", gender: Gender.male, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2000, month: 01, day: 01), username: "alooyi", password: "12345678")
    ]

    // facilities sample
    static let sampleFacilities: [MedicalFacility] = [
        MedicalFacility(name: "Al Hilal Hospital", phone: "17344700", city: "Muharraq", website: "alhilalhealthcare.com", alwaysOpen: true, type: FacilityType.hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 8, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 20, minute: 0), image: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Fal_hilal_hospital_muharraq.jpg?alt=media&token=1a2e89e9-f01d-49c7-8ec0-90a4da303cfa", username: "alhilal@mokhtabri.com", password: "alhilalalhilal"),
        MedicalFacility(name: "Bahrain Medical Laboratory", phone: "17255522", city: "Manama", website: "bahrainmedicallab.com", alwaysOpen: false, type: FacilityType.lab, openingTime: DateComponents(calendar: Calendar.current, hour: 7, minute: 30), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), image: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Fbahrain_medical_laboratory_manama.jpg?alt=media&token=da4dd4ae-a3b1-49c1-b976-2defdc135524", username: "bhmedlabs@mokhtabri.com", password: "bhmedlabsbh"),
        MedicalFacility(name: "Al Borg Diagnostics", phone: "17100088", city: "Manama", website: "alborgdx.com", alwaysOpen: false, type: FacilityType.lab, openingTime: DateComponents(calendar: Calendar.current, hour: 8, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), image: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Fal_borg_diagnostics_manama.jpg?alt=media&token=b3726451-3ace-4988-92ef-9689eed685be", username: "alborg@mokhtabri.com", password: "alborgborg"),
        MedicalFacility(name: "Manara Medical Laboratories", phone: "17722999", city: "Manama", website: "eurofins.com", alwaysOpen: false, type: FacilityType.lab, openingTime: DateComponents(calendar: Calendar.current, hour: 8, minute: 30), closingTime: DateComponents(calendar: Calendar.current, hour: 20, minute: 30), image: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Fmanara_medical_laboratories_manama.jpg?alt=media&token=2cf7a6fd-3073-4c70-aa09-9330e43d081c", username: "manara@mokhtabri.com", password: "euromanara"),
        MedicalFacility(name: "ExpressMed Diagnostics", phone: "77248888", city: "Manama", website: "expressmedlabs.com", alwaysOpen: false, type: FacilityType.lab, openingTime: DateComponents(calendar: Calendar.current, hour: 8, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 20, minute: 0), image: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Fexpressmed_diagnostics_manama.jpg?alt=media&token=52327add-e906-47d5-a14e-e3f8d31e4708", username: "expressmed@mokhtabri.com", password: "expressdiag"),
        MedicalFacility(name: "Royal Bahrain Hospital", phone: "17491749", city: "Janabiyah", website: "royalbahrainhospital.com", alwaysOpen: false, type: FacilityType.hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), image: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Froyal_bahrain_hospital_janabiyah.jpg?alt=media&token=345a741a-02ad-4add-b03b-f3928554257f", username: "royalhospital@mokhtabri.com", password: "royaltyhealth"),
        MedicalFacility(name: "Middle East Hospital", phone: "17362233", city: "Manama", website: "mehospital.com", alwaysOpen: true, type: FacilityType.hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), image: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Fmiddle_east_hospital_manama.jpg?alt=media&token=e0f2f062-9376-4c20-82e7-41fd0335411f", username: "mehospital@mokhtabri.com", password: "middleeastern"),
        MedicalFacility(name: "Awali Hospital", phone: "17757600", city: "Awali", website: "awalihospital.com", alwaysOpen: true, type: FacilityType.hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), image: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Fawali_hospital_awali.jpg?alt=media&token=72106dba-8e4d-4326-b673-042ec640b2af", username: "awalihp@mokhtabri.com", password: "theawalihp"),
        MedicalFacility(name: "AlSalam Specialist Hospital", phone: "13101010", city: "Riffa", website: "alsalam.care", alwaysOpen: true, type: FacilityType.hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), image: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Falsalam_specialist_hospital_riffa.jpg?alt=media&token=0eb9f54f-c47f-4c40-bf3e-a1361ec7a69f", username: "alsalam@mokhtabri.com", password: "salamalekom")
    ]

    //tests sample
    // this function will generate a list of predefined tests for all sample facilites
    func generateSampleTests(forFacilities: [MedicalFacility]) -> [Test] {
        var list: [Test] = []
        // add tests for all facilities
        for facility in forFacilities {
            list.append(Test(category: "Blood Test", name: "Vitamin B12", price: 3, description: "Vitamin B12 is an important component of the human body. It should be tested for normal levels in order to live a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: facility))
            list.append(Test(category: "Viral Test", name: "COVID-19 PCR", price: 4, description: "COVID-19 is a notorious pandemic that took the world by storm. This test checks for the existence of this pathogen from a nasal insertion.", instructions: "None", forMedicalFacility: facility))
            list.append(Test(category: "Blood Test", name: "Vitamin D", price: 2, description: "Vitamin D has a strong effect on one's health. Check your Vitamin D levels to ensure you have healthy skin and a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: facility))
            list.append(Test(category: "Dental Test", name: "Dental Screening", price: 10, description: "Have a dentist look at the status of your teeth and give advice for how to proceed with treatment if needed.", instructions: "Fasting 4 hours prior is mandatory", forMedicalFacility: facility))
            list.append(Test(category: "Eye Test", name: "Eye Screening", price: 15, description: "Have an optometrist test your vision and eye health.", instructions: "None", forMedicalFacility: facility))
            list.append(Test(category: "Gynecology Test", name: "Pregnancy Test", price: 5, description: "Check if you have a baby cooking in the oven.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: facility))
            list.append(Test(category: "Blood Test", name: "White Blood Count", price: 4, description: "Test the immune system by checking the number of white blood cells.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: facility))
        }
        return list
    }

    //sample packages
    // packages use a selection of predefined tests instead of actual tests related to the package (to save time)
    // use alborg facility to demonstrate packages
    static let samplePackages = [
        Package(expiryDate: DateComponents, tests: [
            Test(category: "Blood Test", name: "Vitamin B12", price: 3, description: "Vitamin B12 is an important component of the human body. It should be tested for normal levels in order to live a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: sampleFacilities[0]),
            Test(category: "Viral Test", name: "COVID-19 PCR", price: 4, description: "COVID-19 is a notorious pandemic that took the world by storm. This test checks for the existence of this pathogen from a nasal insertion.", instructions: "None", forMedicalFacility: sampleFacilities[0]),
            Test(category: "Blood Test", name: "Vitamin D", price: 2, description: "Vitamin D has a strong effect on one's health. Check your Vitamin D levels to ensure you have healthy skin and a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: sampleFacilities[0])
        ], name: "Mini Comprehensive Checkup", price: 3, description: "Great cost-effective medical package for a multitude of various tests.", instructions: "Fasting 8-12 hours is mandatory.", forMedicalFacility: sampleFacilities[0], imageDownloadURL: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/serviceImages%2Falhilal_mini_comprehensive_checkup.jpg?alt=media&token=f2660d68-8997-48a8-b972-42711b615f32"),
        Package(expiryDate: DateComponents, tests: [
            Test(category: "Blood Test", name: "Vitamin B12", price: 3, description: "Vitamin B12 is an important component of the human body. It should be tested for normal levels in order to live a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: sampleFacilities[0]),
            Test(category: "Viral Test", name: "COVID-19 PCR", price: 4, description: "COVID-19 is a notorious pandemic that took the world by storm. This test checks for the existence of this pathogen from a nasal insertion.", instructions: "None", forMedicalFacility: sampleFacilities[0]),
            Test(category: "Blood Test", name: "Vitamin D", price: 2, description: "Vitamin D has a strong effect on one's health. Check your Vitamin D levels to ensure you have healthy skin and a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: sampleFacilities[0])
        ], name: "Bahraini Health Package", price: 6, description: "Great cost-effective medical package for a multitude of various tests.", instructions: "Fasting 8-12 hours is mandatory.", forMedicalFacility: sampleFacilities[0], imageDownloadURL: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/serviceImages%2Falhilal_bahraini_health_package.jpg?alt=media&token=793d2312-3283-4eb5-9236-15a2dc006aae"),
        Package(expiryDate: DateComponents, tests: [
            Test(category: "Blood Test", name: "Vitamin B12", price: 3, description: "Vitamin B12 is an important component of the human body. It should be tested for normal levels in order to live a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: sampleFacilities[1]),
            Test(category: "Viral Test", name: "COVID-19 PCR", price: 4, description: "COVID-19 is a notorious pandemic that took the world by storm. This test checks for the existence of this pathogen from a nasal insertion.", instructions: "None", forMedicalFacility: sampleFacilities[1]),
            Test(category: "Blood Test", name: "Vitamin D", price: 2, description: "Vitamin D has a strong effect on one's health. Check your Vitamin D levels to ensure you have healthy skin and a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: sampleFacilities[1])
        ], name: "General Check-up Proﬁle 1", price: 20, description: "Great cost-effective medical package for a multitude of various tests.", instructions: "Fasting 8-12 hours is mandatory.", forMedicalFacility: sampleFacilities[1]),
        Package(expiryDate: DateComponents, tests: [
            Test(category: "Blood Test", name: "Vitamin B12", price: 3, description: "Vitamin B12 is an important component of the human body. It should be tested for normal levels in order to live a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: sampleFacilities[2]),
            Test(category: "Viral Test", name: "COVID-19 PCR", price: 4, description: "COVID-19 is a notorious pandemic that took the world by storm. This test checks for the existence of this pathogen from a nasal insertion.", instructions: "None", forMedicalFacility: sampleFacilities[2]),
            Test(category: "Blood Test", name: "Vitamin D", price: 2, description: "Vitamin D has a strong effect on one's health. Check your Vitamin D levels to ensure you have healthy skin and a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: sampleFacilities[2])
        ], name: "Hair Full Profile", price: 30, description: "Great cost-effective medical package for hair loss issues.", instructions: "None", forMedicalFacility: sampleFacilities[2], imageDownloadURL: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/serviceImages%2Falborg_full_hair_profile.jpg?alt=media&token=6850dccb-3994-483f-8d7d-cfd275de1389"),
        Package(expiryDate: DateComponents, tests: [
            Test(category: "Blood Test", name: "Vitamin B12", price: 3, description: "Vitamin B12 is an important component of the human body. It should be tested for normal levels in order to live a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: sampleFacilities[2]),
            Test(category: "Viral Test", name: "COVID-19 PCR", price: 4, description: "COVID-19 is a notorious pandemic that took the world by storm. This test checks for the existence of this pathogen from a nasal insertion.", instructions: "None", forMedicalFacility: sampleFacilities[2]),
            Test(category: "Blood Test", name: "Vitamin D", price: 2, description: "Vitamin D has a strong effect on one's health. Check your Vitamin D levels to ensure you have healthy skin and a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: sampleFacilities[2])
        ], name: "Virology Profile", price: 25, description: "Great cost-effective medical package for viral diseases.", instructions: "None", forMedicalFacility: sampleFacilities[2], imageDownloadURL: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/serviceImages%2Falborg_virology_profile.jpg?alt=media&token=2227ae3c-fd5f-4db9-b0f3-ab58699bbce9"),
        Package(expiryDate: DateComponents, tests: [
            Test(category: "Blood Test", name: "Vitamin B12", price: 3, description: "Vitamin B12 is an important component of the human body. It should be tested for normal levels in order to live a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: sampleFacilities[2]),
            Test(category: "Viral Test", name: "COVID-19 PCR", price: 4, description: "COVID-19 is a notorious pandemic that took the world by storm. This test checks for the existence of this pathogen from a nasal insertion.", instructions: "None", forMedicalFacility: sampleFacilities[2]),
            Test(category: "Blood Test", name: "Vitamin D", price: 2, description: "Vitamin D has a strong effect on one's health. Check your Vitamin D levels to ensure you have healthy skin and a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: sampleFacilities[2])
        ], name: "Pro Package", price: 45, description: "Great cost-effective medical package for various different medical issues.", instructions: "None", forMedicalFacility: sampleFacilities[2], imageDownloadURL: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/serviceImages%2Falborg_pro_profile.jpg?alt=media&token=ef393cc8-9032-40b0-9a0e-ee6a03ed0445"),
        Package(expiryDate: DateComponents, tests: [
            Test(category: "Blood Test", name: "Vitamin B12", price: 3, description: "Vitamin B12 is an important component of the human body. It should be tested for normal levels in order to live a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: sampleFacilities[2]),
            Test(category: "Viral Test", name: "COVID-19 PCR", price: 4, description: "COVID-19 is a notorious pandemic that took the world by storm. This test checks for the existence of this pathogen from a nasal insertion.", instructions: "None", forMedicalFacility: sampleFacilities[2]),
            Test(category: "Blood Test", name: "Vitamin D", price: 2, description: "Vitamin D has a strong effect on one's health. Check your Vitamin D levels to ensure you have healthy skin and a healthy life.", instructions: "Fasting 8-12 hours prior is mandatory.", forMedicalFacility: sampleFacilities[2])
        ], name: "Thyroid", price: 12, description: "Great cost-effective medical package for thyroid related issues.", instructions: "None", forMedicalFacility: sampleFacilities[2], imageDownloadURL: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/serviceImages%2Falborg_thyroid.jpg?alt=media&token=cc8aecc7-3df6-433b-9d6d-240ead10aa37"),
    ]

    //bookings sample
    // can only add bookings for packages here because there is no list for
    // sampleTests (we use a function for it)
    // bookings for tests will be added when the sample data is being loaded
    // in the loadSampleData() function.
    static let sampleBookings = [
        
        Booking(forPatient: samplePatients[0], ofMedicalService: samplePackages[3], bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 1, day: 5), BookingStatus.Completed),
        Booking(forPatient: samplePatients[0], ofMedicalService: samplePackages[4] ,bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 2, day: 15), BookingStatus.Active),
        Booking(forPatient: samplePatients[0], ofMedicalService: samplePackages[4],bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 1, day: 2), BookingStatus.Completed),
        Booking(forPatient: samplePatients[0], ofMedicalService: samplePackages[5],bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 2, day: 11), BookingStatus.Cancelled),
        Booking(forPatient: samplePatients[0], ofMedicalService: samplePackages[3],bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 2, day: 5), BookingStatus.Cancelled),
        Booking(forPatient: samplePatients[2], ofMedicalService: samplePackages[1], bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 3, day: 17), BookingStatus.Active),
        Booking(forPatient: samplePatients[4], ofMedicalService: samplePackages[2], bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 4, day: 26), BookingStatus.Active),
        Booking(forPatient: samplePatients[1], ofMedicalService: samplePackages[5], bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 1, day: 7), BookingStatus.Completed),
        Booking(forPatient: samplePatients[1], ofMedicalService: samplePackages[4], bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 2, day: 16), BookingStatus.Cancelled),
        Booking(forPatient: samplePatients[3], ofMedicalService: samplePackages[1], bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 2, day: 5), BookingStatus.Active),
    ]
    
    // **** old sample data **** 
    
    // static var alhilal = MedicalFacility(name: "ALHilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: false, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "alhilalER", password: "alhilal")
    
    
    // static var alsalam = MedicalFacility(name: "Alsalam Hospital", phone: "13101010", city: "Riffa", website: "https://www.alsalam.care", alwaysOpen: true, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 0, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 0, minute: 0), username: "alsalam", password: "1234")
    
    // static var royal = MedicalFacility(name: "Royal Bahrain Hospital", phone: "17246800", city: "Salmaniya", website: "www.royalbarainhospital.com", alwaysOpen: true, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 0, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 0, minute: 0), username: "royal", password: "1432")
    
    // static var test1 = Test(category: "Blood Test", name: "VitaminB12", price: 10, description: "blood test for vitaminb12", instructions: "fasting 8-12 hours prior is mandatory", forMedicalFacility:  alhilal)
    
    
    // static var test2 =  Test(category: "Viral Test", name: "Covid 19 PCR", price: 15, description: "Covid 19 Test", instructions: "None", forMedicalFacility: alhilal)
    
    // static var test3 = Test(category: "Blood Test", name: "Vitamin D", price: 10, description: "blood test for vitamin D", instructions: "fasting 8-12 hours prior is mandatory", forMedicalFacility:  alhilal)
    
    // static var test4 = Package(expiryDate: DateComponents(calendar: Calendar.current, day: 29), tests: [test1,test3], name: "ALH Vitamin D & B12", price: 5, description: "Dual", instructions: "Fasting is mandatory", forMedicalFacility: alhilal)
    
    // static var test5 = Test(category: "Blood Test", name: "RBC Level", price: 4, description: "Blood test to check the Red Blood Cells level in the blood", instructions: "No instructions", forMedicalFacility: alsalam)
    
    // static var test6 = Test(category: "Blood Test", name: "Iron and HB level", price: 4, description: "Blood test to check the Iron and Haemoglobin level", instructions: "No instructions", forMedicalFacility: alsalam)
    
    
    
    // static var test7 = Test(category: "Blood Test", name: "CBC Count", price: 3, description: "Blood test to check the CBC Count", instructions: "No instructions", forMedicalFacility: alsalam)
    
    // static var test8 = Test(category: "Blood Test", name: "Immunogloblin A", price: 3, description: "Blood test to check the Immunogloblin A levels", instructions: "No instructions", forMedicalFacility: alsalam)
    
    // static var test9 = Test(category: "Blood Test", name: "Immunogloblin G", price: 3, description: "Blood test to check the Immunogloblin G levels", instructions: "No instructions", forMedicalFacility: alsalam)
    
    // static var test10 = Test(category: "Blood Test", name: "Immunogloblin M", price: 3, description: "Blood test to check the Immunogloblin M levels", instructions: "No instructions", forMedicalFacility: alsalam)
    
    // static var Pack4 = Package(expiryDate: DateComponents(calendar: Calendar.current, day: 29), tests: [test7,test8,test9,test10], name: "Immune System Test", price: 10, description: "Check blood to determine health of immune system", instructions: "Fasting is mandatory for 8 - 10 hours", forMedicalFacility: alsalam)
    
    
    // static var Pack1 = Package(expiryDate: DateComponents(calendar: Calendar.current, day: 29), tests: [test1,test2], name: "Vitamin B12 and Covid 19", price: 8, description: "Covid test and blood test for Vitamin B12", instructions: "Fasting is mandatory for 8 - 10 hours", forMedicalFacility: BML)
    
    // static var Pack2 = Package(expiryDate: DateComponents(calendar: Calendar.current, day: 31), tests: [test2,test3], name: "Vitamin D and Covid 19", price: 8, description: "Covid test and blood test for Vitamin D", instructions: "Fasting is mandatory for 8 hours", forMedicalFacility: expMed)
    
    // static var Pack3 = Package(expiryDate: DateComponents(calendar: Calendar.current, day: 27), tests: [test5,test6], name: "Iron deficiency Pack", price: 8, description: "Blood test to check for iron deficiency", instructions: "No instructions", forMedicalFacility: gulfLab)
    
    
    // // labs declaration
    
    // static var BML = MedicalFacility(name: "Bahrain Medical Laboratory", phone: "17255522", city: "Salmaniya", website: "https://bahrainmedicallab.com/", alwaysOpen: false, type: .lab, openingTime: DateComponents(calendar: Calendar.current, hour: 7, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "BMLab", password: "Bahrain22")
    
    // static var expMed = MedicalFacility(name: "Express Med Labs", phone: "77298888", city: "Zinj", website: "https://www.expressmedlabs.com/", alwaysOpen: false, type: .lab, openingTime: DateComponents(calendar: Calendar.current, hour: 8, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 20, minute: 0), username: "expMed", password: "Zinj1234")
    
    // static var gulfLab = MedicalFacility(name: "Gulf Medical Laboratories", phone: "17263999", city: "Manama", website: "https://www.gulflab.com/", alwaysOpen: false, type: .lab, openingTime: DateComponents(calendar: Calendar.current, hour: 8, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 20, minute: 0), username: "gLab", password: "gulfLabs")
    
    // static var manara = MedicalFacility(name: "Manara Medical Laboratories", phone: "17722999", city: "Zinj", website: "https://www.eurofins.com/", alwaysOpen: false, type: .lab, openingTime: DateComponents(calendar: Calendar.current, hour: 8, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 20, minute: 0), username: "mmL", password: "manara123")
    
    
    
    
    
    
    static func load(){
        // if bookings.isEmpty {
        //     test1.storageLink = "gs://fir-testing-512eb.appspot.com/Vitamin-B12.jpg"
        //     Pack1.storageLink = "gs://fir-testing-512eb.appspot.com/covid19.webp"
        //     test2.storageLink = "gs://fir-testing-512eb.appspot.com/pcr.jpeg"
        //     Pack4.storageLink = "gs://fir-testing-512eb.appspot.com/packageImages/Immune-System.png"
            
        //     bookings = sampleBookings
        //    // sampleBookings[0].ofMedicalService.storageLink = "gs://fir-testing-512eb.appspot.com/Vitamin-B12.jpg"
        //     services = listOfTests
        //     facilities = hospitals
        //     patients = [samplePatients[0]]
            loadServicesImages()
            
        }
    }
    
    static func loadServicesImages(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        // FIXME: the services array was removed in favor
        // of separate tests and packages arrays.
        // they can be combined into one array before usage here.
        for service in AppData.services { // Assume servicesArray is your array of MedicalService
            if let storageLink = service.storageLink {
                group.enter()
                let storageRef = Storage.storage().reference(forURL: storageLink)
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        group.leave()
                    } else if let url = url {
                        KingfisherManager.shared.retrieveImage(with: url) { result in
                            switch result {
                            case .success(let value):
                                service.photo = value.image
                            case .failure(let error):
                                print("Error downloading image: \(error.localizedDescription)")
                                service.photo = nil // or set a default image
                            }
                            group.leave()
                        }
                    }
                }
            }
        }

        group.notify(queue: .main) {
            completion()
        }
    }

    

}
