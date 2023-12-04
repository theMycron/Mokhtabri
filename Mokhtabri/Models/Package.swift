//
//  Package.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

class Package: MedicalService {
    var expiryDate: DateComponents // use 'year', 'month' and 'day' components
    var tests: [Test]
    
    init(expiryDate: DateComponents, tests: [Test], name: String, price: Float, description: String, instructions: String, forMedicalFacility: MedicalFacility) {
        self.expiryDate = expiryDate
        self.tests = tests
        super.init(name: name, price: price, description: description, instructions: instructions, forMedicalFacility: forMedicalFacility)
    }
}
