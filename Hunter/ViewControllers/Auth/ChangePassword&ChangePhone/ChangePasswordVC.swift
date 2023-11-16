//
//  ChangePasswordVC.swift
//  Bazar
//
//  Created by iOSayed on 25/06/2023.
//

import Foundation

import UIKit
import Alamofire
import TransitionButton

class ChangePasswordVC : ViewController {
    
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var old: UITextField!
    @IBOutlet weak var new: UITextField!
    @IBOutlet weak var cnew: UITextField!
    
    @IBOutlet weak var confirmButton: TransitionButton!
    
    var isOldPasswordHidden = false
    var isNewPasswordHidden = false
    var isConfirmPasswordHidden = false
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func go(_ sender: Any) {
        confirmButton.startAnimation()
        if(checkEmpty(cont: [old,new,cnew])) {
            if new.text == cnew.text{
                let params : [String: Any]  = [
                    "old_password":old.text!,"password":new.text!]
                guard let url = URL(string: Constants.DOMAIN+"change_password")else {return}
                print(Constants.headerProd)
                AF.request(url, method: .post, parameters: params, encoding:URLEncoding.httpBody , headers: Constants.headerProd).responseDecodable(of:SuccessModel.self){ res in
                    print(res.value)
                    self.confirmButton.stopAnimation()
                    switch res.result {
                    case .success(let data):
                        if let success = data.success, let message = data.message {
                            if success {
                                StaticFunctions.createSuccessAlert(msg: message)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    self.navigationController?.popViewController(animated:true)
                                }
                            }else{
                                StaticFunctions.createErrorAlert(msg: message)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }

            }else{
                StaticFunctions.createErrorAlert(msg:"Make sure your new password matches.".localize)
                
            }
            
        }else{
            StaticFunctions.createErrorAlert(msg:"Please Fill All Fields".localize)
        }
    }
    
    
    @IBAction func showAndHideOldPassword(_ sender: UIButton) {
        isOldPasswordHidden = !isOldPasswordHidden
        isOldPasswordHidden
        ? sender.setImage( UIImage(systemName: "eye"), for: .normal) : sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            //eye.slash
        
        old.isSecureTextEntry = isOldPasswordHidden
        
    }
    
    @IBAction func showAndHideNewPassword(_ sender: UIButton) {
        
        isNewPasswordHidden = !isNewPasswordHidden
        isNewPasswordHidden
        ? sender.setImage( UIImage(systemName: "eye"), for: .normal) : sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            //eye.slash
        
        new.isSecureTextEntry = isNewPasswordHidden
    }
    
    @IBAction func showAndHideConfirmPassword(_ sender: UIButton) {
        isConfirmPasswordHidden = !isConfirmPasswordHidden
        isConfirmPasswordHidden
        ? sender.setImage( UIImage(systemName: "eye"), for: .normal) : sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            //eye.slash
        
        cnew.isSecureTextEntry = isConfirmPasswordHidden
    }
    
  
}


