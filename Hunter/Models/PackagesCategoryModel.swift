//
//  PackagesCategoryModel.swift
//  NewBazar
//
//  Created by iOSayed on 30/11/2023.
//

import Foundation

// MARK: - PackagesCategoryModel
struct PackagesCategoryModel: Codable {
    let message: String?
    let data: [PackageCategoryObject]?
    let success: Bool?
    let statusCode: Int?
}

// MARK: - Datum
struct PackageCategoryObject: Codable {
    let id, planID, monthNumber: Int?
    let price: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case planID = "plan_id"
        case monthNumber = "month_number"
        case price
    }
}

