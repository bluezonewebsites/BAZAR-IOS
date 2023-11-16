//
//  NotificationsController.swift
//  Bazar
//
//  Created by Amal Elgalant on 24/05/2023.
//

import Foundation

class NotificationsController{
    static let shared = NotificationsController()
    
    
    func saveToken( token: String){
        
        
        var param = [
            "fcm_token": token,
            "type": "IOS",
        ] as [String : Any]
        
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let generalObject = try JSONDecoder().decode(GeneralObject.self, from: data)
                
                if generalObject.code == 200{
                    AppDelegate.defaults.set( token, forKey: "playerId")

//                    completion( 0,generalObject.msg ?? "")
                }
                else {
//                    completion(1,generalObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
//                completion(1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.SAVE_TOKEN_URL , param: param)
    }
    func getNotifications(completion: @escaping([UserNotification], Int, String)->()){
        
      
            
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let userNotificationArray = try JSONDecoder().decode(UserNotificationArray.self, from: data)
                
                if userNotificationArray.code == 200{
                    
                    completion(userNotificationArray.data ?? [], 0 ,"")
                }
                else {
                    completion([UserNotification](),1,userNotificationArray.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([UserNotification](),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.GET_NOTIFICATIONS_URL , param: [:])
    }
    func deleteNotifications(completion: @escaping( Int, String)->()){
        
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let geeneralObject = try JSONDecoder().decode(GeneralObject.self, from: data)
                
                if geeneralObject.code == 200{
                    
                    completion( 0 ,geeneralObject.msg ?? "")
                }
                else {
                    completion(1,geeneralObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.DELETE_NOTIFICATIONS_URL , param: [:])
    }
    
    
    func getNotificationsCount(completion: @escaping(NotificationsCountModel?, Int, String)->()){
        
      
            
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let userNotificationArray = try JSONDecoder().decode(NotificationsCountModel.self, from: data)
                
                if userNotificationArray.statusCode == 200{
                    
                    completion(userNotificationArray , 0 ,"")
                }
                else {
                    completion(nil,1,userNotificationArray.message ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(nil,1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.GET_NOTIFICATIONS_COUNT_URL , param: [:])
    }
}
