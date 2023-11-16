//
//  GeneralObject.swift
//  Bazar
//
//  Created by Amal Elgalant on 01/05/2023.
//

import Foundation

struct GeneralObject: Codable{
    var code: Int!
    var msg: String!
    
    enum CodingKeys: String, CodingKey {
        case code = "statusCode"
        case msg = "message"
    }
    
    
}
