//
//  SuccessfulVerifyModel.swift
//  Bazar
//
//  Created by iOSayed on 10/06/2023.
//

import Foundation

// MARK: - SuccessfulVerifyModel
struct SuccessfulVerifyModel: Codable {
    let message: String?
    let data:VerifyModel?
    let success: Bool?
}

// MARK: - DataClass
struct VerifyModel: Codable {
    let uid, mobile, accountType, category: String?
    let documentType, countryID, note, pic: String?
    let createdAt: String?
    let id: Int?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case uid, mobile
        case accountType = "account_type"
        case category
        case documentType = "document_type"
        case countryID = "country_id"
        case note, pic
        case createdAt = "created_at"
        case id, image
    }
}
