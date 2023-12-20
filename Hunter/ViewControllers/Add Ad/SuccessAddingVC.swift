//
//  SuccessAddingVC.swift
//  Bazar
//
//  Created by iOSayed on 01/05/2023.
//

import UIKit

protocol SuccessAddingVCDelegate: AnyObject {
    func didTapMyAdsButton()
    func didTapUploadNewAds()
}

class SuccessAddingVC: UIViewController {
    var isFromHome = true
    weak var delegate: SuccessAddingVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set up a timer to wait for 5 seconds
               Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(navigateToNewScreen), userInfo: nil, repeats: false)
        self.navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isHidden = false

        
    }
    
    @objc func navigateToNewScreen() {
        self.basicPresentation(storyName: MAIN_STORYBOARD, segueId: "TabBarVC")
     }
    
    
    //MARK:  IBActions
    
    @IBAction func didTapuploadNewAds(_ sender: UIButton) {
        //TODO:   handle this case going to AddAdsVC on tapBar
//        dismiss(animated: false)
        dismiss(animated: false) { [weak self] in
            guard let self else {return}
            self.delegate?.didTapUploadNewAds()
        }
       
    }
    @IBAction func didTapGoToMyAds(_ sender: UIButton) {
        delegate?.didTapMyAdsButton()
        
       
    }
}
