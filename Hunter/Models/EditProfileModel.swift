//
//  EditProfileModel.swift
//  Bazar
//
//  Created by iOSayed on 17/06/2023.
//

import Foundation
// MARK: - EditProfileModel
struct EditProfileModel: Codable {
    let message: String?
    let data: EditProfileData?
}

// MARK: - DataClass
struct EditProfileData: Codable {
    let id: Int?
    let name, lastName, username, pass: String?
    let loginMethod, uid, bio, mobile: String?
    let email, countryID, cityID, regionID: String?
    let pic, cover, regid: String?
    let verified, blocked, codeVerify, notification: Int?
    let deactivate: Int?
    let note, passV: String?
    let createdAt: String?
    

    enum CodingKeys: String, CodingKey {
        case id, name
        case lastName = "last_name"
        case username, pass
        case loginMethod = "login_method"
        case uid, bio, mobile, email
        case countryID = "country_id"
        case cityID = "city_id"
        case regionID = "region_id"
        case pic, cover, regid, verified, blocked
        case codeVerify = "code_verify"
        case notification, deactivate, note
        case passV = "pass_v"
        case createdAt = "created_at"
    }
}
