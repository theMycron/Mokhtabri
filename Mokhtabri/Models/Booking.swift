//
//  Booking.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

class Booking: Codable, Equatable, Comparable {
    var id: UUID
    var forPatient: Patient
    var ofMedicalService: MedicalService
    var bookingDate: DateComponents // use 'year', 'month' and 'day' components
    var status: BookingStatus
    
    init(forPatient: Patient, ofMedicalService: MedicalService, bookingDate: DateComponents, status: BookingStatus = BookingStatus.Active) {
        self.id = UUID()
        self.forPatient = forPatient
        self.ofMedicalService = ofMedicalService
        self.bookingDate = bookingDate
        self.status = status
        // add this booking to the list of bookings in the facility (NOT NEEDED)
//        ofMedicalService.forMedicalFacility.bookings.append(self)
    }
    
    static func == (lhs: Booking, rhs: Booking) -> Bool {
        return (lhs.id == rhs.id)
    }
    static func < (lhs: Booking, rhs: Booking) -> Bool {
        guard let lhsDate = dateComponentsToDate(lhs.bookingDate),
              let rhsDate = dateComponentsToDate(rhs.bookingDate)
        else {return true}
        return (lhsDate < rhsDate)
    }
    
    
    
}
