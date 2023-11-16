//
//  EditSocialMediaVC.swift
//  Bazar
//
//  Created by iOSayed on 01/09/2023.
//

import UIKit

class EditSocialMediaVC: UIViewController {

    
    static func instantiate()-> EditSocialMediaVC{
        let addStoreVC = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier: "EditSocialMediaVC") as! EditSocialMediaVC
        
        return addStoreVC
    }
    
    
    @IBOutlet weak var webSiteTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var insatgramTextField: UITextField!
    @IBOutlet weak var twitterTextField: UITextField!
    
    private var updateStoreParams = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    private func setData(){
        webSiteTextField.text = AppDelegate.currentUser.store?.website ?? ""
        locationTextField.text = AppDelegate.currentUser.store?.googleMap ?? ""
        insatgramTextField.text = AppDelegate.currentUser.store?.instagram ?? ""
        twitterTextField.text = AppDelegate.currentUser.store?.twitter ?? ""
    }
    
    private func updateStore(images:[String:UIImage],params:[String:Any]){
        print(params)
        StoresController.shared.updateStore(completion: { success, message  in
            if success {
                StaticFunctions.createSuccessAlert(msg: message)
            }else {
                StaticFunctions.createErrorAlert(msg: message)
            }
            
        }, link: Constants.EDIT_STORE_URL + "\(AppDelegate.currentUser.store?.id ?? 0)", param: params, images: images)
    }

    @IBAction func didTabCloseButton(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        let websiteText = webSiteTextField.text ?? ""
        let locationText = locationTextField.text ?? ""
        let instagramText = insatgramTextField.text ?? ""
        let twitterText = twitterTextField.text ?? ""
        updateStoreParams = [
            "twitter":twitterText,
            "instagram":instagramText,
            "website":websiteText,
            "google_map":locationText
        ]
        updateStore(images: [:],params:updateStoreParams)
    }
    
}
