//
//  ChatController.swift
//  Bazar
//
//  Created by Amal Elgalant on 31/05/2023.
//

import Foundation



class ChatController{
    static let shared = ChatController()
    
    func create_room(completion: @escaping( Int ,Int, String)->(), id: Int){
        
        let param = ["rid": id]

        
       
            
        APIConnection.apiConnection.postConnection(completion: {
            data  in
            guard let data = data else { return }

            do {
                let generalObject = try JSONDecoder().decode(RoomSuccessModel.self, from: data)
//
                if generalObject.statusCode == 200{

                    completion( generalObject.data?.id ?? -1  ,0 ,generalObject.message ?? "")
                }
                else {
                    completion(-1, 1,generalObject.message ?? "")
                }
            } catch (let jerrorr){

                print(jerrorr)
                completion(-1,1,SERVER_ERROR)


            }
            
        }, link: Constants.CREATE_CHAT_ROOM , param: param)
    }
    
    

  
  
}
