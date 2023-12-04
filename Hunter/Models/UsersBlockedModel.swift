//
//  UsersBlockedModel.swift
//  NewBazar
//
//  Created by iOSayed on 23/11/2023.
//

import Foundation

// MARK: - UserBlockedModel
struct UsersBlockedModel: Codable {
    let message: String?
    let data: [UsersBlockedObject]?
    let success: Bool?
    let statusCode: Int?
}

// MARK: - Datum
struct UsersBlockedObject: Codable {
    let id, toUid, fromUid: Int?
    let rdate, createdAt, updatedAt, deletedAt: String?
    let blockUser: BlockUser?

    enum CodingKeys: String, CodingKey {
        case id
        case toUid = "to_uid"
        case fromUid = "from_uid"
        case rdate
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case blockUser = "block_user"
    }
}

// MARK: - BlockUser
struct BlockUser: Codable {
    let id: Int?
    let name, username, pass, loginMethod: String?
    let uid: String?
    let bio: String?
    let mobile, email: String?
    let countryID, cityID, regionID: Int?
    let pic, cover, regid, typeMob: String?
    let verified, blocked, codeVerify, notification: Int?
    let deactivate: Int?
    let note: String?
    let passV: String?
    let activationCode, isAdvertiser: Int?
    let createdAt, updatedAt: String?
    let deletedAt, planID: String?
    let isStore: Bool?
    let availableAdsCountUserInCurrentMonth, availableAdsCountStoreInCurrentMonth: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, username, pass
        case loginMethod = "login_method"
        case uid, bio, mobile, email
        case countryID = "country_id"
        case cityID = "city_id"
        case regionID = "region_id"
        case pic, cover, regid
        case typeMob = "type_mob"
        case verified, blocked
        case codeVerify = "code_verify"
        case notification, deactivate, note
        case passV = "pass_v"
        case activationCode = "activation_code"
        case isAdvertiser = "is_advertiser"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case planID = "plan_id"
        case isStore = "is_store"
        case availableAdsCountUserInCurrentMonth = "available_ads_count_user_in_current_month"
        case availableAdsCountStoreInCurrentMonth = "available_ads_count_store_in_current_month"
    }
}




//MARK: CheckPendingModel


// MARK: - CheckPendingModel
struct CheckPendingModel: Codable {
    let message: String?
    let data: CheckPendingData?
    let success: Bool?
    let statusCode: Int?
}

// MARK: - CheckPendingData
struct CheckPendingData: Codable {
    let pendingUser: Bool?

    enum CodingKeys: String, CodingKey {
        case pendingUser = "pending_user"
    }
}
