//
//  PendingUserController.swift
//  NewBazar
//
//  Created by iOSayed on 30/11/2023.
//

import Foundation

final class PendingUserController {
    
    
    static let shared = PendingUserController()
        
    func checkUserPending(completion: @escaping(CheckPendingData?, Int, String)->(), userId: Int){
        
        let param = [
            "uid": userId
        ]

        
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let users = try JSONDecoder().decode(CheckPendingModel.self, from: data)
                
                if users.statusCode == 200{
                    
                    completion(users.data, 0,"")
                }
                else {
                    completion(nil,1,users.message ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(nil,1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.CHECK_USERR_PENDING , param: param)
    }
}
