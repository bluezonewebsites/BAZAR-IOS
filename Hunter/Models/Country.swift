//
//  Country.swift
//  Bazar
//
//  Created by Amal Elgalant on 28/04/2023.
//


import Foundation

struct CountryArray: Codable{
    var data: [Country]!
    var code: Int!
    var msg: String!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
    
    
}
struct CountryObject: Codable{
    var data: Country!
    var code: Int!
    var msg: String!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
    
    
}

struct Country:Codable{
    var nameAr: String?
    var nameEn: String?
    var id: Int?
    var image: String?
    var code: String?
    
    init(nameAr: String? = nil, nameEn: String? = nil, id: Int? = nil, code: String? = nil) {
        self.nameAr = nameAr
        self.nameEn = nameEn
        self.id = id
        self.code = code
    }
    
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case code = "code"
        case image = "pic"
        
    }
    
    
}
