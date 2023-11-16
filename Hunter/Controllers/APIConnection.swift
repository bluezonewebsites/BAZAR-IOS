//
//  APIConnection.swift
//  Bazar
//
//  Created by Amal Elgalant on 26/04/2023.
//


import Foundation
import Alamofire
import MOLH

class APIConnection{
    
    enum ImageType {
        case profileImage
        case coverImage
    }
    
    static var apiConnection = APIConnection()
    
    func getConnection (completion: @escaping(Data?)-> (), link : String){
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
        AF.request(link, method: .get, headers: header ).responseJSON { response in
            print("=============================================")
            print(link)
            print(header)
            
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
    //JSONEncoding.default
    func postConnection (completion: @escaping(Data?)-> (), link : String, param: Parameters ){
        var header: HTTPHeaders =
        [
            "OS": "ios",
            "Accept":"application/json",
            "Content-Lang": MOLHLanguage.currentAppleLanguage()
            //         "App-Version": version as! String,
            //         "Os-Version": UIDevice.current.systemVersion
        ]
        print(AppDelegate.currentUser.toke)
        if AppDelegate.currentUser.toke != "" && AppDelegate.currentUser.toke != nil{
            header["Authorization"] = "Bearer \(AppDelegate.currentUser.toke ?? "")"
        }
        print(param)
        AF.request(link, method: .post, parameters: param, headers: header).responseJSON { response in
            print("=============================================")
            print(link)
            print(param)
            print(header)
            
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
    func uploadConnection (completion: @escaping(Data?)-> (), link : String, param: Parameters, image: UIImage? , fileName
                           : String){
        var header: HTTPHeaders =
        [
            "OS": "ios",
            "Accept":"application/json",
            "Content-Lang": MOLHLanguage.currentAppleLanguage()
            //         "App-Version": version as! String,
            //         "Os-Version": UIDevice.current.systemVersion
        ]
        print(AppDelegate.currentUser.toke)
        if AppDelegate.currentUser.toke != "" && AppDelegate.currentUser.toke != nil{
            header["Authorization"] = "Bearer \(AppDelegate.currentUser.toke ?? "")"
        }
        print(param)
        AF.upload(
            multipartFormData: { multipartFormData in
                if image != nil {
                    let imageData = image?.jpegData(compressionQuality: 0.1)!
                    multipartFormData.append(imageData!, withName: fileName,fileName: "file.jpg", mimeType: "image/jpg")
                    
                }
                for (key, value) in param {
                    
                    if let data = (value as AnyObject).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                
                print("multipartFormData" , multipartFormData.contentType)
            },
            
            to: link,
            method: .post, headers: header)
        .responseJSON { response in
            print("=============================================")
            print("URL: " ,link)
            print(param)
            print(header)
            
            print("response.result" , response.result)
            print("=============================================")
            if let JSON = response.data {
                completion(JSON)
            }
            
            else {
                completion(nil)
            }
        }
    
}

    func getConnectionWithParam (completion: @escaping(Data?)-> (), link : String,param:Parameters){
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
        AF.request(link, method: .get,parameters: param, headers: header ).responseJSON { response in
            print("=============================================")
            print(link)
            print(header)
            
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
    
func uploadImageConnection(completion: @escaping(Bool,String)-> (), link : String, param: Parameters , image:UIImage , imageType:ImageType){
    
    let imageData = image.jpegData(compressionQuality: 0.1)!
    AF.upload(multipartFormData: { multipart in
        
        switch imageType {
        case.profileImage:
                multipart.append(imageData, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
        case.coverImage:
                multipart.append(imageData, withName: "cover",fileName: "file.jpg", mimeType: "image/jpg")
        }
        
        
        for (key,value) in param {
            multipart.append((value as AnyObject).description.data(using: String.Encoding.utf8)!, withName: key)
        }
    }, to: link)
    .responseDecodable(of:SuccessModel.self){ response in
        
        switch response.result {
        case .success(let data):
            print(data.message ?? "")
            completion(true, data.message ?? "")
        case .failure(let error):
            print(error)
            completion(false,SERVER_ERROR)
        }
    }
}
    func uploadImageConnectionForStore(completion: @escaping(Bool,String)-> (), link : String, param: Parameters , image:UIImage , imageType:ImageType){
        
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
        let imageData = image.jpegData(compressionQuality: 0.1)!
        AF.upload(multipartFormData: { multipart in
            
            switch imageType {
            case.profileImage:
                    multipart.append(imageData, withName: "logo",fileName: "file.jpg", mimeType: "image/jpg")
            case.coverImage:
                multipart.append(imageData, withName: "cover",fileName: "file.jpg", mimeType: "image/jpg")
            }
            
            
            for (key,value) in param {
                multipart.append((value as AnyObject).description.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: link,headers: header)
        .responseDecodable(of:UpdateStoreModel.self){ response in
            
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

    
    

    func uploadImagesAndVideos(images: [UIImage], videos: [URL], completionHandler: @escaping (Swift.Result<String, Error>) -> Void) {
    let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
    
    AF.upload(multipartFormData: { multipartFormData in
        // Upload images
        for (index, image) in images.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let fileName = "\(UUID().uuidString).jpg"
                multipartFormData.append(imageData, withName: "sub_image[]", fileName: fileName, mimeType: "image/jpeg")
            }
        }
        
        // Upload videos
        for video in videos {
            do {
                let videoData = try Data(contentsOf: video)
                let fileName = "\(UUID().uuidString).mp4"
                multipartFormData.append(videoData, withName: "sub_image[]", fileName: fileName, mimeType: "video/mp4")
            } catch {
                completionHandler(.failure(error))
                return
            }
        }
        
    }, to: Constants.ADDADVS_URL, headers: headers)
    
}

}
