//
//  CountryController.swift
//  Bazar
//
//  Created by Amal Elgalant on 28/04/2023.
//

import Foundation
class CountryController{
    static let shared = CountryController()
    
    func getCountries(completion: @escaping([Country], Int, String)->()){
        
//        var param = [
//            "cat_id": "0",
//        ]
//
        
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let countryArray = try JSONDecoder().decode(CountryArray.self, from: data)
                
                if countryArray.code == 200{
                    
                    completion(countryArray.data, 0,"")
                }
                else {
                    completion([Country](),1,countryArray.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([Country](),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.COUNTRIES_URL , param: [:])
    }
    func getCities(completion: @escaping([Country], Int, String)->(), countryId: Int){
        
        var param = [
            "country_id": countryId,
        ]

        
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let countryArray = try JSONDecoder().decode(CountryArray.self, from: data)
                
                if countryArray.code == 200{
                    
                    completion(countryArray.data, 0,"")
                }
                else {
                    completion([Country](),1,countryArray.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([Country](),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.CITIES_URL , param: param)
    }
    func getStates(completion: @escaping([Country], Int, String)->(), countryId: Int){
        
        var param = [
            "city_id": countryId,
        ]

        
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let countryArray = try JSONDecoder().decode(CountryArray.self, from: data)
                
                if countryArray.code == 200{
                    
                    completion(countryArray.data, 0,"")
                }
                else {
                    completion([Country](),1,countryArray.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion([Country](),1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.STATE_URL , param: param)
    }
}
