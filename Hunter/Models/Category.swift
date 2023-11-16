//
//  Category.swift
//  Bazar
//
//  Created by Amal Elgalant on 25/04/2023.
//

import Foundation

struct CategoryArray: Codable{
    var data: [Category]!
    var code: Int!
    var msg: String!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
    
    
}
struct CategoryObject: Codable{
    var data: Category!
    var code: Int!
    var msg: String!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
    
    
}

struct Category:Codable{
    var nameAr: String?
    var nameEn: String?
    var image: String?
    var id: Int?
    var hasSubCat: Int?
    var ask: Int?
    var tajeer: Int?
    
    init (nameAr: String, nameEn: String, id: Int, hasSubCat: Int){
        self.nameAr = nameAr
        self.nameEn = nameEn
        self.id = id
        self.hasSubCat = hasSubCat
        
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case hasSubCat = "has_scat"
        case image = "pic"
        case tajeer = "tajeer"
        case ask = "ask"
        case nameEn = "name_en"
        case nameAr = "name_ar"

        
    }
    
    
}
