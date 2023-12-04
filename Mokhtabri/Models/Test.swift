//
//  Test.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

class Test: MedicalService {
    var category: Category
    
    init(category: Category, name: String, price: Float, description: String, instructions: String, forMedicalFacility: MedicalFacility) {
        self.category = category
        super.init(name: name, price: price, description: description, instructions: instructions, forMedicalFacility: forMedicalFacility)
    }
}
