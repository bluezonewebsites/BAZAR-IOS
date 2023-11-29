//
//  PackagesModel.swift
//  Bazar
//
//  Created by iOSayed on 03/09/2023.
//

import Foundation

// MARK: - PlanModel
struct PackagesBaseModel: Codable {
    let message: String?
    let data: PackageModel!
    let success: Bool?
    let statusCode: Int?
}

// MARK: - DataClass
struct PackageModel: Codable {
    let currentPage: Int?
    let data: [PackageObject]!

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
    }
}

// MARK: - Datum
struct PackageObject: Codable {
    let id: Int?
    let nameEn, nameAr, pricePerMonth, durationPerDay: String?
    let adsCount: Int?
    let bestSeller: String?
    let createdAt, updatedAt: String?
    var features: [Feature]?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case pricePerMonth = "price_per_month"
        case durationPerDay = "duration_per_day"
        case adsCount = "ads_count"
        case bestSeller = "best_seller"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case features
    }
}


// MARK: - Feature
struct Feature: Codable {
    let id: Int?
    let titleEn: String?
    let titleAr: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let value: String?
    let planID: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case value
        case planID = "plan_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
