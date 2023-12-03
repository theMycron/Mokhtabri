//
//  Hospital.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

class Lab: User {
    var name: String
    var phone: String
    var city: String
    var alwaysOpen: Bool
    var openingTime: String
    var closingTime: String
    
    init(name: String, phone: String, city: String, alwaysOpen: Bool, openingTime: String, closingTime: String, username: String, password: String) {
        self.name = name
        self.phone = phone
        self.city = city
        self.alwaysOpen = alwaysOpen
        self.openingTime = openingTime
        self.closingTime = closingTime
        super.init(username: username, password: password, userType: UserType.lab)
    }
    
    
}
