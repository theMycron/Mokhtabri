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
}
