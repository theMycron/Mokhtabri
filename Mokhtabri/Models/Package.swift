//
//  Package.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 03/12/2023.
//

import Foundation

class Package: MedicalService {
    var expiryDate: DateComponents? // use 'year', 'month' and 'day' components, may not expire
    var tests: [Test]
    
    override var description: String {
        // get the expiry date if it is not nil
        var listedExpiryDate = ""
        if let date = expiryDate {
            listedExpiryDate = dateComponentsToDate(date)!.formatted(date: Date.FormatStyle.DateStyle.numeric, time: Date.FormatStyle.TimeStyle.omitted)
        } else {
            listedExpiryDate = "None"
        }
        // get all tests and place them in a string
        var listedTests = ""
        for test in tests {
            listedTests.append("\(test.name)\n")
        }
        return """
                \(super.description)
                Type: Package
                Expiry Date: \(listedExpiryDate)
                - List of Tests -
                \(listedTests)
                """
    }
    
    enum CodingKeys: Codable, CodingKey {
        case expiryDate, tests
    }
    
    init(expiryDate: DateComponents, tests: [Test], name: String, price: Float, description: String, instructions: String, forMedicalFacility: MedicalFacility, serviceType: ServiceType) {
        self.expiryDate = expiryDate
        self.tests = tests
        super.init(name: name, price: price, description: description, instructions: instructions, forMedicalFacility: forMedicalFacility, serviceType: serviceType)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.expiryDate = try values.decodeIfPresent(DateComponents.self, forKey: .expiryDate)!
        self.tests = try values.decodeIfPresent([Test].self, forKey: .tests)!
        try super.init(from: decoder)
    }
    
    
}
