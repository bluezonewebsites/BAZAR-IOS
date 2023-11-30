//
//  PackagesController.swift
//  Bazar
//
//  Created by iOSayed on 03/09/2023.
//

import Foundation

class PackagesController {
    
    static let shared = PackagesController()
    
        
        func fetchAllPlans(completion: @escaping([PackageObject], Int, String)->(),countryId:Int){
            
            APIConnection.apiConnection.getConnectionWithParam(completion: { data in
                guard let data = data else { return }
                
                do {
                    let packages = try JSONDecoder().decode(PackagesBaseModel.self, from: data)
                    
                    if packages.statusCode == 200{
                        print(packages)
                        completion(packages.data.data, 0,"")
                    }
                    else {
                        completion([PackageObject](),1,packages.message ?? "")
                    }
                    
                } catch (let jerrorr){
                    
                    print(jerrorr)
                    completion([PackageObject](),1,SERVER_ERROR)
                    
                    
                }
            }, link: Constants.GET_PLANS_URL,param:[:])
        }
    
    func getPlaCategory(completion: @escaping([PackageCategoryObject]?, Int, String)->(), planId: Int){
        
        var param = [
            "plan_id": planId,
        ]

        
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let countryArray = try JSONDecoder().decode(PackagesCategoryModel.self, from: data)
                
                if countryArray.statusCode == 200{
                    
                    completion(countryArray.data ?? [], 0,"")
                }
                else {
                    completion(nil,1,countryArray.message ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(nil,1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.GET_PLANS_CATEGORY_URL , param: param)
    }
    
    
}
