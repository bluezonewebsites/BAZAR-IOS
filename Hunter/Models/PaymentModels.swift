//
//  PaymentModels.swift
//  Bazar
//
//  Created by iOSayed on 09/09/2023.
//

import Foundation

// MARK: - PayingAdModel
struct PayingAdModel: Codable {
    let message: String?
    let data: payingObject!
    let success, statusCode: Int?
}

// MARK: - DataClass
struct payingObject: Codable {
    let invoiceURL: String?
    let invoiceID: Int?

    enum CodingKeys: String, CodingKey {
        case invoiceURL
        case invoiceID = "invoiceId"
    }
}


struct CallBackModel:Codable {
    let message: String?
    let data: CallBackObject?
    let success, statusCode: Int?
}

struct CallBackObject:Codable{
    
}
