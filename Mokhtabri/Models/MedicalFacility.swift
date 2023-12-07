//
//  Hospital.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

class MedicalFacility: User {
    var name: String
    var phone: String
    var city: String
    var website: String
    var alwaysOpen: Bool
    var type: FacilityType
    // openingTime and closingTime will be stored with 'hour' and 'minute' properties of DateComponents
    var openingTime: DateComponents
    var closingTime: DateComponents
    var medicalServices: [MedicalService]
    var bookings: [Booking]
    // should also store an image, not sure how
    
    enum CodingKeys: Codable, CodingKey {
        case name, phone, city, website, alwaysOpen, type, openingTime, closingTime, medicalServices, bookings
    }
    
    init(name: String, phone: String, city: String, website: String, alwaysOpen: Bool, type: FacilityType, openingTime: DateComponents, closingTime: DateComponents, username: String, password: String) {
        self.name = name
        self.phone = phone
        self.city = city
        self.website = website
        self.alwaysOpen = alwaysOpen
        self.type = type
        self.openingTime = openingTime
        self.closingTime = closingTime
        self.medicalServices = []
        self.bookings = []
        super.init(username: username, password: password, userType: UserType.lab)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decodeIfPresent(String.self, forKey: .name)!
        self.phone = try values.decodeIfPresent(String.self, forKey: .phone)!
        self.city = try values.decodeIfPresent(String.self, forKey: .city)!
        self.website = try values.decodeIfPresent(String.self, forKey: .website)!
        self.alwaysOpen = try values.decodeIfPresent(Bool.self, forKey: .alwaysOpen)!
        self.type = try values.decodeIfPresent(FacilityType.self, forKey: .type)!
        self.openingTime = try values.decodeIfPresent(DateComponents.self, forKey: .openingTime)!
        self.closingTime = try values.decodeIfPresent(DateComponents.self, forKey: .closingTime)!
        self.medicalServices = try values.decodeIfPresent([MedicalService].self, forKey: .medicalServices)!
        self.bookings = try values.decodeIfPresent([Booking].self, forKey: .bookings)!
        // decode base class
        try super.init(from: decoder)
    }
    
    
    
    
}
