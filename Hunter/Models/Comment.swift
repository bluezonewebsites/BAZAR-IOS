//
//  Comment.swift
//  Bazar
//
//  Created by Amal Elgalant on 25/05/2023.
//

import Foundation

struct CommentsReplayPagination: Codable {
    var msg: String!
    var data: CommentsReplayObject!
    var code: Int!
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }

}
struct CommentsReplayObject: Codable {
   
    var comment: Comment?
    
    var question: Ask?
    var replies: [Reply]?
    var countReplies: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case comment, replies
        case question = "question"
        case countReplies = "count_replies"
    }
}
struct CommentArray: Codable{
    var data: [Comment]!
   
    enum CodingKeys: String, CodingKey {
        case data = "data"
       
    }
    
    
}

// MARK: - Comment
struct Comment: Codable {
    var id: Int?
    var questID: Int?
    var userId: Int?
    var productID: Int?
    var comment: String?
    var rating: Int?
    var date: String?
    var updatedAt: String?
    var createdAt: String?
    var commentUserName: String?
    var commentUserLastName: String?
    var commentUserVerified: Int?
    var commentUserPic: String?
    var isLike: Int?
    var countLike: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case questID = "quest_id"

        case userId = "uid"
        case productID = "prod_id"
        case comment = "comment"
        case rating = "rating"
        case date = "date"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case commentUserName = "comment_user_name"
        case commentUserLastName = "comment_user_last_name"
        case commentUserVerified = "comment_user_verified"
        case commentUserPic = "comment_user_pic"
        case isLike = "is_like"
        case countLike = "count_like"
    }
}


// MARK: - Reply
struct Reply: Codable {
    var id, uid, commentID: Int?
    var comment, mention, date, createdAt: String?
    var userName: String?
    var userPic: String?
    var userLastName: String?
    var userVerified, likeCount, isLike: Int?

    enum CodingKeys: String, CodingKey {
        case id, uid
        case commentID = "comment_id"
        case comment, mention, date
        case createdAt = "created_at"
        case userName = "user_name"
        case userPic = "user_pic"
        case userLastName = "user_last_name"
        case userVerified = "user_verified"
        case likeCount = "like_count"
        case isLike = "is_like"
    }
}
