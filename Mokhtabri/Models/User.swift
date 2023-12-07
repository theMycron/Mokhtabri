//
//  User.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

class User: Codable {
    var username: String
    var password: String
    var id: UUID
    var userType: UserType
    
    enum CodingKeys: Codable, CodingKey {
        case username, password, id, userType
    }
    
    init(username: String, password: String, userType: UserType) {
        self.username = username
        self.password = password
        self.id = UUID()
        self.userType = userType
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.password = try container.decode(String.self, forKey: .password)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.userType = try container.decode(UserType.self, forKey: .userType)
    }
    
}
