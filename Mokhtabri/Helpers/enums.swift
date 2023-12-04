//
//  enums.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

enum Gender: String {
    case male = "Male", female = "Female"
}

enum FacilityType: String {
    case lab = "Lab", hospital = "Hospital"
}

enum UserType {
    case patient, lab, admin
}

enum BookingStatus: String {
    case booked = "Booked", completed = "Completed", cancelled = "Cancelled"
}
