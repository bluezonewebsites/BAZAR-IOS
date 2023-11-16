//
//  Product.swift
//  Bazar
//
//  Created by Amal Elgalant on 25/04/2023.
//

import Foundation


struct ProductArrayPaging: Codable{
    var data: ProductArray!
    var code: Int!
    var msg: String!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
}

struct ProductFeatureObject: Codable{
    var data: [Product]!
    var code: Int!
    var msg: String!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
}

struct ProductArray: Codable{
    var data: [Product]!
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        
    }
    
    
}
struct ProductObject: Codable{
    var data: ProductDetailsObject!
    var code: Int!
    var msg: String!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
    
    
}
struct ProductDetailsObject: Codable{
    var data: Product!
    var images: [ProductImage]!
    var comments: [Comment]!
    enum CodingKeys: String, CodingKey {
        case data = "prod"
        case images = "images"
        case comments = "comments"
    }
    
    
}


struct Product: Codable{
    var id: Int?
    var name: String?
    var price: Int?
    var location: String?
    var image : String?
    var type: Int?
    var userName: String?
    var userLastName: String?
    var userPic: String?
    var userVerified: Int?
    var countryNameAr: String?
    var countryNameEn: String?
    var currencyAr: String?
    var currencyEn: String?
    var cityNameAr: String?
    var cityNameEn: String?
    var createdAt: String?
    var description: String?
    var fav: Int?
    var phone: String?
    var whatsappPhone: String?
    var hasChat: String?
    var hasWhatsapp: String?
    var hasPhone: String?
    var userId: Int?
    var countryId:Int?
    var cityId: Int?
    var regionId:Int?
    var mainImage:String?
    var isStore:Bool?
    var isFeature:Bool?
    var status:String?
    var views:Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case price = "price"
        case location = "loc"
        case image = "prods_image"
        case type = "tajeer_or_sell"
        case userName = "user_name"
        case userLastName = "user_last_name"
        case userPic = "user_pic"
//        case userVerified = "user_verified"
        case countryNameAr = "countries_name_ar"
        case countryNameEn = "countries_name_en"
        case currencyAr = "countries_currency_ar"
        case currencyEn = "countries_currency_en"
        case cityNameAr = "cities_name_ar"
        case cityNameEn = "cities_name_en"
        case createdAt = "created_at"
        case description = "descr"
        case fav = "fav"
        case userId = "uid"
        case phone = "phone"
        case whatsappPhone = "wts"
        case hasChat = "has_chat"
        case hasWhatsapp = "has_wts"
        case hasPhone = "has_phone"
        case countryId = "country_id"
        case cityId = "city_id"
        case regionId = "region_id"
        case mainImage = "img"
        case isStore = "is_store"
        case isFeature = "is_feature"
        case status = "status"
        case views = "views"
    }
}
struct ProductImage: Codable{
    var id: Int?
    var prodID: Int?
    var pimage: String?
    var imageType: String?
    var createdAt: String?
    var updatedAt: String?
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case prodID = "prod_id"
        case pimage = "img"
        case imageType = "mtype"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case image = "image"
    }
}

