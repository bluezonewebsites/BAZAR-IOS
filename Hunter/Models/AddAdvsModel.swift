//
//  AddAdvsModel.swift
//  Bazar
//
//  Created by iOSayed on 13/05/2023.
//

import Foundation

// MARK: - PhotosModel
struct AddAdvsModel: Codable {
    let message: String?
    let data: Advs?
    let success: Bool?
    let statusCode: Int?
}

// MARK: - DataClass
struct Advs: Codable {
    let id: Int?
    let uid:Int?
    let catID, subCatID, name: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case catID = "cat_id"
        case subCatID = "sub_cat_id"
        case uid, name
        case createdAt = "created_at"
    }
}


// MARK: - SuccessModel
struct SuccessModel: Codable {
    let message: String?
    let data: ResponseData?
    let success: Bool?
    let statusCode: Int?
}



// MARK: - ResponseData
struct ResponseData: Codable {
    let toUid, fromUid, updatedAt, createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case toUid = "to_uid"
        case fromUid = "from_uid"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
