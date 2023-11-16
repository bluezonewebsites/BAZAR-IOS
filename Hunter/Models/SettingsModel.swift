//
//  SettingsModel.swift
//  Bazar
//
//  Created by iOSayed on 02/06/2023.

import Foundation


// MARK: - AboutSuccessModel
struct AboutSuccessModel: Codable {
    let message: String?
    let data: [About]?
    let success: Bool?
}

// MARK: - About
struct About: Codable {
    let id: Int
    let about, aboutEn ,conds_en, conds:  String
  
    enum CodingKeys: String, CodingKey {
        case id, about ,conds
        case aboutEn = "about_en"
        case conds_en = "conds_en"
    
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
