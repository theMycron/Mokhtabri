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
    
    enum CodingKeys: Codable, CodingKey {
        case expiryDate, tests
    }
    
    init(expiryDate: DateComponents, tests: [Test], name: String, price: Float, description: String, instructions: String, forMedicalFacility: MedicalFacility) {
        self.expiryDate = expiryDate
        self.tests = tests
        super.init(name: name, price: price, description: description, instructions: instructions, forMedicalFacility: forMedicalFacility)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.expiryDate = try values.decodeIfPresent(DateComponents.self, forKey: .expiryDate)!
        self.tests = try values.decodeIfPresent([Test].self, forKey: .tests)!
        try super.init(from: decoder)
    }
    
    
}
