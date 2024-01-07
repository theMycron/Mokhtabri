//
//  Test.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

class Test: MedicalService {
    var category: String
    var imageDownloadURL: URL?
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
    
    init(category: String, name: String, price: Float, description: String, instructions: String, forMedicalFacility: MedicalFacility, serviceType: ServiceType, storageLink : URL?) {

        self.category = category
        super.init(name: name, price: price, description: description, instructions: instructions, forMedicalFacility: forMedicalFacility, serviceType: serviceType, storageLink: storageLink)

    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(category, forKey: .category)
        let superEncoder = container.superEncoder()
        try super.encode(to: superEncoder)
    }
    
    // required custom decoder
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.category = try values.decode(String.self, forKey: .category)
        let superDecoder = try values.superDecoder()
        try super.init(from: superDecoder)
    }
}
