//
//  enums.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

enum Gender: String, Codable {
    case male = "Male", female = "Female"
}

enum FacilityType: String, Codable {
    case lab = "Lab", hospital = "Hospital"
}

enum UserType: Codable {
    case patient, lab, admin
}

enum BookingStatus: String, Codable {
    case Active = "Active", Completed = "Completed", Cancelled = "Cancelled"
}
