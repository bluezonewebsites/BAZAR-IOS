//
//  AddAdvsController.swift
//  Bazar
//
//  Created by iOSayed on 13/05/2023.
//

import Foundation
import Alamofire

class AddAdvsController{
    
    static let shared = AddAdvsController()
    
    func addAdvs(params:[String:Any] ,selectedMedia:[String:Data] , completion:@escaping(Bool,String)-> Void){
        
        var parameters = params
       
        
        
        as [String : Any]
        var type = ""
        var index = ""
        var image = Data()
    
        //main_image
        
        print(selectedMedia)
        AF.upload(multipartFormData: { [self] multipartFormData in
            for (key,value) in selectedMedia {
                if key.contains("IMAGE"){
                    if key.contains("0"){
                        type = key.components(separatedBy: " ")[0]
                        index = key.components(separatedBy: " ")[1]
                        image = value
                       // params["mtype[]"] = type
                        multipartFormData.append(image, withName: "main_image",fileName: "file\(index).jpg", mimeType: "image/jpg")
                    }else{
                        type = key.components(separatedBy: " ")[0]
                        index = key.components(separatedBy: " ")[1]
                        image = value
                        parameters["mtype[]"] = type
                        multipartFormData.append(image, withName: "sub_image[]",fileName: "file\(index).jpg", mimeType: "image/jpg")
                    }
                }else{
                    type = key.components(separatedBy: " ")[0]
                    index = key.components(separatedBy: " ")[1]
                    image = value
                    parameters["mtype[]"] = type
                    multipartFormData.append(image, withName: "sub_image[]",fileName: "video\(index).mp4", mimeType: "video/mp4")
                }
               
                 print("send Image Parameters : -----> ", parameters)
            for (key,value) in parameters {
                multipartFormData.append((value as AnyObject).description.data(using: String.Encoding.utf8)!, withName: key)
            }
        }
        
//        //main_image
//        AF.upload(multipartFormData: {  multipartFormData in
//
//
//            for (index,image) in images.enumerated() {
//
//                if index == 0 {
//                    if let imageData = image.jpegData(compressionQuality: 0.01) {
//                        multipartFormData.append(imageData, withName: "main_image", fileName: "main_image.jpg", mimeType: "image/jpg")
//                    }
//                }else{
//                    if let imageData = image.jpegData(compressionQuality: 0.01) {
//                        parameters["mtype[]"] = "IMAGE"
//                        multipartFormData.append(imageData, withName: "sub_image[]", fileName: "file\(index).jpg", mimeType: "image/jpg")
//                    }
//                }
//
//                // Upload the sub-images
//                //                for (index, image) in images.enumerated() {
//                //                    if index != 0 { // Skip the first image (already uploaded as main image)
//                //                        if let imageData = image.jpegData(compressionQuality: 0.01) {
//                //                            parameters["mtype[]"] = "IMAGE"
//                //                            multipartFormData.append(imageData, withName: "sub_image[]", fileName: "file\(index).jpg", mimeType: "image/jpg")
//                //                        }
//                //                    }
//                //                }
//
//                //                // Upload the videos
//                //                for (index, video) in videos.enumerated() {
//                //                    parameters["mtype[]"] = "VIDEO"
//                //                    multipartFormData.append(video, withName: "sub_image[]", fileName: "sub_video\(index).mp4", mimeType: "video/mp4")
//                //                }
//            }
//
//            for (index,video) in videos.enumerated() {
//                parameters["mtype[]"] = "VIDEO"
//                multipartFormData.append(video, withName: "sub_image[]", fileName: "file\(index).jpg", mimeType: "video/jpg")
//            }
//
//
//                print(params)
//                for (key,value) in params {
//                    multipartFormData.append((value as AnyObject).description.data(using: String.Encoding.utf8)!, withName: key)
//                }
                
            
          
            
        },to:Constants.ADDADVS_URL)
        .responseDecodable(of:AddAdvsModel.self){ response in
            
            switch response.result {
            case .success(let data):
                print("success")
                print(data)
                if data.statusCode == 200{
                    completion(true,data.message ?? "")
                }else{
                    completion(false , data.message ?? "")
                }
            case .failure(let error):
                if let decodingError = error.underlyingError as? DecodingError {
                           // Handle decoding errors
                           completion(false, "Decoding error: \(decodingError)")
                       } else {
                           // Handle other network or server errors
                           completion(false, SERVER_ERROR)
                       }
                   }
            
        }
        
    }
}
