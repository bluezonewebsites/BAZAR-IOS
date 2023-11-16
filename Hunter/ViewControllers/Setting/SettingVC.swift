//
//  SettingVC.swift
//  Bazar
//
//  Created by iOSayed on 01/06/2023.
//

import Foundation
//
//  SettingVC2.swift
//  Bazar
//
//  Created by ali mahmood saad on 14/10/2022.
//  Copyright © 2022 roll. All rights reserved.
//

import UIKit
import Alamofire

class SettingVC: UIViewController {

    @IBOutlet weak var hdr: UIView!
    @IBOutlet weak var settingView: UIView!

    @IBOutlet weak var deletView: UIView!
    @IBOutlet weak var deletv: UIView!
    @IBOutlet weak var deletev_bottom: NSLayoutConstraint!
    @IBOutlet weak var overlay: UIView!
    
    let appId = "1511596620"
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        makeShadow()
        if AppDelegate.currentUser.toke == nil && !StaticFunctions.isLogin() {
            deletView.isHidden = true
        }else {
            deletView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = .white
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        
    }
    
    fileprivate func makeShadow() {
        settingView.addShadow(offset: CGSize.init(width: 0.5, height: 0.5), color: UIColor.black, radius: 1.0, opacity: 0.15)
        
    }
    
    @IBAction func goAbout(_ sender: UIButton) {
//        goNav("aboutv","Help")
        let vc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
        vc.modalPresentationStyle = .fullScreen
        presentDetail(vc)
    }
    
    @IBAction func goShare(_ sender: Any) {
        
        shareContent(text: "Dawnload Bazar App From AppStore  itms-apps://itunes.apple.com/app/id\(appId)" )
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func goRating(_ sender: Any) {
        dawnloadAppFromStore(appID: appId)
    }
    
    @IBAction func goContactUs(_ sender: Any) {
        let vc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "ContactVC") as! ContactVC
        vc.modalPresentationStyle = .fullScreen
        presentDetail(vc)
    }
    
    
    @IBAction func goTerms(_ sender: UIButton) {
      
        let vc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "CondsVC") as! CondsVC
        vc.modalPresentationStyle = .fullScreen
        presentDetail(vc)
    }
    
    @IBAction func deleteAcoount(_ sender: Any) {
        slide_Delete()

        
    }
    
    func hideDeleteButtom(){
        
        hideV(v: [overlay])
        deletev_bottom.constant = -500
        animate_event()
        
    }
    func slide_Delete(){
        showV(v: [overlay])
        deletev_bottom.constant = 100
        animate_event()
    }
   
    @IBAction func deleteButnAction(_ sender: Any) {
      //  let params : [String: Any]  = ["method":"del_user","id":user.id,]
      //  print(params)
        guard let url = URL(string: Constants.DOMAIN+"delete_user")else{return}
        AF.request(url, method: .post, encoding:URLEncoding.httpBody , headers: Constants.headerProd).responseDecodable(of:SuccessModelLike.self){ res in
            switch res.result {
                
            case .success(let data):
                if let success = data.success , let message = data.message {
                    if success {
                        
                        self.hideDeleteButtom()
                        self.glogout()
                    }else{
                        StaticFunctions.createErrorAlert(msg: message)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }

        hideDeleteButtom()

        
    }
    func glogout(){
        AppDelegate.currentUser.id = nil
        AppDelegate.currentUser.toke = nil
        AppDelegate.currentUser.pic = "-"
        AppDelegate.currentUser.name = "Guest"
        AppDelegate.defaults.string(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.synchronize()
        dismissDetail()
    }
  

    @IBAction func cencelDeleteAction(_ sender: Any) {
        hideDeleteButtom()
    }
}


