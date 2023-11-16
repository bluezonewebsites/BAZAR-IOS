//
//  SliderModel.swift
//  Bazar
//
//  Created by iOSayed on 13/09/2023.
//

import Foundation

// MARK: - SliderModel
struct SliderModel: Codable {
    let message: String?
    let data: Slider?
    let success: Bool?
    let statusCode: Int?
}

// MARK: - DataClass
struct Slider: Codable {
    let prods: [SliderObject]?

    enum CodingKeys: String, CodingKey {
        case prods
    }
}

// MARK: - Prod
struct SliderObject: Codable {
    let id, catID, subCatID, uid: Int?
    let name: String?
    let price: Int?
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
    let updatedAt: String?
    let  mainCatName, subCatName: String?
    let prodsImage, mtype, userName, userPhone: String?
    let userPic: String?
    let userVerified, isAdvertiser: Int?
    let countriesNameAr, countriesNameEn, countriesCurrencyAr, countriesCurrencyEn: String?
    let citiesNameAr, citiesNameEn, regionsNameAr, regionsNameEn: String?
    let comments, fav: Int?
    let isStore, isFeature: Bool?
    let status: String?

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
        case updatedAt = "updated_at"
        case mainCatName = "main_cat_name"
        case subCatName = "sub_cat_name"
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
    }
}
