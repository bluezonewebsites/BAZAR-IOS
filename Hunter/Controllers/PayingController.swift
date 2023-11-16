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
    
    
    func callBackFeaturedAds(completion: @escaping(CallBackModel?, Int, String)->(),invoiceId:String,paymentId:String){
            
            let params = [
                "invoice_id": invoiceId,
                "paymentId":paymentId
            ] as [String : Any]
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
    
    
    
    func payingPlan(completion: @escaping(PayingAdModel?, Int, String)->(),countryId:Int,planId:Int,month:Int){
            
            let params = [
                "plan_id":planId,
                "month":month,
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
            }, link: Constants.PAYING_PLAN_SUBSCRIPE_URL,param:params)
        }
    
    func callBackPlanSubscribe(completion: @escaping(CallBackModel?, Int, String)->(),invoiceId:String,paymentId:String){
            
            let params = [
                "invoice_id": invoiceId,
                "paymentId":paymentId
            ] as [String : Any]
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
    
    
    
}
