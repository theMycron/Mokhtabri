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
    static var patients: [Patient] = []
    static var facilities: [MedicalFacility] = []
    static var services: [MedicalService] = []
    static var bookings: [Booking] = []
    static var categories: [Category] = []
    
    static func wipe() {
        admin = []
        patients = []
        facilities = []
        services = []
        bookings = []
        categories = []
    }
    
    static var sampleBookings = [
        
        Booking(forPatient: Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#")
                , ofMedicalService: Test(category: Category(name: "Blood Test"), name: "VitaminB12", price: 10, description: "blood test for vitaminb12", instructions: "fasting 8-12 hours prior is mandatory", forMedicalFacility:  MedicalFacility(name: "Al Hilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: false, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "AlHihalEastRiffa", password: "alhilal")), bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 1, day: 10)),
        
        
        Booking(forPatient: Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#")
                , ofMedicalService: MedicalService(name: "Vitamin D", price: 10, description: "Blood test for vitamin B12", instructions: "Fasting required for 8 to 12 hours", forMedicalFacility: MedicalFacility(name: "Al Hilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: true, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "AlHihalEastRiffa", password: "alhilal")), bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 2, day: 15)),
        
        
        Booking(forPatient: Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#")
                , ofMedicalService: MedicalService(name: "Iron and Hb", price: 10, description: "Blood test for vitamin B12", instructions: "Fasting required for 8 to 12 hours", forMedicalFacility: MedicalFacility(name: "Al Hilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: false, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "AlHihalEastRiffa", password: "alhilal")), bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 3, day: 20))]
    
    static var listOfTests = [test1,test2,test3,test4]
    
    static var alhilal = MedicalFacility(name: "ALHilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: false, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "alhilalER", password: "alhilal")
    
    
    static var alsalam = MedicalFacility(name: "Alsalam Hospital", phone: "13101010", city: "Riffa", website: "https://www.alsalam.care", alwaysOpen: true, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 0, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 0, minute: 0), username: "alsalam", password: "1234")
     
    static var royal = MedicalFacility(name: "Royal Bahrain Hospital", phone: "17246800", city: "Salmaniya", website: "www.royalbarainhospital.com", alwaysOpen: true, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 0, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 0, minute: 0), username: "royal", password: "1432")
    
    static var test1 = Test(category: Category(name: "Blood Test"), name: "VitaminB12", price: 10, description: "blood test for vitaminb12", instructions: "fasting 8-12 hours prior is mandatory", forMedicalFacility:  alhilal)
    
    static var test2 =  Test(category: Category(name: "Viral Test"), name: "Covid 19 PCR", price: 15, description: "Covid 19 Test", instructions: "None", forMedicalFacility: alhilal)
    
    static var test3 = Test(category: Category(name: "Blood Test"), name: "Vitamin D", price: 10, description: "blood test for vitamin D", instructions: "fasting 8-12 hours prior is mandatory", forMedicalFacility:  alhilal)
    
    static var test4 = Package(expiryDate: DateComponents(calendar: Calendar.current, day: 29), tests: [test1,test3], name: "ALH Vitamin D & B12", price: 5, description: "Dual", instructions: "Fasting is mandatory", forMedicalFacility: alhilal)
    
    static var hospitals = [alhilal,alsalam,royal]
    
    static func load(){
        if bookings.isEmpty {
            bookings = sampleBookings
            services = listOfTests
            facilities = hospitals
        }
    }}
