//
//  CategoryController.swift
//  Bazar
//
//  Created by Amal Elgalant on 27/04/2023.
//

import Foundation
import UIKit
class CategoryController{
    static let shared = CategoryController()
    
    func getCategoories(completion: @escaping([Category], Int, String)->()){
        
        var param = [
                     "cat_id": "0",
                     ]
        
       
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let categoryArray = try JSONDecoder().decode(CategoryArray.self, from: data)
                
                if categoryArray.code == 200{
                    
                    completion(categoryArray.data, 0,"")
                }
                else {
                    completion([Category](),1,categoryArray.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([Category](),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.GET_CATEGORIES_URL , param: param)
    }
    func getSubCategories(completion: @escaping([Category], Int, String)->(), categoryId: Int){
        
        var param = [
                     "cat_id": categoryId,
                     ]
        
       
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let categoryArray = try JSONDecoder().decode(CategoryArray.self, from: data)
                
                if categoryArray.code == 200{
                    
                    completion(categoryArray.data, 0,"")
                }
                else {
                    completion([Category](),1,categoryArray.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([Category](),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.GET_SUB_CATEGORIES_URL , param: param)
    }
    func getCityAsks(completion: @escaping([Ask], Int, String)->(), id: Int, page: Int){
        
        let param = ["city_id": id,
                     "page": page,
                     ] as [String : Any]
       
            
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let askObject = try JSONDecoder().decode(AskArrayPaging.self, from: data)
                
                if askObject.code == 200{
                    
                    completion(askObject.data.data, 0 ,"")
                }
                else {
                    completion([Ask](),1,askObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([Ask](),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.ASKS_CITY_URL , param: param)
    }
    
    func getUserAsks(completion: @escaping([Ask], Int, String)->(), id: Int, page: Int){
        
        let param = ["uid": id,
                     "page": page,
                     ] as [String : Any]
       
            print(param)
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let askObject = try JSONDecoder().decode(AskArrayPaging.self, from: data)
                
                if askObject.code == 200{
                    
                    completion(askObject.data.data, 0 ,"")
                }
                else {
                    completion([Ask](),1,askObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([Ask](),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.ASKS_USER_URL , param: param)
    }
    
    func addComment(completion: @escaping( Int, String)->(), id: Int, comment: String, image: UIImage?){
        
        let param = ["country_id": "\(AppDelegate.currentUser.countryId ?? 0)",
                     "uid": "\(AppDelegate.currentUser.id ?? 0)",
                        "city_id":"\(id)",
                     "quest": comment] as [String : Any]
        
       
            
        APIConnection.apiConnection.uploadConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let generalObject = try JSONDecoder().decode(GeneralObject.self, from: data)
                
                if generalObject.code == 200{
                    
                    completion( 0 ,generalObject.msg ?? "")
                }
                else {
                    completion(1,generalObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.ASK_ADD_URL , param: param, image: image, fileName: "image")
    }
    
    func deleteAsk(completion: @escaping( Int, String)->(), id: Int){
        
        let param = ["id": id,
                    ] as [String : Any]
        
        
       
            
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let generalObject = try JSONDecoder().decode(GeneralObject.self, from: data)
                
                if generalObject.code == 200{
                    
                    completion( 0 ,generalObject.msg ?? "")
                }
                else {
                    completion(1,generalObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.ASK_DELETE_URL , param: param)
    }
    func getAsksReply(completion: @escaping(AsksReplayObject, Int, String)->(), id: Int){
        
        let param = ["id": id,  "uid": AppDelegate.currentUser.id ?? 0]
        
       
            
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let commentsReplayPagination = try JSONDecoder().decode(AsksReplay.self, from: data)
                
                if commentsReplayPagination.code == 200{
                    
                    completion(commentsReplayPagination.data, 0 ,"")
                }
                else {
                    completion(AsksReplayObject(),1,commentsReplayPagination.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(AsksReplayObject(),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.GET_ASK_REPLY_URL , param: param)
    }
    func deleteAskReply(completion: @escaping( Int, String)->(), id: Int){
        
        let param = ["id": id,
                    ] as [String : Any]
        
        
       
            
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let generalObject = try JSONDecoder().decode(GeneralObject.self, from: data)
                
                if generalObject.code == 200{
                    
                    completion( 0 ,generalObject.msg ?? "")
                }
                else {
                    completion(1,generalObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.DELETE_ASK_REPLY_URL , param: param)
    }
    func flagReply(completion: @escaping( Int, String)->(), id: Int, comment: String){
        
        let param = ["q_id": id,
                     "reason": comment] as [String : Any]
        
        
       
            
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let generalObject = try JSONDecoder().decode(GeneralObject.self, from: data)
                
                if generalObject.code == 200{
                    
                    completion( 0 ,generalObject.msg ?? "")
                }
                else {
                    completion(1,generalObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.ASK_REPLY_REPORT_URL , param: param)
    }
    func likeAskReply(completion: @escaping( Int, String)->(), id: Int){
        
        let param = ["comment_id": id,
                     "uid": AppDelegate.currentUser.id ?? 0,"like_type":"0"
        ] as [String : Any]
        
        

       
            
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let generalObject = try JSONDecoder().decode(GeneralObject.self, from: data)
                
                if generalObject.code == 200{
                    
                    completion( 0 ,generalObject.msg ?? "")
                }
                else {
                    completion(1,generalObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.ASK_LIKE_REPLY_URL , param: param)
    }
    func replyAsk(completion: @escaping( Int, String)->(), id: Int, comment: String){
        
        let param = ["quest_id": id,
                     "comment": comment,
                     "uid":AppDelegate.currentUser.id ?? 0] as [String : Any]
        
        
       
            
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let generalObject = try JSONDecoder().decode(GeneralObject.self, from: data)
                
                if generalObject.code == 200{
                    
                    completion( 0 ,generalObject.msg ?? "")
                }
                else {
                    completion(1,generalObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.ASK_REPLY_URL , param: param)
    }
}
