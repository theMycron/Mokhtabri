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
    // should also store an image, not sure how
    
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
        super.init(username: username, password: password, userType: UserType.lab)
    }
    
    
}
