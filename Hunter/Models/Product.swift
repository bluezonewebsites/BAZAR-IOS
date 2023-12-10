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
    var adType:String?
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
    var mainCatNameAr : String?
    var mainCatNameEn:String?
    var subCatNameAr: String?
    var subCatNameEn: String?
    var comments : Int?
    
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
        case adType = "ad_type"
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
        case mainCatNameAr = "main_cat_name_ar"
        case mainCatNameEn = "main_cat_name_en"
        case subCatNameAr = "sub_cat_name_ar"
        case subCatNameEn = "sub_cat_name_en"
        case comments
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

// MARK: - RepostProductModel
struct RepostProductModel: Codable {
    let message: String?
    let data: RepostProductObject?
    let success: Bool?
    let statusCode: Int?
}

// MARK: - DataClass
struct RepostProductObject: Codable {
    let id, catID, subCatID, uid: Int?
    let name: String?
    let price: Int?
    let createdAt, loc: String?
    let countryID, cityID, regionID, lat: Int?
    let lng: Int?
    let descr, phone, wts, hasChat: String?
    let hasWts, hasPhone: String?
    let amount: Int?
    let adType: String?
    let views, calls: Int?
    let errors, durationUseName: String?
    let durationUse, sellCost: Int?
    let brandID, materialID, color, colorName: String?
    let prodSize, img: String?
    let deleted: Int?
    let updatedAt: String?
    let mainCatNameAr, mainCatNameEn, subCatNameAr, subCatNameEn: String?
    let prodsImage, mtype, userName, userPhone: String?
    let userPic: String?
    let userVerified, isAdvertiser: Int?
    let countriesNameAr, countriesNameEn, countriesCurrencyAr, countriesCurrencyEn: String?
    let citiesNameAr, citiesNameEn, regionsNameAr, regionsNameEn: String?
    let comments, fav: Int?
    let isStore, isFeature: Bool?
    let status, startDate, endDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case catID = "cat_id"
        case subCatID = "sub_cat_id"
        case uid, name, price
        case createdAt = "created_at"
        case loc
        case countryID = "country_id"
        case cityID = "city_id"
        case regionID = "region_id"
        case lat, lng, descr, phone, wts
        case hasChat = "has_chat"
        case hasWts = "has_wts"
        case hasPhone = "has_phone"
        case amount
        case adType = "ad_type"
        case views, calls, errors
        case durationUseName = "duration_use_name"
        case durationUse = "duration_use"
        case sellCost = "sell_cost"
        case brandID = "brand_id"
        case materialID = "material_id"
        case color
        case colorName = "color_name"
        case prodSize = "prod_size"
        case img, deleted
        case updatedAt = "updated_at"
        case mainCatNameAr = "main_cat_name_ar"
        case mainCatNameEn = "main_cat_name_en"
        case subCatNameAr = "sub_cat_name_ar"
        case subCatNameEn = "sub_cat_name_en"
        case prodsImage = "prods_image"
        case mtype
        case userName = "user_name"
        case userPhone = "user_phone"
        case userPic = "user_pic"
        case userVerified = "user_verified"
        case isAdvertiser = "is_advertiser"
        case countriesNameAr = "countries_name_ar"
        case countriesNameEn = "countries_name_en"
        case countriesCurrencyAr = "countries_currency_ar"
        case countriesCurrencyEn = "countries_currency_en"
        case citiesNameAr = "cities_name_ar"
        case citiesNameEn = "cities_name_en"
        case regionsNameAr = "regions_name_ar"
        case regionsNameEn = "regions_name_en"
        case comments, fav
        case isStore = "is_store"
        case isFeature = "is_feature"
        case status
        case startDate = "start_date"
        case endDate = "end_date"
    }
}
