//
//  Booking.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

class Booking: Codable, Equatable, Comparable, CustomStringConvertible {
    var id: UUID
    var forPatient: Patient
    var ofMedicalService: MedicalService
    var serviceType: String
    var bookingDate: DateComponents // use 'year', 'month' and 'day' components
    var status: BookingStatus
    
    var description: String {
        return """
                -- Booking Info --
                ID: \(id)
                For Patient: \(forPatient.name)
                Booked For Facility: \(ofMedicalService.forMedicalFacility.name)
                Service Booked: \(ofMedicalService.name)
                Date of Booking: \(dateComponentsToDate(bookingDate)?.formatted(date: Date.FormatStyle.DateStyle.numeric, time: Date.FormatStyle.TimeStyle.omitted) ?? "None")
                Status: \(status.rawValue)
                """
    }
    
    enum CodingKeys: CodingKey, Codable {
        case id,forPatient,ofMedicalService,bookingDate,status, serviceType
    }
    
    init(forPatient: Patient, ofMedicalService: MedicalService, bookingDate: DateComponents, status: BookingStatus = BookingStatus.Active) {
        self.id = UUID()
        self.forPatient = forPatient
        self.ofMedicalService = ofMedicalService
        self.serviceType = ofMedicalService is Test ? "Test" : "Package"
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(forPatient, forKey: .forPatient)
        try container.encode(serviceType, forKey: .serviceType)
        if (ofMedicalService is Test) {
            try container.encode(ofMedicalService as! Test, forKey: .ofMedicalService)
        } else if (ofMedicalService is Package) {
            try container.encode(ofMedicalService as! Package, forKey: .ofMedicalService)
        }
        try container.encode(bookingDate, forKey: .bookingDate)
        try container.encode(status, forKey: .status)
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(UUID.self, forKey: .id)
        self.forPatient = try values.decode(Patient.self, forKey: .forPatient)
        self.serviceType = try values.decode(String.self, forKey: .serviceType)
        // decode service based on type
        switch (serviceType) {
        case "Test":
            self.ofMedicalService = try values.decode(Test.self, forKey: .ofMedicalService)
            break
        case "Package":
            self.ofMedicalService = try values.decode(Package.self, forKey: .ofMedicalService)
            break
        default:
            fatalError("Could not load service for booking")
            break
        }
        self.bookingDate = try values.decode(DateComponents.self, forKey: .bookingDate)
        self.status = try values.decode(BookingStatus.self, forKey: .status)
    }
}


