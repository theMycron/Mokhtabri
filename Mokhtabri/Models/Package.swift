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
    var imageDownloadURL: URL? // Property to store an image download link
    // returns a formatted string for the expiryDate
    var formattedExpiryDate: String {
        // get the expiry date if it is not nil
        var listedExpiryDate = ""
        if let date = expiryDate {
            listedExpiryDate = dateComponentsToDate(date)!.formatted(date: Date.FormatStyle.DateStyle.numeric, time: Date.FormatStyle.TimeStyle.omitted)
        } else {
            listedExpiryDate = "None"
        }
        return listedExpiryDate
    }
    
    override var description: String {
        // get all tests and place them in a string
        var listedTests = ""
        for test in tests {
            listedTests.append("\(test.name)\n")
        }
        return """
                \(super.description)
                Type: Package
                Expiry Date: \(formattedExpiryDate)
                - List of Tests -
                \(listedTests)
                """
    }
    
    enum CodingKeys: Codable, CodingKey {
        case expiryDate, tests, image
    }
    
    init(expiryDate: DateComponents, tests: [Test], name: String, price: Float, description: String, instructions: String, forMedicalFacility: MedicalFacility, serviceType: ServiceType, imageDownloadURL: URL? = nil, storageLink: URL?) {

        self.expiryDate = expiryDate
        self.tests = tests
        self.imageDownloadURL = imageDownloadURL // Initialize the image property
        super.init(name: name, price: price, description: description, instructions: instructions, forMedicalFacility: forMedicalFacility, serviceType: serviceType,storageLink: storageLink)

    }
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(expiryDate, forKey: .expiryDate)
        try container.encode(tests, forKey: .tests)
        try container.encode(imageDownloadURL, forKey: .image)
        let superEncoder = container.superEncoder()
        try super.encode(to: superEncoder)
    }
    
    // required custom decoder
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.expiryDate = try values.decodeIfPresent(DateComponents.self, forKey: .expiryDate)
        self.tests = try values.decode([Test].self, forKey: .tests)
        self.imageDownloadURL = try values.decodeIfPresent(URL.self, forKey: .image)
        let superDecoder = try values.superDecoder()
        try super.init(from: superDecoder)
    }
    
    
}
