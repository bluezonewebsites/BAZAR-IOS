//
//  BasicViewController.swift
//  Bazar
//
//  Created by iOSayed on 01/09/2023.
//

import UIKit

class BasicViewController: UIViewController {

   static let shared = BasicViewController()
    
     func goToProfile(){
        if StaticFunctions.isLogin() {
            print(AppDelegate.currentUser.isStore)
            DispatchQueue.main.async {
                if AppDelegate.currentUser.isStore ?? false {
                    let storeProfileVC = StoreProfileVC.instantiate()
//                    let nav = UINavigationController(rootViewController: storeProfileVC)
                    self.navigationController?.pushViewController(storeProfileVC, animated: true)
                }else{
                    let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PROFILE_VCID) as! ProfileVC
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else {
            StaticFunctions.createErrorAlert(msg: "Please Login First To Can Go To Profile!".localize)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
            }
           
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
