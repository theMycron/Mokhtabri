import Foundation

class MedicalService: Codable, Equatable, Comparable, CustomStringConvertible {
    var id: UUID
    var name: String
    var price: Float
    var serviceDescription: String
    var instructions: String
    var forMedicalFacility: MedicalFacility
    var image: Data? // Property to store an image
    
    var description: String {
        return """
                -- Service Info --
                ID: \(id)
                Name: \(name)
                Price: \(price) BHD
                Description: \(serviceDescription)
                Instructions: \(instructions)
                Owned By Facility: \(forMedicalFacility.name)
                """
    }
    

    enum CodingKeys: Codable, CodingKey {
        case id, name, price, description, instructions, forMedicalFacility, image // Include 'image' in the CodingKeys
    }
    
    init(name: String, price: Float, description: String, instructions: String, forMedicalFacility: MedicalFacility) {
        self.id = UUID()
        self.name = name
        self.price = price
        self.serviceDescription = description
        self.instructions = instructions
        self.forMedicalFacility = forMedicalFacility
        self.image = nil // Initialize the image property
    }
    
    static func == (lhs: MedicalService, rhs: MedicalService) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    static func < (lhs: MedicalService, rhs: MedicalService) -> Bool {
        return (lhs.name < rhs.name)
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(price, forKey: .price)
        try container.encode(serviceDescription, forKey: .description)
        try container.encode(instructions, forKey: .instructions)
        try container.encode(forMedicalFacility, forKey: .forMedicalFacility)
        try container.encode(encodeImage(), forKey: .image)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(Float.self, forKey: .price)
        self.serviceDescription = try container.decode(String.self, forKey: .description)
        self.instructions = try container.decode(String.self, forKey: .instructions)
        self.forMedicalFacility = try container.decode(MedicalFacility.self, forKey: .forMedicalFacility)
        
        // Decode image as base64-encoded data
        if let imageBase64 = try container.decodeIfPresent(String.self, forKey: .image) {
            self.image = Data(base64Encoded: imageBase64)
        } else {
            self.image = nil
        }
    }
    
    // Encode the image as base64-encoded string
    func encodeImage() -> String? {
        if let image = self.image {
            return image.base64EncodedString()
        }
        return nil
    }
}
