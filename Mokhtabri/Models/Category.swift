//
//  Category.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 04/12/2023.
//

import Foundation

// this class is meant to be used for tests and there must be a static list of categories stored in the app.
// not sure if this is the best approach

class Category: Codable, Equatable, Comparable, CustomStringConvertible {
    var id: UUID
    var name: String
    
    var description: String {
        return """
                -- Category Info --
                ID: \(id)
                Name: \(name)
                """
    }
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
    
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return (lhs.id == rhs.id)
    }
    static func < (lhs: Category, rhs: Category) -> Bool {
        return (lhs.name < rhs.name)
    }
}
