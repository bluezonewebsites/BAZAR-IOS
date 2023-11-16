//
//  Ask.swift
//  Bazar
//
//  Created by Amal Elgalant on 23/05/2023.
//

import Foundation
struct AskArrayPaging: Codable{
    var data: AskArray!
    var code: Int!
    var msg: String!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
    
    
}

struct AsksReplay: Codable {
    var msg: String!
    var data: AsksReplayObject!
    var code: Int!
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }

}
struct AsksReplayObject: Codable {
   
    var comment: CommentArray?
    
    var question: Ask?
   
    
    
    enum CodingKeys: String, CodingKey {
        case comment
        case question = "question"
    }
}


struct AskArray: Codable{
    var data: [Ask]!
    var code: Int!
    var msg: String!
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
    
    
}
struct Ask: Codable {
    var id: Int?
    var userId: Int?
    var quest: String?
    var cdate: String?
    var countryID: Int?
    var cityID: Int?
    var pic: String?
    var createdAt: String?
    var name: String?
    var userPic: String?
    var lastName: String?
    var userVerified: Int?
    var comments: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, quest, cdate
        case userId = "uid"
        case countryID = "country_id"
        case cityID = "city_id"
        case pic
        case createdAt = "created_at"
        case name
        case userPic = "user_pic"
        case lastName = "last_name"
        case userVerified = "user_verified"
        case comments
    }
}
