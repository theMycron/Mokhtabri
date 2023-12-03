//
//  User.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

class User {
    var username: String
    var password: String
    var id: UUID
    var userType: UserType
    
    init(username: String, password: String, userType: UserType) {
        self.username = username
        self.password = password
        self.id = UUID()
        self.userType = userType
    }
    
}
