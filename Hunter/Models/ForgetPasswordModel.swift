//
//  ForgetPasswordModel.swift
//  Bazar
//
//  Created by Amal Elgalant on 02/05/2023.
//



import Foundation

struct ForgetPasswordModel: Codable{
    
    var code: Int!
    var msg: String!
    var data: Int!
   
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case code = "statusCode"
        case msg = "message"
    }
    
    
}


