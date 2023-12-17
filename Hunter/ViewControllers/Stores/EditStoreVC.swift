//
//  EditStoreVC.swift
//  Bazar
//
//  Created by iOSayed on 31/08/2023.
//

import UIKit
import MOLH
import PhoneNumberKit
import Alamofire

class EditStoreVC: UIViewController {

    static func instantiate()-> EditStoreVC{
        let editStoreVC = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier: "EditStoreVC") as! EditStoreVC
        
        return editStoreVC 
    }
    
    
    
    // MARK: - IBOutlets
    
    
    @IBOutlet weak var profileImageContainerView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var changeCoverButton: UIButton!
    @IBOutlet weak var changeProfileImageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleNameOfStoreTextField: UITextField!
    @IBOutlet weak var companyNameTextFiled: UITextField!
    @IBOutlet weak var activityTextFiled: UITextField!
    @IBOutlet weak var mobileTextFiled: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var aboutCompanyTextFiled: UITextField!
    @IBOutlet weak var regionButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var whatsAppTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    // MARK: - Proprerties
    var cityId = 0
    var countryId = 0
    var cityName = ""
    var stateId = 0
    var regionName = ""
    let phoneNumberKit = PhoneNumberKit()
    private var EditProfileParams = [String:Any]()
    private var imageType = 0 //profileImage
    private var isUpdateCover = false
    private var updateStoreParams = [String:Any]()
    private var storeImages = [String:UIImage]()
    private var storeLogoImage = UIImage()
    private var storeLicenseImage = UIImage()
    
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        getProfile()
        configureView()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
    }
    
    // MARK: - Methods

    
    private func configureView(){
        
        EditProfileParams =
        [
            "id":AppDelegate.currentUser.id ?? 0,
            "mobile":AppDelegate.currentUser.phone.safeValue,
            "country_id":AppDelegate.currentUser.countryId ?? 6
        ]
        
        profileImageContainerView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapChooseCityButton(_ sender: UIButton) {
        let vc = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: CITIES_VCIID) as!  CitiesViewController
        vc.countryId = self.countryId
        vc.citiesBtclosure = {
            (city) in
            let name =  MOLHLanguage.currentAppleLanguage() == "en" ? (city.nameEn ?? "") : (city.nameAr ?? "")
            self.cityId = city.id ?? 0
            self.cityButton.setTitle(name, for: .normal)
            self.cityName = name
            self.getAreas()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func didTapChooseRegionButton(_ sender: UIButton) {
        let vc = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: STATE_VCID) as!  StateViewController
        vc.countryId = self.cityId
        vc.citiesBtclosure = {
            (city) in
           var name =  MOLHLanguage.currentAppleLanguage() == "en" ? (city.nameEn ?? "") : (city.nameAr ?? "")
            self.regionButton.setTitle(name, for: .normal)
            self.regionName = name
            self.stateId = city.id ?? -1
        }
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func didTapChangeMobileButton(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: Auth_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "ChangePhoneVC") as! ChangePhoneVC
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapChangePasswordButton(_ sender: UIButton) {
        let vc = UIStoryboard(name: Auth_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapEditSocialMediaButton(_ sender: UIButton) {
        
        let editSocialMediaVC = EditSocialMediaVC.instantiate()
        
        editSocialMediaVC.modalPresentationStyle = .overFullScreen
        present(editSocialMediaVC, animated: false)
    }
    
    @IBAction func didTapChooseCoverButton(_ sender: UIButton) {
        isUpdateCover = true
        imageType = 1 //Cover image
        displayImageActionSheet()
        
    }
    @IBAction func didTapChooseStoreLogoButton(_ sender: UIButton) {
        isUpdateCover = false
        imageType = 0 // profile image
        displayImageActionSheet()
    }
    
    
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        updateStoreParams = [
            "company_name":companyNameTextFiled.text.safeValue,
            "company_activity":activityTextFiled.text.safeValue,
//            "phone":mobileTextFiled.text.safeValue,
            "whatsapp":whatsAppTextField.text.safeValue,
            "city_id":cityId,
            "region_id":stateId,
            "email":emailTextField.text.safeValue,
        ]
        
        if validateAndPrintMessages(){
            updateStore(images: storeImages,params:updateStoreParams)
        }
        
    }
    
}

extension EditStoreVC {
    
    
    
    private func getProfile(){
        ProfileController.shared.getOtherProfile(completion: {[weak self] profile, msg in
            guard let self = self else {return}
            if let profile = profile {
                print("======= profile Data ======== ")
                print(profile)
                self.setData(from: profile)
            }
        }, userId: AppDelegate.currentUser.id ?? 0)
    }
    
    private func setData(from data: User){
                titleNameOfStoreTextField.text = data.store?.companyName.safeValue
        companyNameTextFiled.text = data.store?.companyName.safeValue
                passwordTextFiled.text = "******"
                emailTextField.text = data.email
                do {
                    let phoneNumberCustomDefaultRegion = try phoneNumberKit.parse("\(data.phone.safeValue)", ignoreType: false)

                    mobileTextFiled.text = String(phoneNumberCustomDefaultRegion.nationalNumber)
                    countryCodeLabel.text = String(phoneNumberCustomDefaultRegion.countryCode)                }
                catch {
                    let mobile = data.phone?.dropFirst(3)
//                    order.phoneCode = String(user.mobile.prefix(3))
                    mobileTextFiled.text = data.phone.safeValue
                    print("Generic parser error")
                }


        profileImageView.setImageWithLoading(url: data.store?.logo ?? "")
        coverImageView.setImageWithLoading(url: data.cover.safeValue,placeholder:"coverBG")
        aboutCompanyTextFiled.text = data.store?.bio.safeValue
        activityTextFiled.text = data.store?.companyActivity.safeValue
        whatsAppTextField.text = data.store?.whatsapp.safeValue
        
        cityId = data.cityId ?? 0
        countryId = data.countryId ?? 6
        cityName = MOLHLanguage.currentAppleLanguage() == "en" ? (data.citiesNameEn ?? "") : (data.citiesNameAr ?? "")
        stateId = data.regionId ?? 0
        regionName = MOLHLanguage.currentAppleLanguage() == "en" ? (data.regionsNameEn ?? "") : (data.regionsNameAr ?? "")
        self.cityButton.setTitle(cityName, for: .normal)
        self.regionButton.setTitle(regionName, for: .normal)
        
        
    }
    
    
    // update Store
    
    
    private func updateStore(images:[String:UIImage],params:[String:Any]){
        print(params)
        StoresController.shared.updateStore(completion: {success, message in
            if success {
                
                StaticFunctions.createSuccessAlert(msg: message)
            }else {
                StaticFunctions.createErrorAlert(msg: message)
            }
            
        }, link: Constants.EDIT_STORE_URL + "\(AppDelegate.currentUser.store?.id ?? 0)", param: params, images: images)
    }
    
//    private func setData(data:UpdateStoreModel) {
//        AppDelegate.currentUser.name = data.message?.companyName.safeValue
//        AppDelegate.currentUser.store?.companyName = data.message?.companyName.safeValue
//        AppDelegate.currentUser.
////        AppDelegate.currentUser.cityId = data.message.cit
//    }
    
    private func changeProfileImage(image:UIImage){
        APIConnection.apiConnection.uploadImageConnectionForStore(completion: { success, message in
            if success {
                StaticFunctions.createSuccessAlert(msg: message)
            }else {
                StaticFunctions.createErrorAlert(msg: message)
            }
            
        }, link: Constants.EDIT_STORE_URL + "\(AppDelegate.currentUser.store?.id ?? 0)", param: [:], image: image, imageType: .profileImage)
    }
    
    private func displayImageActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let selectAction = UIAlertAction(title: "Change".localize, style: .default) { (_) in
                    self.openGallery()
                }
        let deletAction = UIAlertAction(title: "Delete".localize, style: .destructive) { (_) in
            self.confirmRemoveCover()
            print("Delete Image")
        }
        // Customize the color of the actions
        selectAction.setValue(#colorLiteral(red: 0, green: 0.576, blue: 0.961, alpha: 1), forKey: "titleTextColor")
        alertController.addAction(selectAction)
        if isUpdateCover {
            alertController.addAction(deletAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localize, style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
        let imageView = UIImageView(image: UIImage(named: "imageadd")?.withRenderingMode(.alwaysTemplate))
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                imageView.tintColor = UIColor(named: "#0093F5")
                let imageWidth: CGFloat = 20
                let imageHeight: CGFloat = 20
                let padding: CGFloat = 16.0
                let customView = UIView(frame: CGRect(x: padding, y: padding, width: imageWidth, height: imageHeight))
                imageView.frame = customView.bounds
                customView.addSubview(imageView)
                alertController.view.addSubview(customView)
                alertController.view.bounds.size.height += (imageHeight + padding * 2)
                present(alertController, animated: true, completion: nil)
       }
    
    private func changeCoverImage(image:UIImage){
        APIConnection.apiConnection.uploadImageConnection(completion: { success, message in
            if success {
                StaticFunctions.createSuccessAlert(msg: message)
            }else {
                StaticFunctions.createErrorAlert(msg: message)
            }
            
        }, link: Constants.EDIT_USER_URL, param: EditProfileParams, image: image, imageType: .coverImage)
    }

    
    
    
    
    private func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    private func changeProfileStore(image:UIImage){
        APIConnection.apiConnection.uploadImageConnectionForStore(completion: { success, message in
            if success {
                StaticFunctions.createSuccessAlert(msg: message)
            }else {
                StaticFunctions.createErrorAlert(msg: message)
            }
            
        }, link: Constants.EDIT_STORE_URL + "\(AppDelegate.currentUser.store?.id ?? 0)", param: updateStoreParams, image: image, imageType: .profileImage)
    }
    
    func getAreas(){
        CountryController.shared.getStates(completion: {
            countries, check,msg in
            Constants.STATUS = countries
            if Constants.STATUS.count > 0{
                self.stateId = Constants.STATUS[0].id ?? -1
                self.regionButton.setTitle(MOLHLanguage.currentAppleLanguage() == "en" ? Constants.STATUS[0].nameEn : Constants.STATUS[0].nameAr, for: .normal)
            }
        }, countryId: cityId)
    }
    
    
    
    
    func confirmRemoveCover() {
        DispatchQueue.main.async( execute: {
            //            let attributedtitle = NSAttributedString(string: "", attributes:: [
////                NSAttributedString.Key.font : UIFont(name: "Almarai-Regular", size: 13.0)!
//            ])
            
            //            let attributedmessage = NSAttributedString(string:"", attributes:: [
////                NSAttributedString.Key.font : UIFont(name: "Almarai-Regular", size: 13.0)!
//            ])
            var typeImage =  "Cover"
            if self.isUpdateCover {
                typeImage =  "Cover"
            }else{
                typeImage =  "Profile Image"
            }
            
            let alert = UIAlertController(title: "Wirrning ⚠️ ".localize, message: "Do you want to delete \(typeImage) ?".localize,  preferredStyle: .alert)
            
            
            
         //   alert.setValue(attributedtitle, forKey: "attributedTitle")
           // alert.setValue(attributedmessage, forKey: "attributedMessage")
            
            let action2 = UIAlertAction(title: "Confirm".localize, style: .default, handler:{(alert: UIAlertAction!) in
                //Confirm
                if self.isUpdateCover {
                    self.deleteCover()
                }else {
                    if let image = UIImage(named: "logo_photo") {
                        self.updateStore(images: self.storeImages, params: self.updateStoreParams)
//                        self.getProfile()
                    }
                }
            })
            
            
            alert.addAction(action2)
            
            
            let action3 = UIAlertAction(title: "Cancel".localize, style: .default, handler: {(alert: UIAlertAction!) in})
            alert.addAction(action3)
            self.present(alert,animated: true,completion: nil)
        })
    }
    private func deleteCover(){
        guard let url = URL(string: Constants.DOMAIN+"delete_profile_cover") else {return}
        AF.request(url, method: .post, headers: Constants.headerProd)
            .responseDecodable(of:SuccessModel.self){ (e) in
                print(e.value)
                switch e.result {
                case .success(let data):
                    print(data)
//                    self.getProfile()
                    self.coverImageView.image = UIImage(named: "coverBG")
                case.failure(let error):
                    print(error)
                }
                
            }
    }
}

extension EditStoreVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let capturedImage = info[.originalImage] as? UIImage {
            print("Captured image: \(capturedImage)")
           // self.images.append(capturedImage as UIImage)
            
            
            if imageType == 0 {
                //profile image
                profileImageView.image = capturedImage
                storeLogoImage = capturedImage
                storeImages = ["logo":capturedImage]
            }else{
                // cover image
                coverImageView.image = capturedImage
                storeLicenseImage = capturedImage
                changeCoverImage(image: capturedImage)
            }
           
        }
    }
        
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}

extension EditStoreVC {
    //validate inputs
    
    func validateFieldsAndShowFirstError(validations: [ValidationResult]) -> Bool {
        for validation in validations {
            switch validation {
            case .failure(let message):
                StaticFunctions.createErrorAlert(msg: message)
                return false
            case .success:
                continue
            }
        }
        return true
    }

    func validateTextField(_ textField: UITextField, errorMessage: String) -> ValidationResult {
        if let text = textField.text, !text.isEmpty {
            return .success
        } else {
            return .failure(errorMessage)
        }
    }
    
    func validateUIImage(_ image: UIImage, errorMessage: String) -> ValidationResult {
        if  image.size.width == 0 || image.size.height == 0  {
            return .failure(errorMessage)
        } else {
            return .success
        }
    }
    
    
    private func validateAndPrintMessages() -> Bool {
        let validations: [ValidationResult] = [
//            validateUIImage(storeLogoImage, errorMessage: "Please Choose Store logo image".localize),
            validateTextField(companyNameTextFiled, errorMessage: "Please enter company name".localize),
            validateTextField(activityTextFiled, errorMessage: "Please enter your activity".localize),
            validateTextField(mobileTextFiled, errorMessage: "Please enter your mobile number".localize),
            validateTextField(whatsAppTextField, errorMessage: "Please enter your WhatsApp number".localize),
            validateTextField(emailTextField, errorMessage: "Please enter your email".localize),
            validateTextField(passwordTextFiled, errorMessage: "Please enter your password".localize),
//            validateUIImage(storeLicenseImage, errorMessage: "Please Choose Store license image".localize),
            validateTextField(aboutCompanyTextFiled, errorMessage:  "Please enter about your company".localize),
            validateEmail()
            
            // More validations...
        ]
        
        return validateFieldsAndShowFirstError(validations: validations)
    }
    
    private  func validateEmail() -> ValidationResult {
        if isValidEmail(emailTextField.text!) {
                return .success
            } else {
                
                return .failure("Please enter a valid email".localize)
            }
        
    }
    private  func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
}
