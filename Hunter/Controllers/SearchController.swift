//
//  SearchController.swift
//  Bazar
//
//  Created by Amal Elgalant on 23/05/2023.
//

import Foundation
class SearchController{
    static let shared = SearchController()
    
    func searchAds(completion: @escaping([Product], Int, String)->(), id: Int, searchText: String, page: Int,countryId:Int){
        
        let param = ["uid": id,
                     "page": page,
                     "keyword": searchText,
                     "country_id": countryId ] as [String : Any]
       
            
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let productObject = try JSONDecoder().decode(ProductArrayPaging.self, from: data)
                
                if productObject.code == 200{
                    
                    completion(productObject.data.data, 0 ,"")
                }
                else {
                    completion([Product](),1,productObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([Product](),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.SEARCH_ADS_URL , param: param)
    }
    func searchPerson(completion: @escaping([User], Int, String)->(), id: Int, searchText: String, page: Int,countryId:Int){
        
        let param = ["uid": id,
                     "page": page,
                     "keyword": searchText,
                     "country_id": countryId] as [String : Any]
       
            
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let userObject = try JSONDecoder().decode(UserArrayPaging.self, from: data)
                
                if userObject.code == 200{
                    
                    completion(userObject.data.data, 0 ,"")
                }
                else {
                    completion([User](),1,userObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([User](),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.SEARCH_PERSONS_URL , param: param)
    }
    func searchِAsk(completion: @escaping([Ask], Int, String)->(), id: Int, searchText: String, page: Int){
        
        let param = ["uid": id,
                     "page": page,
                     "keyword": searchText,
                     "country_id": AppDelegate.currentUser.id ?? "6" ] as [String : Any]
       
            
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
            
        }, link: Constants.SEARCH_QUESTIONS_URL , param: param)
    }
}
