//
//  AddRateForUsersVC.swift
//  Bazar
//
//  Created by iOSayed on 05/07/2023.
//

import UIKit
import Cosmos
import Alamofire

protocol AddRateForUsersVCDelegate:AnyObject{
    func reloadData()
}

class AddRateForUsersVC: UIViewController {

    
    @IBOutlet weak var txt_comment: UITextView!
    @IBOutlet weak var ratingStars: CosmosView!
   
    
    weak var delegate : AddRateForUsersVCDelegate?
    var otherUserId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTapSendComment(_ sender: UIButton) {
        let params : [String: Any]  = ["uid":otherUserId,"user_rated_id":AppDelegate.currentUser.id ?? 0,"comment":txt_comment.text!,"rate":ratingStars.rating]
         let url =  Constants.DOMAIN + "rate_user"
            print(params)
        APIConnection.apiConnection.postConnection(completion: { data in
           guard let data = data else{return}
            
            do {
                let jsonData = try JSONDecoder().decode(SuccessModel.self, from: data)
                
                if jsonData.statusCode == 200{
                    NotificationCenter.default.post(Notification(name: .loadUserRate))
                    StaticFunctions.createSuccessAlert(msg: jsonData.message ?? "")
                    NotificationCenter.default.post(name: NSNotification.Name("getRate"), object: nil)
                    self.dismiss(animated: false)
                }
                else {
                    StaticFunctions.createErrorAlert(msg: jsonData.message ?? "")

                }
                
            } catch (let jerrorr){
                print(jerrorr)
            }
        }, link: url, param: params)
    }
    @IBAction func didTapCancelComment(_ sender: UIButton) {
        
        dismiss(animated: false)
    }
    

}
