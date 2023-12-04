//
//  UsersBlockedController.swift
//  NewBazar
//
//  Created by iOSayed on 23/11/2023.
//

import Foundation

class UsersBlockedController {
    
    static let shared = UsersBlockedController()
    
    
    func getUsersBlocked(completion: @escaping([UsersBlockedObject], Int, String)->(), userId: Int){
        
        let param = [
            "user_id": userId
        ]

        
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let users = try JSONDecoder().decode(UsersBlockedModel.self, from: data)
                
                if users.statusCode == 200{
                    
                    completion(users.data ?? [], 0,"")
                }
                else {
                    completion([UsersBlockedObject](),1,users.message ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([UsersBlockedObject](),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.GET_BLOCKED_USERS , param: param)
    }
    

    
   
}
