//
//  ProductController.swift
//  Bazar
//
//  Created by Amal Elgalant on 26/04/2023.
//

import Foundation
class ProductController{
    static let shared = ProductController()
    
    func getHomeProducts(completion: @escaping([Product], Int, String)->(), page: Int,
                         countryId: Int,cityId: Int, categoryId: Int,subCategoryId: Int, type: Int, sorting: String, sell: Int?){
        
        var param = ["page": page,
                     sorting: 1,
                     "country_id": countryId,
                     "status" : "published",
        ] as [String : Any]
        
        if categoryId != -1 && categoryId != 0 {
            param["cat_id"] = categoryId
        }
        
        if sell != nil{
            guard let sell = sell else{return}
            param["tajeer_or_sell"] = sell
        }
        
        if cityId != -1 {
            param["city_id"] = cityId
        }
        
        
        if subCategoryId != -1 {
            param["sub_cat_id"] = subCategoryId
        }
            print(param)
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let productArray = try JSONDecoder().decode(ProductArrayPaging.self, from: data)
                
                if productArray.code == 200{
                    
                    completion(productArray.data.data, 0,"")
                }
                else {
                    completion([Product](),1,productArray.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([Product](),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.HOME_PRODUCTS_URL , param: param)
    }
    
    func getStores(completion: @escaping([StoreObject], Int, String)->(),countryId:Int){
        
        let params = [
            "country_id": countryId
        ]
        APIConnection.apiConnection.getConnectionWithParam(completion: { data in
            guard let data = data else { return }
            
            do {
                let productArray = try JSONDecoder().decode(StoresModel.self, from: data)
                
                if productArray.statusCode == 200{
                    print("count of data ===> \(productArray.data?.count)")
                    completion(productArray.data ?? [], 0,"")
                }
                else {
                    completion([StoreObject](),1,productArray.message ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([StoreObject](),1,SERVER_ERROR)
                
                
            }
        }, link: Constants.HOME_STORES_URL,param:params)
    }
    
    
    func getHomeFeatureProducts(completion: @escaping([Product], Int, String)->(),countryId: Int,categoryId:Int){
        
        let param =
        [
           "country_id": countryId,
           "status" : "published",
           "category_id":categoryId
        ] as [String : Any]
        
        print(param)
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let productArray = try JSONDecoder().decode(ProductArrayPaging.self, from: data)
                
                if productArray.code == 200{
                    print(productArray.data.data.count)
                    completion(productArray.data.data, 0,"")
                }
                else {
                    completion([Product](),1,productArray.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([Product](),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.HOME_FEATURE_PRODUCTS_URL , param: param)
    }
    
    
    func getProducts(completion: @escaping(ProductDetailsObject, Int, String)->(), id: Int){
        
        let param = ["id": id]
        
       
            
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let productObject = try JSONDecoder().decode(ProductObject.self, from: data)
                
                if productObject.code == 200{
                    
                    completion(productObject.data, 0 ,"")
                }
                else {
                    completion(ProductDetailsObject(),1,productObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(ProductDetailsObject(),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.PRODUCT_URL , param: param)
    }
    func replyComment(completion: @escaping( Int, String)->(), id: Int, comment: String){
        
        let param = ["comment_id": id,
                     "comment": comment] as [String : Any]
        
        
       
            
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
            
        }, link: Constants.ADD_REPLY_URL , param: param)
    }
    func addComment(completion: @escaping( Int, String)->(), id: Int, comment: String){
        
        let param = ["prod_id": id,
                     "uid": AppDelegate.currentUser.id,
                        "rating":"4",
                     "comment": comment] as [String : Any]
        
        
       
            
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
            
        }, link: Constants.ADD_COMMENT_URL , param: param)
    }
    func flagComment(completion: @escaping( Int, String)->(), id: Int, comment: String){
        
        let param = ["comment_id": id,
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
            
        }, link: Constants.FLAGE_COMMENT_URL , param: param)
    }
    func likeComment(completion: @escaping( Int, String)->(), id: Int){
        
        let param = ["comment_id": id,
                     "uid": AppDelegate.currentUser.id ?? 0,"like_type":"1"
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
            
        }, link: Constants.LIKE_COMMENT_URL , param: param)
    }
    func likeReply(completion: @escaping( Int, String)->(), id: Int){
        
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
            
        }, link: Constants.LIKE_COMMENT_URL , param: param)
    }
    func likeAd(completion: @escaping( Int, String)->(), id: Int){
        
        let param = ["prod_id": id,
                     
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
            
        }, link: Constants.LIKE_AD_URL , param: param)
    }
    func flageAd(completion: @escaping( Int, String)->(), id: Int, reason: String){
        
        let param = ["prod_id": id,
                     "uid": AppDelegate.currentUser.id ?? 0,
                     "reason": reason
                     
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
            
        }, link: Constants.REPORT_AD_URL , param: param)
    }
    func getCommentsReply(completion: @escaping(CommentsReplayObject, Int, String)->(), id: Int){
        
        let param = ["id": id]
        
       
            
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let commentsReplayPagination = try JSONDecoder().decode(CommentsReplayPagination.self, from: data)
                
                if commentsReplayPagination.code == 200{
                    
                    completion(commentsReplayPagination.data, 0 ,"")
                }
                else {
                    completion(CommentsReplayObject(),1,commentsReplayPagination.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(CommentsReplayObject(),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.COMMENT_REPLY_URL , param: param)
    }
    func flagReply(completion: @escaping( Int, String)->(), id: Int, comment: String){
        
        let param = ["reply_id": id,
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
            
        }, link: Constants.REPORT_REPLY_URL , param: param)
    }
    func deleteReply(completion: @escaping( Int, String)->(), id: Int){
        
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
            
        }, link: Constants.DELETE_REPLY_URL , param: param)
    }
    
    func repostProduct(completion: @escaping(RepostProductObject?, Int, String)->(), id: Int,countryId:Int){
        
        let param = ["id": id ,"country_id":countryId]
        
       
            
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let productObject = try JSONDecoder().decode(RepostProductModel.self, from: data)
                
                if productObject.statusCode == 200{
                    
                    if let data = productObject.data {
                        completion(data, 0 ,"")
                    }
                }
                else {
                    completion(nil,1,productObject.message ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(nil,1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.REPOST_PRODUCT_URL , param: param)
    }
}
