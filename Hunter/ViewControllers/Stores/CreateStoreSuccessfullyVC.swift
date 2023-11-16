//
//  CreateStoreSuccessfullyVC.swift
//  Bazar
//
//  Created by iOSayed on 30/08/2023.
//

import UIKit

class CreateStoreSuccessfullyVC: UIViewController {
    
    static func instantiate()-> CreateStoreSuccessfullyVC{
        let addStoreVC = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier: "CreateStoreSuccessfullyVC") as! CreateStoreSuccessfullyVC
        
        return addStoreVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    // MARK: - IBActions
     
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: false)
    }
    @IBAction func didTapLogin(_ sender: UIButton) {
        self.basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")

     }
     }
