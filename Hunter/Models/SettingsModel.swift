//
//  SettingsModel.swift
//  Bazar
//
//  Created by iOSayed on 02/06/2023.

import Foundation


// MARK: - AboutSuccessModel
// MARK: - AboutSuccessModel
struct AboutSuccessModel: Codable {
    let message: String
    let data: AboutDataObject?
    let success: Bool
    let statusCode: Int
}

// MARK: - DataClass
struct AboutDataObject: Codable {
    let id, typeID: Int
    let descriptionAr, descriptionEn: String

    enum CodingKeys: String, CodingKey {
        case id
        case typeID = "type_id"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
    }
}

struct Success:Codable {
    let message: String
    let success: Bool
}

//MARK: - SuccessModelLike
 struct SuccessModelLike: Codable {
    let message: String?
    let success: Bool?
    let statusCode: Int?
}


