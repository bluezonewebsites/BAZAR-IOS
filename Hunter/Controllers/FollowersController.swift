//
//  FollowersController.swift
//  Bazar
//
//  Created by iOSayed on 16/07/2023.
//

import Foundation

class FollowersController {
    
    static let shared = FollowersController()
   
    
    func getFollowers(completion: @escaping([FollowersSuccessData]?, String)->(),for userId:Int){
        
        let param = [
            "user_id" :userId
        ] as [String : Any]
        
        print(param)
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                
                let Followers = try JSONDecoder().decode(FollowersSuccessModel.self, from: data)
                completion(Followers.data,Followers.message ?? "")
                
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(nil,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.FOLLOWERS_URL , param: param)
    }
    
    
    func getFollowings(completion: @escaping([FollowersSuccessData]?, String)->(),for userId:Int,page:Int){
        
        let param = [
            "user_id" :userId,
            "page":page
        ] as [String : Any]
        
        print(param)
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                
                let Followers = try JSONDecoder().decode(FollowingsSuccessModel.self, from: data)
                completion(Followers.data?.data,Followers.message ?? "")
                
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(nil,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.FOLLOWINGS_URL , param: param)
    }
    
    func goFollow(completion: @escaping(SuccessModel?, String)->(),for userId:Int){
        
        let param = [
            "user_id" :userId
        ] as [String : Any]
        
        print(param)
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                
                let Followers = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(Followers,Followers.message ?? "")
                
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(nil,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.FOLLOWERS_URL , param: param)
    }
}
