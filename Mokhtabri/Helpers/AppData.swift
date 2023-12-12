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
}

