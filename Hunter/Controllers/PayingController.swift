//
//  PayingController.swift
//  Bazar
//
//  Created by iOSayed on 09/09/2023.
//

import Foundation

class PayingController {
    
    static let shared = PayingController()
    
    func payingFeaturedAd(completion: @escaping(PayingAdModel?, Int, String)->(),countryId:Int,productId:Int){
            
            let params = [
                "country_id": countryId
            ]
            APIConnection.apiConnection.postConnection(completion: { data in
                guard let data = data else { return }
                
                do {
                    let payingObj = try JSONDecoder().decode(PayingAdModel.self, from: data)
                    
                    if payingObj.statusCode == 200{
                        
                        completion(payingObj, 0,"")
                    }
                    else {
                        completion(nil,1,payingObj.message ?? "")
                    }
                    
                } catch (let jerrorr){
                    
                    print(jerrorr)
                    completion(nil,1,SERVER_ERROR)
                    
                    
                }
            }, link: Constants.PAYING_FEATURED_AD_URL+"\(productId)",param:params)
        }
    
    
    func callBackFeaturedAds(completion: @escaping(CallBackModel?, Int, String)->(),invoiceId:String,invoiceURL:String,prodId:Int,status:String){
            
            let params = [
                "invoice_id": invoiceId,
                "prod_id":prodId,
                "invoice_url":invoiceURL,
                "status":status
            ] as [String : Any]
        print(params)
            APIConnection.apiConnection.postConnection(completion: { data in
                guard let data = data else { return }
                
                do {
                    let payingObj = try JSONDecoder().decode(CallBackModel.self, from: data)
                    
                    if payingObj.statusCode == 200{
                        
                        completion(payingObj, 0,"")
                    }
                    else {
                        completion(nil,1,payingObj.message ?? "")
                    }
                    
                } catch (let jerrorr){
                    
                    print(jerrorr)
                    completion(nil,1,SERVER_ERROR)
                    
                    
                }
            }, link: Constants.PAYING_FEATURED_AD_CALLBACK_URL,param:params)
        }
    
    
    
    func payingPlan(completion: @escaping(PayingAdModel?, Int, String)->(),categoryPlanId:Int,month:Int){
            
            let params = [
                "month":month,
                "category_plan_id": categoryPlanId
            ]
            APIConnection.apiConnection.postConnection(completion: { data in
                guard let data = data else { return }
                
                do {
                    let payingObj = try JSONDecoder().decode(PayingAdModel.self, from: data)
                    
                    if payingObj.statusCode == 200{
                        
                        completion(payingObj, 0,"")
                    }
                    else {
                        completion(nil,1,payingObj.message ?? "")
                    }
                    
                } catch (let jerrorr){
                    
                    print(jerrorr)
                    completion(nil,1,SERVER_ERROR)
                    
                    
                }
            }, link: Constants.PAYING_PLAN_SUBSCRIPE_URL,param:params)
        }
    
    func callBackPlanSubscribe(completion: @escaping(CallBackModel?, Int, String)->(),invoiceId:String,invoiceURL:String,userId:Int,planCategoryId:Int,status:String){
            
            let params = [
                "invoice_id": invoiceId,
                "invoice_url": invoiceURL,
                "user_id":userId,
                "plan_category_id":planCategoryId,
                "status":status
            ] as [String : Any]
        print(params)
            APIConnection.apiConnection.postConnection(completion: { data in
                guard let data = data else { return }
                
                do {
                    let payingObj = try JSONDecoder().decode(CallBackModel.self, from: data)
                    
                    if payingObj.statusCode == 200{
                        
                        completion(payingObj, 0,"")
                    }
                    else {
                        completion(nil,1,payingObj.message ?? "")
                    }
                    
                } catch (let jerrorr){
                    
                    print(jerrorr)
                    completion(nil,1,SERVER_ERROR)
                    
                    
                }
            }, link: Constants.PAYING_PLAN_CALLBACK_URL,param:params)
        }
    
    
    func getSettings(completion: @escaping(SettingObject?, Int, String)->(),countryId:Int){
        
        let params = [
            "country_id": countryId
        ]
        APIConnection.apiConnection.getConnectionWithParam(completion: { data in
            guard let data = data else { return }
            
            do {
                let productArray = try JSONDecoder().decode(SettingsModel.self, from: data)
                
                if productArray.statusCode == 200{
                    //success
                    if let settings = productArray.data {
                        completion(settings, 0,"")
                    }
                     
                }
                else {
                    //fail
                    completion(nil,1,productArray.message ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(nil,1,SERVER_ERROR)
                
                
            }
        }, link: Constants.SETTINGS_URL,param:params)
    }
    
}



