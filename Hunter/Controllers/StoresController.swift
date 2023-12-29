//
//  StoresController.swift
//  Bazar
//
//  Created by iOSayed on 28/08/2023.
//

import Foundation
import UIKit
import Alamofire
import MOLH


class StoresController {
    static let shared = StoresController()
    
    func getStores(completion: @escaping([StoreObject], Int, String)->(),countryId:Int){
        
        let params = [
            "country_id": countryId
        ]
        APIConnection.apiConnection.getConnectionWithParam(completion: { data in
            guard let data = data else { return }
            
            do {
                let productArray = try JSONDecoder().decode(StoresModel.self, from: data)
                
                if productArray.statusCode == 200{
                    //success
                    completion(productArray.data ?? [StoreObject](), 0,"")
                }
                else {
                    //fail
                    completion([StoreObject](),1,productArray.message ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([StoreObject](),1,SERVER_ERROR)
                
                
            }
        }, link: Constants.HOME_STORES_URL,param:params)
    }
    
    func createStore(fullname: String, mobile: String, whatsAppNum: String, email: String, activity: String, countryCode: Int, password: String, bio: String, logoImage: Data, licenseImage: Data, completion: @escaping (Data?) -> Void) {

        // API Endpoint
        let url = Constants.HOME_STORES_URL
        
        let param = [
            "company_name":fullname,
            "company_activity":activity,
            "phone":mobile,
            "email":email,
            "whatsapp":whatsAppNum,
            "country_id":countryCode,
            "password":password,
            "bio":bio
        ] as [String : Any]
        // Header
        var headers: HTTPHeaders =
        [
            "OS": "ios",
            "Accept":"application/json",
            "Content-Lang": MOLHLanguage.currentAppleLanguage()
            //         "App-Version": version as! String,
            //         "Os-Version": UIDevice.current.systemVersion
        ]
        print(AppDelegate.currentUser.toke)
        if AppDelegate.currentUser.toke != "" && AppDelegate.currentUser.toke != nil{
            headers["Authorization"] = "Bearer \(AppDelegate.currentUser.toke ?? "")"
        }
        
        // Alamofire Request
        print(param)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(logoImage, withName: "logo", fileName: "logo.png", mimeType: "image/png")
            
            
            
            multipartFormData.append(licenseImage, withName: "license", fileName: "license.png", mimeType: "image/png")
            
            for (key,value) in param {
                multipartFormData.append((value as AnyObject).description.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url, headers: headers)
        .responseJSON { response in
            print(response.result)
            print("=============================================")
            if let JSON = response.data {
                completion(JSON)
            }
            
            else {
                completion(nil)
            }
        }
    }
    
    
    
    func updateStore(completion: @escaping(Bool,String)-> (), link : String, param: Parameters , images:[String:UIImage]){
        print(link)
        
        var header: HTTPHeaders =
        [
            "OS": "ios",
            "Accept":"application/json",
            "Content-Lang": MOLHLanguage.currentAppleLanguage()
            //         "App-Version": version as! String,
            //         "Os-Version": UIDevice.current.systemVersion
        ]
        if AppDelegate.currentUser.toke != "" && AppDelegate.currentUser.toke != nil{
            header["Authorization"] = "Bearer \(AppDelegate.currentUser.toke ?? "")"
        }
        
        AF.upload(multipartFormData: { multipart in
            if images.count > 0 {
                for (key,value) in images {
                    let imageData = value.jpegData(compressionQuality: 0.1)!
                    multipart.append(imageData, withName: key ,fileName: "file.jpg", mimeType: "image/jpg")
                }
            }
            
            print(param)
            for (key,value) in param {
                multipart.append((value as AnyObject).description.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: link,headers: header).responseDecodable(of:UpdateStoreModel.self){ response in

            switch response.result {
            case .success(let data):
                print(data.message ?? "")
                completion(true, "Updated".localize)
            case .failure(let error):
                print(error)
                completion(false,SERVER_ERROR)
            }
        }
    }
    
    //MARK: Search
    func getSearchStores(completion: @escaping([StoreObject], Int, String)->(),countryId:Int,serach:String){
        
        let params = [
            "country_id": countryId,
            "search":serach
        ] as [String : Any]
        print(params)
        APIConnection.apiConnection.getConnectionWithParam(completion: { data in
            guard let data = data else { return }
            
            do {
                let productArray = try JSONDecoder().decode(StoresModel.self, from: data)
                
                if productArray.statusCode == 200{
                    
                    completion(productArray.data ?? [StoreObject](), 0,"")
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
    
    func getSliders(completion: @escaping(Slider?, Int, String)->(),countryId:Int){
        
        let params = [
            "country_id": countryId
        ]
        APIConnection.apiConnection.getConnectionWithParam(completion: { data in
            guard let data = data else { return }
            
            do {
                let productArray = try JSONDecoder().decode(SliderModel.self, from: data)
                
                if productArray.statusCode == 200{
                    
                    completion(productArray.data , 0,"")
                }
                else {
                    completion(nil,1,productArray.message ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(nil,1,SERVER_ERROR)
                
                
            }
        }, link: Constants.GET_SLIDERS_URL,param:params)
    }
}
