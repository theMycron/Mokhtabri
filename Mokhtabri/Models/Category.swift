//
//  Category.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 04/12/2023.
//

import Foundation

// this class is meant to be used for tests and there must be a static list of categories stored in the app.
// not sure if this is the best approach

class Category: Codable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
