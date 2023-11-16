//
//  BlockUserVC.swift
//  Bazar
//
//  Created by iOSayed on 20/07/2023.
//

import Foundation

class BlockUserVC: UIViewController {
    
    
    
    var otherUserId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTapBlockUser(_ sender: UIButton) {
        
        ProfileController.shared.blockUser(completion: { check, message in
            if check == 0 {
                StaticFunctions.createSuccessAlert(msg: message)
                self.dismiss(animated: false)
            }else{
                StaticFunctions.createErrorAlert(msg: message)
            }
        }, OtherUserId: otherUserId)

    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
}
