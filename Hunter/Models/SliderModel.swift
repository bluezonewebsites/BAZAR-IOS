//
//  SliderModel.swift
//  Bazar
//
//  Created by iOSayed on 13/09/2023.
//

import Foundation

// MARK: - SliderModel
struct SliderModel: Codable {
    let message: String?
    let data: Slider?
    let success: Bool?
    let statusCode: Int?
}

// MARK: - DataClass
struct Slider: Codable {
    let prods: [SliderObject]?
    let normalSliders:[NormalSlider]?
    enum CodingKeys: String, CodingKey {
        case prods
        case normalSliders = "normal_sliders"
    }
}

// MARK: - NormalSlider
struct NormalSlider: Codable {
    let id: Int?
    let image, title: String?
    let link: String?
    let storeID: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, image, title, link
        case storeID = "store_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Prod
struct SliderObject: Codable {
    let id, catID, subCatID, uid: Int?
    let name: String?
    let price: Int?
    let countryID, cityID, regionID: Int?
    let img:String?
    let prodsImage:String?

    enum CodingKeys: String, CodingKey {
        case id
        case catID = "cat_id"
        case subCatID = "sub_cat_id"
        case uid, name, price
        case countryID = "country_id"
        case cityID = "city_id"
        case regionID = "region_id"
        case img
        case prodsImage = "prods_image"
    }
}


struct UnifiedSliderData {
    let type: SliderType
    let imageUrl: String?
    let link: String?
    let id: Int
}
