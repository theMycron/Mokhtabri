//
//  Patient.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

class Patient: User {
    var firstName: String
    var lastName: String
    var phone: String
    var cpr: String
    var email: String
    var gender: Gender
    var dateOfBirth: DateComponents // use 'year', 'month' and 'day' components
    var bookings: [Booking]
    var age: Int {
        // TODO: calculate age from dob
        return 1
    } // calculated get-only property
    
    enum CodingKeys: Codable, CodingKey {
        case firstName, lastName, phone, cpr, email, gender, dateOfBirth, bookings
    }
    
    init(firstName: String, lastName: String, phone: String, cpr: String, email: String, gender: Gender, dateOfBirth: DateComponents, username: String, password: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.cpr = cpr
        self.email = email
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        self.bookings = []
        super.init(username: username, password: password, userType: .patient)
    }
    
    
    
    // this initializer decodes the object and is required for coding functionality
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try values.decodeIfPresent(String.self, forKey: .firstName)!
        self.lastName = try values.decodeIfPresent(String.self, forKey: .lastName)!
        self.phone = try values.decodeIfPresent(String.self, forKey: .phone)!
        self.cpr = try values.decodeIfPresent(String.self, forKey: .cpr)!
        self.email = try values.decodeIfPresent(String.self, forKey: .email)!
        self.gender = try values.decodeIfPresent(Gender.self, forKey: .gender)!
        self.dateOfBirth = try values.decodeIfPresent(DateComponents.self, forKey: .dateOfBirth)!
        self.bookings = try values.decodeIfPresent([Booking].self, forKey: .bookings)!
        // decode base class
        try super.init(from: decoder)
            
    }
    
    
}
