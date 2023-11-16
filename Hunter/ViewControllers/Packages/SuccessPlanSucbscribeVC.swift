//
//  SuccessPlanSucbscribeVC.swift
//  Bazar
//
//  Created by iOSayed on 10/09/2023.
//

import UIKit

class SuccessPlanSucbscribeVC: UIViewController {

    static func instantiate() -> SuccessPlanSucbscribeVC{
        let controller = UIStoryboard(name: "Packages", bundle: nil).instantiateViewController(withIdentifier: "SuccessPlanSucbscribeVC") as! SuccessPlanSucbscribeVC
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    // MARK: - IBActions
    
    
    @IBAction func didTapGoToHomeButton(_ sender: UIButton) {
        self.basicPresentation(storyName: MAIN_STORYBOARD, segueId: "TabBarVC")
    }
    
    @IBAction func didTapGoToYourProfile(_ sender: UIButton) {
        let storeProfile = StoreProfileVC.instantiate()
        storeProfile.otherUserId = AppDelegate.currentUser.id ?? 0
        storeProfile.countryId = AppDelegate.currentUser.countryId ?? 0
        navigationController?.pushViewController(storeProfile, animated: true)
    }
    
}
