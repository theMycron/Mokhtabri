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
import FirebaseAuth

class AppData {
    static var admin: [User] = [User(username: "admin@gmail.com", password: "12345678", userType: .admin)]
    static var facilities: [MedicalFacility] = []
    static var services: [MedicalService] = []
    static var tests: [Test] = []
    static var sampleTests: [Test] = [test1,test2,test3,test5,test6,test7,test8,test9,test10]
    static var packages: [Package] = []
    static var samplePackages: [Package] = [Pack3,Pack4,test4]
    static var bookings: [Booking] = []
    static var categories: [Category] = []
    // with sample data
    static var patients: [Patient] = []
    static var listOfTests = [test1,test2,test3,test4,test5,test6,Pack3,Pack4]
    static var hospitals = [alhilal,alsalam,royal,middle,awali]
    static var labs: [MedicalFacility] = [BML, expMed, gulfLab, manara,borg]
    static var listOfBookingsPatient: [Booking] = []
    static var listOfBookingsLab: [Booking] = []
    
    
    static var loggedInUser: User? 
    //loggedInUser = Auth.auth().currentUser!.uid
   
    
    
    static func wipe() {
        admin = []
        patients = []
        facilities = []
        services = []
        bookings = []
        categories = []
        tests = []
        packages = []
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
                loadServicesImages(){
                    
                }
            }
        } else if (service is Package) {
            let package = service as! Package
            if let serviceIndex = packages.firstIndex(of: package) {
            //    print(service.storageLink)
                
                packages.remove(at: serviceIndex)
                packages.insert(package, at: serviceIndex)
                saveData()
                loadServicesImages(){
                    
                }
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
    // return user if email exists, used for registering a new user
    static func getUserFromEmail(email: String) -> User? {
        let allUsers: [User] = AppData.admin + AppData.facilities + AppData.patients
        let matchingUsers: [User] = allUsers.filter{ $0.username == email }
        if (matchingUsers.count > 0) {
            return matchingUsers[0]
        }
        return nil
    }
    
    
    static func deleteUser(user: User) -> Bool {
        if user is Patient {
            if let userIndex = patients.firstIndex(of: user as! Patient) {
                patients.remove(at: userIndex)
                saveData()
                return true
            }
        } else if user is MedicalFacility {
            if let userIndex = facilities.firstIndex(of: user as! MedicalFacility) {
                facilities.remove(at: userIndex)
                saveData()
                return true
            }
        }
        
        return false
    }
    static func loadSampleData(){
        // ensure that no data is already present
        guard bookings.isEmpty,
              facilities.isEmpty,
              patients.isEmpty,
              tests.isEmpty,
              packages.isEmpty
        else {return}
        listOfBookingsLab = sampleBookings
        listOfBookingsPatient = sampleBookings
        
        facilities = hospitals + labs
        bookings = sampleBookings
        tests = sampleTests
        packages = samplePackages
        patients = [patient1,patient2,pat3]
        loadServicesImages(){
            
        }
        loadHospitalPhotos()
        
    }
    
    static func loadPicture(medic: MedicalService) -> MedicalService{
        let group = DispatchGroup()
        group.enter()
        KingfisherManager.shared.retrieveImage(with: medic.storageLink!) { result in
            switch result {
            case .success(let value):
                medic.photo = value.image
            
            case .failure(let error):
                print("Error downloading image: \(error.localizedDescription)")
                medic.photo = nil
            }
            group.leave()
            
        }
        group.notify(queue: .main){
            
        }
        return medic
    }
    static func loadHospitalPhotos(){
        let group = DispatchGroup()
        
        for f in facilities{
            group.enter()
            KingfisherManager.shared.retrieveImage(with: f.imageDownloadURL ?? URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/testImages%2F504276.png?alt=media&token=cb30478e-345b-4de7-b2bd-aecdb7e7765d")!){result in
                switch result {
                case .success(let value):
                    f.photo = value.image
                case .failure(let error):
                    print("error downloading \(error)")
                    f.photo = nil
                }
                group.leave()
            }
        }
        group.notify(queue: .main){
            
        }
    }
    static func loadServicesImages(completion: @escaping () -> Void) {
        var services : [MedicalService] = []
        for s in tests {
            services.append(s)
        }
        for s in packages{
            services.append(s)
        }
        let group = DispatchGroup()
        
        //loops through the array of services
        for service in services {
            group.enter()
            KingfisherManager.shared.retrieveImage(with: service.storageLink ?? URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/testImages%2Frbc-alsalam.jpeg?alt=media&token=71a9c05b-52fb-4b26-a2f9-b78c2604bca1")!) { result in
                switch result {
                case .success(let value):
                    service.photo = value.image
                case .failure(let error):
                    print("Error downloading image: \(error.localizedDescription)")
                    service.photo = nil
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion()
        }
    }
    
    static func loadBookingImages(completion: @escaping () -> Void) {
        var services : [MedicalService] = []
        for booking in listOfBookingsLab{
            services.append(booking.ofMedicalService)
        }
        
        for booking in listOfBookingsPatient{
            services.append(booking.ofMedicalService)
        }
        let group = DispatchGroup()

        //loops through the array of services       //loops through the array of services
        for service in services {
            group.enter()
            KingfisherManager.shared.retrieveImage(with: service.storageLink ?? URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/testImages%2Frbc-alsalam.jpeg?alt=media&token=71a9c05b-52fb-4b26-a2f9-b78c2604bca1")!) { result in
                switch result {
                case .success(let value):
                    service.photo = value.image
                case .failure(let error):
                    print("Error downloading image: \(error.localizedDescription)")
                    service.photo = nil
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion()
        }

    }
    
    // ********* SAMPLE DATA **********
    
    //patient sample

    static var patient1 = Patient(firstName: "Noora", lastName: "Qasim", cpr: "031003257", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "nooraw376@gmail.com", password: "12345678")

    

    
    static var patient2 = Patient(firstName: "Fatima", lastName: "Naser", cpr: "020500000", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2002, month: 05, day: 09), username: "fateman376@gmail.com", password: "12345678")
    
    static var pat3 = Patient(firstName: "Ahmed", lastName: "Faisal", cpr: "910200000", gender: Gender.male, dateOfBirth: DateComponents(calendar: Calendar.current, year: 1991, month: 04, day: 25), username: "hamoodhaboob@gmail.com", password: "12345678")
    
    
    
    //bookings sample
    static var sampleBookings = [
        
        Booking(forPatient: patient1
                , ofMedicalService: test1, bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 1, day: 10)),
        
        
        Booking(forPatient: patient1
                , ofMedicalService: test4 ,bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 2, day: 15)),
        
        
        Booking(forPatient: patient1
                , ofMedicalService: test3,bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 3, day: 20)),
        
        Booking(forPatient: pat3, ofMedicalService: Pack4, bookingDate: DateComponents(calendar: Calendar.current, year: 2024, month: 09, day: 17))
    ]
    
    
    
    static var alhilal = MedicalFacility(name: "Al Hilal Hospital", phone: "17344700", city: "Muharraq", website: "alhilalhealthcare.com", alwaysOpen: true, type: FacilityType.hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 8, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 20, minute: 0), image: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Fal_hilal_hospital_muharraq.jpg?alt=media&token=1a2e89e9-f01d-49c7-8ec0-90a4da303cfa"), username: "alhilal@mokhtabri.com", password: "12345678")
    
    
    static var alsalam = MedicalFacility(name: "AlSalam Specialist Hospital", phone: "13101010", city: "Riffa", website: "alsalam.care", alwaysOpen: true, type: FacilityType.hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), image: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Falsalam_specialist_hospital_riffa.jpg?alt=media&token=0eb9f54f-c47f-4c40-bf3e-a1361ec7a69f"), username: "alsalam@mokhtabri.com", password: "12345678")
    
    static var royal = MedicalFacility(name: "Royal Bahrain Hospital", phone: "17491749", city: "Janabiyah", website: "royalbahrainhospital.com", alwaysOpen: false, type: FacilityType.hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), image: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Froyal_bahrain_hospital_janabiyah.jpg?alt=media&token=345a741a-02ad-4add-b03b-f3928554257f"), username: "royalbh@mokhtabri.com", password: "12345678")
    // new
    static let middle = MedicalFacility(name: "Middle East Hospital", phone: "17362233", city: "Manama", website: "mehospital.com", alwaysOpen: true, type: FacilityType.hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), image: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Fmiddle_east_hospital_manama.jpg?alt=media&token=e0f2f062-9376-4c20-82e7-41fd0335411f"), username: "mehospital@mokhtabri.com", password: "12345678")
    static let awali = MedicalFacility(name: "Awali Hospital", phone: "17757600", city: "Awali", website: "awalihospital.com", alwaysOpen: true, type: FacilityType.hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), image: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Fawali_hospital_awali.jpg?alt=media&token=72106dba-8e4d-4326-b673-042ec640b2af"), username: "awalihp@mokhtabri.com", password: "12345678")
    
    
    // tests
    static var test1 = Test(category: "Blood Test", name: "VitaminB12", price: 10, description: "blood test for vitaminb12", instructions: "fasting 8-12 hours prior is mandatory", forMedicalFacility:  alhilal,serviceType: .test, storageLink: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/Vitamin-B12.jpg?alt=media&token=e1778127-98ac-44b6-8380-05e98bb13ec4"))
    
    
    static var test2 =  Test(category: "Viral Test", name: "Covid 19 PCR", price: 15, description: "Covid 19 Test", instructions: "None", forMedicalFacility: alhilal,serviceType: .test, storageLink: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/covid19.webp?alt=media&token=d7e584ed-8b4b-475b-a082-9367b0a2ce45"))
    
    static var test3 = Test(category: "Blood Test", name: "Vitamin D", price: 10, description: "blood test for vitamin D", instructions: "fasting 8-12 hours prior is mandatory", forMedicalFacility:  alhilal, serviceType: .test, storageLink: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/testImages%2FVitamin-D-Article.jpg?alt=media&token=d85abb44-ac20-40d6-bd8e-3fa0b23942d3"))
    
    static var test4 = Package(expiryDate: DateComponents(calendar: Calendar.current, day: 29), tests: [test1,test3], name: "ALH Vitamin D & B12", price: 10, description: "Dual", instructions: "Fasting is mandatory", forMedicalFacility: alhilal, serviceType: .test, storageLink: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/testImages%2FhilalvitaminB12%26D.jpeg?alt=media&token=260b4555-6068-454a-9bb4-a1b623291765"))
    
    static var test5 = Test(category: "Blood Test", name: "RBC Level", price: 4, description: "Blood test to check the Red Blood Cells level in the blood", instructions: "No instructions", forMedicalFacility: alsalam, serviceType: .test,  storageLink: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/testImages%2Frbc-alsalam.jpeg?alt=media&token=71a9c05b-52fb-4b26-a2f9-b78c2604bca1"))
    
    static var test6 = Test(category: "Blood Test", name: "Iron and HB level", price: 4, description: "Blood test to check the Iron and Haemoglobin level", instructions: "No instructions", forMedicalFacility: alsalam, serviceType: .test,  storageLink: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/ironTest.jpeg?alt=media&token=6d53635c-e4b0-459e-b841-2ad94a6f976f"))
    
    
    
    static var test7 = Test(category: "Blood Test", name: "CBC Count", price: 3, description: "Blood test to check the CBC Count", instructions: "No instructions", forMedicalFacility: alsalam, serviceType: .test,  storageLink: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/testImages%2Fcbc-test.jpg?alt=media&token=07024708-c24b-4661-99a9-0b3605ee5499"))
    
    static var test8 = Test(category: "Blood Test", name: "Immunogloblin A", price: 3, description: "Blood test to check the Immunogloblin A levels", instructions: "No instructions", forMedicalFacility: alsalam, serviceType: .test,  storageLink: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/testImages%2Fimmuno.jpeg?alt=media&token=2b11df09-3902-4b0c-be2c-9e013d2ecebd"))
    
    static var test9 = Test(category: "Blood Test", name: "Immunogloblin G", price: 3, description: "Blood test to check the Immunogloblin G levels", instructions: "No instructions", forMedicalFacility: alsalam, serviceType: .test,  storageLink: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/testImages%2Fimmuno.jpeg?alt=media&token=2b11df09-3902-4b0c-be2c-9e013d2ecebd"))
    
    static var test10 = Test(category: "Blood Test", name: "Immunogloblin M", price: 3, description: "Blood test to check the Immunogloblin M levels", instructions: "No instructions", forMedicalFacility: alsalam, serviceType: .test, storageLink: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/testImages%2Fimmuno.jpeg?alt=media&token=2b11df09-3902-4b0c-be2c-9e013d2ecebd"))
    
    static var Pack4 = Package(expiryDate: DateComponents(calendar: Calendar.current, day: 29), tests: [test7,test8,test9,test10], name: "Immune System Test", price: 10, description: "Check blood to determine health of immune system", instructions: "Fasting is mandatory for 8 - 10 hours", forMedicalFacility: alsalam, serviceType: .test, storageLink: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/packageImages%2FImmune-System.png?alt=media&token=c52725cc-df17-4a47-b3ff-13ab408582ba"))
    
    
   // static var Pack1 = Package(expiryDate: DateComponents(calendar: Calendar.current, day: 29), tests: [test1,test2], name: "Vitamin B12 and Covid 19", price: 8, description: "Covid test and blood test for Vitamin B12", instructions: "Fasting is mandatory for 8 - 10 hours", forMedicalFacility: BML)
    
   // static var Pack2 = Package(expiryDate: DateComponents(calendar: Calendar.current, day: 31), tests: [test2,test3], name: "Vitamin D and Covid 19", price: 8, description: "Covid test and blood test for Vitamin D", instructions: "Fasting is mandatory for 8 hours", forMedicalFacility: expMed)
    
    static var Pack3 = Package(expiryDate: DateComponents(calendar: Calendar.current, day: 27), tests: [test5,test6], name: "Iron deficiency Pack", price: 8, description: "Blood test to check for iron deficiency", instructions: "No instructions", forMedicalFacility: alsalam,serviceType: .package,  storageLink: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/ironTest.jpeg?alt=media&token=6d53635c-e4b0-459e-b841-2ad94a6f976f"))
    
    
    // labs declaration
    
    static var BML = MedicalFacility(name: "Bahrain Medical Laboratory", phone: "17255522", city: "Manama", website: "bahrainmedicallab.com", alwaysOpen: false, type: FacilityType.lab, openingTime: DateComponents(calendar: Calendar.current, hour: 7, minute: 30), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), image: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Fbahrain_medical_laboratory_manama.jpg?alt=media&token=da4dd4ae-a3b1-49c1-b976-2defdc135524"), username: "bhmedlab@mokhtabri.com", password: "12345678")
    
    static var expMed = MedicalFacility(name: "ExpressMed Diagnostics", phone: "77248888", city: "Manama", website: "expressmedlabs.com", alwaysOpen: false, type: FacilityType.lab, openingTime: DateComponents(calendar: Calendar.current, hour: 8, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 20, minute: 0), image: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Fexpressmed_diagnostics_manama.jpg?alt=media&token=52327add-e906-47d5-a14e-e3f8d31e4708"), username: "expressmed@mokhtabri.com", password: "12345678")
    
    // TODO: ADD IMAGE
    static var gulfLab = MedicalFacility(name: "Gulf Medical Laboratories", phone: "17263999", city: "Manama", website: "https://www.gulflab.com/", alwaysOpen: false, type: .lab, openingTime: DateComponents(calendar: Calendar.current, hour: 8, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 20, minute: 0), username: "gulflab@mokhtabri.com", password: "12345678")
    
    static var manara = MedicalFacility(name: "Manara Medical Laboratories", phone: "17722999", city: "Manama", website: "eurofins.com", alwaysOpen: false, type: FacilityType.lab, openingTime: DateComponents(calendar: Calendar.current, hour: 8, minute: 30), closingTime: DateComponents(calendar: Calendar.current, hour: 20, minute: 30), image: URL(string:  "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Fmanara_medical_laboratories_manama.jpg?alt=media&token=2cf7a6fd-3073-4c70-aa09-9330e43d081c"), username: "manara@mokhtabri.com", password: "12345678")
    
    static let borg = MedicalFacility(name: "Al Borg Diagnostics", phone: "17100088", city: "Manama", website: "alborgdx.com", alwaysOpen: false, type: FacilityType.lab, openingTime: DateComponents(calendar: Calendar.current, hour: 8, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), image: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/fir-testing-512eb.appspot.com/o/facilityImages%2Fal_borg_diagnostics_manama.jpg?alt=media&token=b3726451-3ace-4988-92ef-9689eed685be"), username: "alborg@mokhtabri.com", password: "12345678")
    
    
    
    
    

}
