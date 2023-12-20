//
//  sasas.swift
//  Bazar
//
//  Created by iOSayed on 15/06/2023.
//

import Foundation

// MARK: - FollowersSuccessModel
struct FollowersSuccessModel: Codable {
    let message: String?
    let data: [FollowersSuccessData]?
    let success: Bool?
}

// MARK: - Datum
struct FollowersSuccessData: Codable {
    let id, userID, toID: Int?
     let createdAt, updatedAt, userName, userLastName: String?
     let userPic: String?
     let userVerified: Int?
     let countriesNameAr, countriesNameEn, citiesNameAr, citiesNameEn: String?
     let regionsNameAr, regionsNameEn: String?
     var isFollow: Int?
     var isStore:Bool?
    
     enum CodingKeys: String, CodingKey {
         case id
         case userID = "user_id"
         case toID = "to_id"
         case createdAt = "created_at"
         case updatedAt = "updated_at"
         case userName = "user_name"
         case userLastName = "user_last_name"
         case userPic = "user_pic"
         case userVerified = "user_verified"
         case countriesNameAr = "countries_name_ar"
         case countriesNameEn = "countries_name_en"
         case citiesNameAr = "cities_name_ar"
         case citiesNameEn = "cities_name_en"
         case regionsNameAr = "regions_name_ar"
         case regionsNameEn = "regions_name_en"
         case isFollow = "is_follow"
         case isStore = "is_store"
     }
    }



// MARK: - FollowingsSuccessModel
struct FollowingsSuccessModel: Codable {
    let message: String?
    let data: Followings?
    let success: Bool?
}

// MARK: - DataClass
struct Followings: Codable {
    let currentPage: Int?
    let data: [FollowersSuccessData]?
    let lastPage: Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case lastPage = "last_page"
        case total
    }
}
