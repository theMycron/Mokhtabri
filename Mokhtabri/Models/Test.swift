//
//  Test.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

class Test: MedicalService {
    var category: Category
    
    override var description: String {
        return """
                \(super.description)
                Type: Test
                Category: \(category.name)
                """
    }
    
    enum CodingKeys: Codable, CodingKey {
        case category
    }
    
    init(category: Category, name: String, price: Float, description: String, instructions: String, forMedicalFacility: MedicalFacility, serviceType: ServiceType) {
        self.category = category
        super.init(name: name, price: price, description: description, instructions: instructions, forMedicalFacility: forMedicalFacility, serviceType: serviceType)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.category = try values.decodeIfPresent(Category.self, forKey: .category)!
        try super.init(from: decoder)
    }
}
