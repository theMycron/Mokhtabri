//
//  Booking.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

class Booking {
    var forPatient: Patient
    var ofMedicalService: MedicalService
    var bookingDate: DateComponents // use 'year', 'month' and 'day' components
    var status: BookingStatus
    
    init(forPatient: Patient, ofMedicalService: MedicalService, bookingDate: DateComponents, status: BookingStatus) {
        self.forPatient = forPatient
        self.ofMedicalService = ofMedicalService
        self.bookingDate = bookingDate
        self.status = status
    }
}
