//
//  SettingsModel.swift
//  Bazar
//
//  Created by iOSayed on 02/06/2023.

import Foundation


// MARK: - AboutSuccessModel
// MARK: - AboutSuccessModel
struct AboutSuccessModel: Codable {
    let message: String
    let data: AboutDataObject?
    let success: Bool
    let statusCode: Int
}

// MARK: - DataClass
struct AboutDataObject: Codable {
    let id, typeID: Int
    let descriptionAr, descriptionEn: String

    enum CodingKeys: String, CodingKey {
        case id
        case typeID = "type_id"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
    }
}

struct Success:Codable {
    let message: String
    let success: Bool
}

//MARK: - SuccessModelLike
 struct SuccessModelLike: Codable {
    let message: String?
    let success: Bool?
    let statusCode: Int?
}



// MARK: - SettingsModel
struct SettingsModel: Codable {
    let message: String?
    let data: SettingObject?
    let success: Bool?
    let statusCode: Int?
}

// MARK: - DataClass
struct SettingObject: Codable {
    var id, countryID, countNormalAdsPerMonth: Int?
    var countStoreAdsPerMonth, storeDurationFeaturedAds, userDurationFeaturedAds, storeDurationNormalAds: Int?
    var userPriceFeaturedAds ,storePriceFeaturedAds,storePriceNormalAds,userPriceNormalAds: Double?
    var userDurationNormalAds: Int?

    
    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case countNormalAdsPerMonth = "count_normal_ads_per_month"
        case storePriceFeaturedAds = "store_price_featured_ads"
        case userPriceFeaturedAds = "user_price_featured_ads"
        case storePriceNormalAds = "store_price_normal_ads"
        case userPriceNormalAds = "user_price_normal_ads"
        case countStoreAdsPerMonth = "count_store_ads_per_month"
        case storeDurationFeaturedAds = "store_duration_featured_ads"
        case userDurationFeaturedAds = "user_duration_featured_ads"
        case storeDurationNormalAds = "store_duration_normal_ads"
        case userDurationNormalAds = "user_duration_normal_ads"
    }
    
    init() {}
    

}

//enum IntOrString: Codable {
//    case int(Int)
//    case string(String)
//    case none
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if container.decodeNil() {
//            self = .none
//            return
//        }
//        if let intValue = try? container.decode(Int.self) {
//            self = .int(intValue)
//            return
//        }
//        if let stringValue = try? container.decode(String.self) {
//            self = .string(stringValue)
//            return
//        }
//        throw DecodingError.typeMismatch(IntOrString.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value is not a String, an Int, or nil"))
//    }
//}

