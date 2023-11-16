//
//  SpecialProductsModel.swift
//  Bazar
//
//  Created by iOSayed on 31/01/2023.
//  Copyright © 2023 roll. All rights reserved.
//


import Foundation

// MARK: - SpecialProductModel
struct SpecialProductModel: Codable {
    let message: String?
    var data: ProductSpecialModel?
    
    init(message: String? = nil, data: ProductSpecialModel? = nil) {
       self.message = message
       self.data = data
   }
}

// MARK: - DataClass
struct ProductSpecialModel: Codable {
    let currentPage: Int?
    var data: [SpecialProdModel]?
    let lastPage: Int?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case lastPage = "last_page"
        case to, total
    }
}

// MARK: - SpecialProdModel
struct SpecialProdModel: Codable {
    let id, catID, subCatID, uid: Int?
    let name: String?
    let price: Int?
    let userPic:String?
    let createdAt, loc: String?
    let countryID, cityID, regionID, lat: Int?
    let lng: Int?
    let descr, phone, wts, hasChat: String?
    let hasWts, hasPhone: String?
    let amount, tajeerOrSell, views, calls: Int?
    let errors, durationUseName: String?
    let durationUse, sellCost: Int?
    let brandID, materialID, color, colorName: String?
    let prodSize, img: String?
    let deleted: Int?
    let mainCatName, subCatName: String?
    let prodsImage, mtype: String?
    let userName, userLastName: String?
    let userVerified: Int?
    let countriesNameAr, countriesNameEn, countriesCurrencyAr, countriesCurrencyEn: String?
    let citiesNameAr, citiesNameEn, regionsNameAr, regionsNameEn: String?

    enum CodingKeys: String, CodingKey {
        case id
        case catID = "cat_id"
        case userPic = "user_pic"
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
        case tajeerOrSell = "tajeer_or_sell"
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
        case mainCatName = "main_cat_name"
        case subCatName = "sub_cat_name"
        case prodsImage = "prods_image"
        case mtype
        case userName = "user_name"
        case userLastName = "user_last_name"
        case userVerified = "user_verified"
        case countriesNameAr = "countries_name_ar"
        case countriesNameEn = "countries_name_en"
        case countriesCurrencyAr = "countries_currency_ar"
        case countriesCurrencyEn = "countries_currency_en"
        case citiesNameAr = "cities_name_ar"
        case citiesNameEn = "cities_name_en"
        case regionsNameAr = "regions_name_ar"
        case regionsNameEn = "regions_name_en"
    }
}
