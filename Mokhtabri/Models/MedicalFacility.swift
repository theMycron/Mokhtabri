import Foundation

class MedicalFacility: User {
    var name: String
    var phone: String
    var city: String
    var website: String
    var alwaysOpen: Bool
    var type: FacilityType
    var openingTime: DateComponents
    var closingTime: DateComponents
//    var medicalServices: [MedicalService]
//    var medicalService: MedicalService
//    var bookings: [Booking]
    var image: Data? // Property to store an image

    enum CodingKeys: Codable, CodingKey {
        case name, phone, city, website, alwaysOpen, type, openingTime, closingTime, medicalServices, bookings, image
    }
    
    init(name: String, phone: String, city: String, website: String, alwaysOpen: Bool, type: FacilityType, openingTime: DateComponents, closingTime: DateComponents, username: String, password: String) {
        self.name = name
        self.phone = phone
        self.city = city
        self.website = website
        self.alwaysOpen = alwaysOpen
        self.type = type
        self.openingTime = openingTime
        self.closingTime = closingTime
//        self.medicalServices = []
//        self.bookings = []
        self.image = nil // Initialize the image property
        super.init(username: username, password: password, userType: UserType.lab)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(phone, forKey: .phone)
        try container.encode(city, forKey: .city)
        try container.encode(website, forKey: .website)
        try container.encode(alwaysOpen, forKey: .alwaysOpen)
        try container.encode(type, forKey: .type)
        try container.encode(openingTime, forKey: .openingTime)
        try container.encode(closingTime, forKey: .closingTime)
//        try container.encode(medicalServices, forKey: .medicalServices)
//        try container.encode(bookings, forKey: .bookings)
        try super.encode(to: encoder)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        self.phone = try values.decode(String.self, forKey: .phone)
        self.city = try values.decode(String.self, forKey: .city)
        self.website = try values.decode(String.self, forKey: .website)
        self.alwaysOpen = try values.decode(Bool.self, forKey: .alwaysOpen)
        self.type = try values.decode(FacilityType.self, forKey: .type)
        self.openingTime = try values.decode(DateComponents.self, forKey: .openingTime)
        self.closingTime = try values.decode(DateComponents.self, forKey: .closingTime)
//        self.medicalServices = try values.decode([MedicalService].self, forKey: .medicalServices)
//        self.bookings = try values.decode([Booking].self, forKey: .bookings)
        
        // Decode image as base64-encoded data
        if let imageBase64 = try values.decodeIfPresent(String.self, forKey: .image) {
            self.image = Data(base64Encoded: imageBase64)
        } else {
            self.image = nil
        }

        try super.init(from: decoder)
    }
    
    // Encode the image as base64-encoded string
    func encodeImage() -> String? {
        if let image = self.image {
            return image.base64EncodedString()
        }
        return nil
    }
}
