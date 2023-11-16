
//  AllRoomsSuccessModel.swift
//  Bazar
//
//  Created by iOSayed on 07/02/2023.
//  Copyright © 2023 roll. All rights reserved.
//

import Foundation

// MARK: - AllRoomsSuccessModel
struct AllRoomsSuccessModel: Codable {
    let message: String?
    let data: [RoomsDataModel]?
    let success: Bool?
}

// MARK: - Datum
struct RoomsDataModel: Codable {
    let id, user1, user2, blocked: Int?
    let userMakeBlock, userDeleteChat, deleted: Int?
    let date: String?
    let unseenCount: Int?
    let user: [AllRoomsUsers]?
    let messages: AllRoomMessages?

    enum CodingKeys: String, CodingKey {
        case id, user1, user2, blocked
        case userMakeBlock = "user_make_block"
        case userDeleteChat = "user_delete_chat"
        case deleted, date
        case unseenCount = "unseen_count"
        case user, messages
    }
}

// MARK: - Messages
struct AllRoomMessages: Codable {
    let id, sid, rid: Int?
    let msg, date: String?
    let seen, roomID: Int?
    let mtype, image, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, sid, rid, msg, date, seen
        case roomID = "room_id"
        case mtype, image
        case createdAt = "created_at"
    }
}

// MARK: - User
struct AllRoomsUsers: Codable {
    let id: Int?
    let name, lastName, username, pass: String?
    let loginMethod, uid, bio, mobile: String?
    let email: String?
    let countryID, cityID, regionID: Int?
    let pic, cover, regid: String?
    let verified, blocked, codeVerify, notification: Int?
    let deactivate: Int?
    let note: String?
    let isStore:Bool?
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
        case createdAt = "created_at"
        case isStore = "is_store"
    }
}



// MARK: - RoomSuccessModel
struct RoomSuccessModel: Codable {
    let message: String?
    let data: createRoomModel?
    let success: Bool?
    let statusCode: Int?
}

// MARK: - DataClass
struct createRoomModel: Codable {
    let id, user1,  blocked: Int?
  //  let user2 :String?
    let userMakeBlock, userDeleteChat, deleted: Int?
    let date: String?
    let unseenCount: Int?
    let user: [RoomUser]?
    let messages: MessagesRoomModel?

    enum CodingKeys: String, CodingKey {
        case id, user1,blocked
        case userMakeBlock = "user_make_block"
        case userDeleteChat = "user_delete_chat"
        case deleted, date
        case unseenCount = "unseen_count"
        case user, messages
    }
}

// MARK: - Messages
struct MessagesRoomModel: Codable {
    let id, sid, rid: Int?
    let msg, date: String?
    let seen, roomID: Int?
    let mtype: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, sid, rid, msg, date, seen
        case roomID = "room_id"
        case mtype
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - User
struct RoomUser: Codable {
    let id: Int?
    let name, lastName, username, pass: String?
    let loginMethod, uid, bio, mobile: String?
    let email: String?
    let countryID, cityID, regionID: Int?
    let pic, cover, regid: String?
    let verified, blocked, codeVerify, notification: Int?
    let deactivate: Int?
    let note, passV: String?
    let activationCode: Int?
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
        case activationCode = "activation_code"
        case createdAt = "created_at"
    }
}
