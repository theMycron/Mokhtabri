//
//  Test.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

class Test: MedicalService {
    var category: String
    
    override var description: String {
        return """
                \(super.description)
                Type: Test
                Category: \(category)
                """
    }
    
    enum CodingKeys: Codable, CodingKey {
        case category
    }
    
    init(category: String, name: String, price: Float, description: String, instructions: String, forMedicalFacility: MedicalFacility) {
        self.category = category
        super.init(name: name, price: price, description: description, instructions: instructions, forMedicalFacility: forMedicalFacility)
    }
    
    // required custom decoder
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.category = try values.decodeIfPresent(String.self, forKey: .category)!
        try super.init(from: decoder)
    }
}
