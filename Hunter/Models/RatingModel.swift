//
//  RatingModel.swift
//  Bazar
//
//  Created by iOSayed on 14/06/2023.
//


import Foundation
import UIKit

struct Rating:Codable{
    var id:String
    var rating:String
    var comment:String
    var date:String
    var user:User
}

// MARK: - RateSuccessModel
struct RateSuccessModel: Codable {
    let message: String?
    var data: RateData?
    let success: Bool?
}

// MARK: - DataClass
struct RateData: Codable {
    let currentPage: Int?
    var data: [RateDataModel]?
    let lastPage: Int?
    let total: Int?
    
     init(currentPage: Int? = nil, data: [RateDataModel]? = nil, lastPage: Int? = nil, total: Int? = nil) {
        self.currentPage = currentPage
        self.data = data
        self.lastPage = lastPage
        self.total = total
    }

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case lastPage = "last_page"
        case total
    }
}

// MARK: - Datum
struct RateDataModel: Codable {
    let id, uid, userRatedID: Int?
    let comment: String?
    let rate: Int
    let date, createdAt: String?
    let ratedUserName, ratedLastName, ratedUserPic, fromUserName: String?
    let fromLastName, fromUserPic: String?

    enum CodingKeys: String, CodingKey {
        case id, uid
        case userRatedID = "user_rated_id"
        case comment, rate, date
        case createdAt = "created_at"
        case ratedUserName = "rated_user_name"
        case ratedLastName = "rated_last_name"
        case ratedUserPic = "rated_user_pic"
        case fromUserName = "from_user_name"
        case fromLastName = "from_last_name"
        case fromUserPic = "from_user_pic"
    }
}
