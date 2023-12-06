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
    
    init(name: String, price: Float, description: String, instructions: String, forMedicalFacility: MedicalFacility) {
        self.name = name
        self.price = price
        self.description = description
        self.instructions = instructions
        self.forMedicalFacility = forMedicalFacility
    }
}
