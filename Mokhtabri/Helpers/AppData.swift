//
//  AppData.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 06/12/2023.
//

import Foundation

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
    
    static func load(){
        if bookings.isEmpty {
            bookings = sampleBookings
        }
    }
    
    static var sampleBookings = [
        
        Booking(forPatient: Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#")
    , ofMedicalService: MedicalService(name: "VitaminB12", price: 10, description: "Blood test for vitamin B12", instructions: "Fasting required for 8 to 12 hours", forMedicalFacility: MedicalFacility(name: "Al Hilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: true, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "AlHihalEastRiffa", password: "alhilal")), bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 1, day: 10)),
                    
                    
                    Booking(forPatient: Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#")
                , ofMedicalService: MedicalService(name: "Vitamin D", price: 10, description: "Blood test for vitamin B12", instructions: "Fasting required for 8 to 12 hours", forMedicalFacility: MedicalFacility(name: "Al Hilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: true, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "AlHihalEastRiffa", password: "alhilal")), bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 2, day: 15)),
    
    
                    Booking(forPatient: Patient(firstName: "Noora", lastName: "Qasim", phone: "12345678", cpr: "031003257", email: "nooraw376@gmail.com", gender: Gender.female, dateOfBirth: DateComponents(calendar: Calendar.current, year: 2003, month: 10, day: 12), username: "NooraW", password: "12345#")
                , ofMedicalService: MedicalService(name: "Iron and Hb", price: 10, description: "Blood test for vitamin B12", instructions: "Fasting required for 8 to 12 hours", forMedicalFacility: MedicalFacility(name: "Al Hilal Hospital", phone: "12345689", city: "East Riffa", website: "Alhilal.com", alwaysOpen: false, type: .hospital, openingTime: DateComponents(calendar: Calendar.current, hour: 9, minute: 0), closingTime: DateComponents(calendar: Calendar.current, hour: 21, minute: 0), username: "AlHihalEastRiffa", password: "alhilal")), bookingDate: DateComponents(calendar: Calendar.current, year: 2023, month: 3, day: 20))]
}

