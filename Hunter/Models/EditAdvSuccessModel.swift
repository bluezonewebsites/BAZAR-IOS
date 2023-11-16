//
//  EditAdvSuccessModel.swift
//  Bazar
//
//  Created by iOSayed on 22/06/2023.
//

import Foundation

struct EditAdvSuccessModel: Codable {
let message: String?
let data: [EditAdvData]?
let success: Bool?
}

// MARK: - Datum
struct EditAdvData: Codable {
let id, catID: Int?
enum CodingKeys: String, CodingKey {
    case id
    case catID = "cat_id"
  
}
}
