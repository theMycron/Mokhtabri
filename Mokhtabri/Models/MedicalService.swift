//
//  MedicalService.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 04/12/2023.
//

import Foundation

class MedicalService: Codable {
    var name: String
    var price: Float
    var description: String
    var instructions: String
    var forMedicalFacility: MedicalFacility
    // should also store an image, not sure how
    
    enum CodingKeys: Codable, CodingKey {
        case name, price, description, instructions, forMedicalFacility
    }
    
    init(name: String, price: Float, description: String, instructions: String, forMedicalFacility: MedicalFacility) {
        self.name = name
        self.price = price
        self.description = description
        self.instructions = instructions
        self.forMedicalFacility = forMedicalFacility
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(Float.self, forKey: .price)
        self.description = try container.decode(String.self, forKey: .description)
        self.instructions = try container.decode(String.self, forKey: .instructions)
        self.forMedicalFacility = try container.decode(MedicalFacility.self, forKey: .forMedicalFacility)
    }
}
