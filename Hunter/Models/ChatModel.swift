//
//  ChatModel.swift
//  Bazar
//
//  Created by iOSayed on 29/05/2023.
//

import Foundation

// MARK: - Result
struct Result: Codable {
    let id, sid, rid: Int?
    let msg, date: String?
    let seen, roomID: Int?
    let mtype, image, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, sid, rid, msg, date, seen
        case roomID = "room_id"
        case mtype, image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


struct Attachment:Codable{
    var id:String
    var title:String
    var pic:String
}


//
struct ChatMessage: Codable {
    let message: String?
    let data: ChatMessageData?
    let success: Bool?
}

// MARK: - DataClass
struct ChatMessageData: Codable {
    let room: Room?
    let receiver: Receiver?
    let result: [Result]?
}

// MARK: - Receiver
struct Receiver: Codable {
    let name, lastName, passV, bio: String?
    let cover, mobile, pic, email: String?
    let id, countryID, cityID, regionID: Int?
    let verified: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case lastName = "last_name"
        case passV = "pass_v"
        case bio, cover, mobile, pic, email, id
        case countryID = "country_id"
        case cityID = "city_id"
        case regionID = "region_id"
        case verified
    }
}

//// MARK: - Result
//struct Result1: Codable {
//    let id, sid, rid: Int?
//    let msg, date: String?
//    let seen, roomID: Int?
//    let mtype, image, createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, sid, rid, msg, date, seen
//        case roomID = "room_id"
//        case mtype, image
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}


// MARK: - Room
struct Room: Codable {
    let id, user1, user2, blocked: Int?
    let userMakeBlock, userDeleteChat, deleted: Int?
    let date: String?
    let unseenCount: Int?
    let user: [ChatMessageUser]?
    let messages: Result?

    enum CodingKeys: String, CodingKey {
        case id, user1, user2, blocked
        case userMakeBlock = "user_make_block"
        case userDeleteChat = "user_delete_chat"
        case deleted, date
        case unseenCount = "unseen_count"
        case user, messages
    }
}

// MARK: - User
struct ChatMessageUser: Codable {
    let id: Int?
    let name, lastName, username, pass: String?
    let loginMethod, uid, bio, mobile: String?
    let email: String?
    let countryID, cityID, regionID: Int?
    let pic, cover, regid: String?
    let verified, blocked, codeVerify, notification: Int?
    let deactivate: Int?
    let note: String?
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
    }
}


// MARK: - MessageSuccessfulModel
struct MessageSuccessfulModel: Codable {
    let message: String?
    let data: [MessageDataModel]?
    let success: Bool?
}

// MARK: - DataClass
struct MessageDataModel: Codable {
    let roomID,rid: Int?
    let sid: Int?
    let msg, mtype, image: String?
    let createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case rid, sid
        case roomID = "room_id"
        case msg, mtype, image
        case createdAt = "created_at"
        case id
    }
}
