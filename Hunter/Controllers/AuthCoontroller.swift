//
//  AuthCoontroller.swift
//  Bazar
//
//  Created by Amal Elgalant on 29/04/2023.
//

import Foundation
class AuthCoontroller{
    static let shared = AuthCoontroller()
    
    func login(completion: @escaping(Int, String , UserLoginObject?,Bool)->(), phone: String, passwoord: String){
        
        var param = [
                     "mobile": phone,
                     "password": passwoord
                     ]
        
       
        print(param)
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let userObject = try JSONDecoder().decode(UserLoginObject.self, from: data)
                
                if userObject.code == 200{
                    AppDelegate.unVerifiedUserUser = userObject.data ?? User()
//                    AppDelegate.defaults.set( userObject.token ?? "", forKey: "token")
//                    AppDelegate.defaults.set( userObject.data.id ?? 0, forKey: "userId")
                    AppDelegate.unVerifiedUserUser.toke = userObject.token ?? ""
                    completion( 0,userObject.msg ?? "", userObject,userObject.success)
                }
                else {
                    completion(1,userObject.msg ?? "",nil,userObject.success)
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(1,SERVER_ERROR,nil,false)
                
                
            }
            
        }, link: Constants.LOGIN_URL , param: param)
    }
    func register(completion: @escaping( Int, String)->(), user: User, password:String){
        
       
        var param = [
            "name": user.name ?? "",
            "mobile":user.phone ?? "",
            "password":password ,
            "email":user.email ?? "",
            "username":user.username ?? "",
            "last_name":user.lastName ?? "",
            "country_id": user.countryId ?? -1 ,
            "bio":user.bio ?? "WHAT ABOUT YOU ?",
            
            "regid":"1",

        ] as [String : Any]
        if user.cityId != -1{
            param["city_id"] = user.cityId ?? 0
        }
        if user.regionId != -1{
            param["region_id"] = user.regionId ?? 0
            
        }
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            print(data)
            do {
                let userObject = try JSONDecoder().decode(UserTokenObject.self, from: data)
                
                if userObject.code == 200{
                    AppDelegate.unVerifiedUserUser = userObject.data?.data ?? User()
                   
                    AppDelegate.unVerifiedUserUser.toke = userObject.data?.token ?? ""
                    print(userObject.data?.token ?? "")
                    completion( 0,userObject.msg ?? "")
                }
                else {
                    completion(1,userObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.SIGN_UP_URL , param: param)
    }
    func verifyRegister(completion: @escaping( Int, String)->(), code: String, userId: Int){
        
       
        var param = [
            "user_id": userId,
            "code": code,
          

        ] as [String : Any]
      
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let generalObject = try JSONDecoder().decode(GeneralObject.self, from: data)
                
                if generalObject.code == 200{
                    AppDelegate.currentUser = AppDelegate.unVerifiedUserUser
                    AppDelegate.defaults.set( AppDelegate.currentUser.toke ?? "", forKey: "token")
                    AppDelegate.defaults.set( AppDelegate.currentUser.id ?? 0, forKey: "userId")
                    completion( 0,generalObject.msg ?? "")
                }
                else {
                    completion(1,generalObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.SIGN_UP_VERIFY_URL , param: param)
    }
    func resendCodeRegister(completion: @escaping( Int, String)->(),  userId: Int){
        
       
        var param = [
            "user_id": userId,
          

        ] as [String : Any]
      
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let generalObject = try JSONDecoder().decode(GeneralObject.self, from: data)
                print(generalObject.code)
                if generalObject.code == 200{
                 
                    completion( 0,generalObject.msg ?? "")
                }
                else {
                    completion(1,generalObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.SIGN_UP_RESEND_CODE_URL , param: param)
    }
    func checkUser(completion: @escaping(Int, Int, String)->(), mobile:String){
        
       
        var param = [
            "email": mobile

                     ]
       
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let forgetModel = try JSONDecoder().decode(ForgetPasswordModel.self, from: data)
                
                if forgetModel.code == 200{
                  
                    completion(forgetModel.data ?? 0, 0,forgetModel.msg ?? "")
                }
                else {
                    completion(0,1,forgetModel.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(0,1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.CHECK_USER_URL , param: param)
    }
    func resetPassword(completion: @escaping( Int, String)->(), password: String, userId: Int){
        
       
        var param = [
            "user_id": userId,
            "password": password,
          

        ] as [String : Any]
      
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }
            
            do {
                let generalObject = try JSONDecoder().decode(GeneralObject.self, from: data)
                
                if generalObject.code == 200{
                 
                    completion( 0,generalObject.msg ?? "")
                }
                else {
                    completion(1,generalObject.msg ?? "")
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                completion(1,SERVER_ERROR)
                
                
            }
            
        }, link: Constants.RESET_PASSWORD_URL , param: param)
    }
}
