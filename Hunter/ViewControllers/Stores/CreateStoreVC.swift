//
//  AddStoreVC.swift
//  Bazar
//
//  Created by iOSayed on 28/08/2023.
//

import UIKit
import TransitionButton
import MOLH

enum ValidationResult {
    case success
    case failure(String)
}

class CreateStoreVC: UIViewController {
    
    static func instantiate()-> CreateStoreVC{
        let addStoreVC = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier: "AddStoreVC") as! CreateStoreVC
        
        return addStoreVC
    }
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var activityTextFiled: UITextField!
    @IBOutlet weak var mobileTextFiled: UITextField!
    @IBOutlet weak var whatsAppNumberTextFiled: UITextField!
    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var countryNameButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var aboutCompanyTextField: UITextField!
    @IBOutlet weak var licenseImageView: UIImageView!
    @IBOutlet weak var registerButton: TransitionButton!
    
    @IBOutlet weak var countryFlagImage: UIImageView!
    @IBOutlet weak var contryMobileCode: UILabel!
    
    
    
    // MARK: - Properties
    
    var isStorelogo = false
    var storeLogoImage = UIImage()
    var storeLicenseImage = UIImage()
    var isPasswordHidden = true
    var isAgreeConditions = false
    var coountryVC = CounriesViewController()
    var countryId = AppDelegate.currentCountry.id ?? 6
    var countryName = MOLHLanguage.currentAppleLanguage() == "en" ? AppDelegate.currentCountry.nameEn : AppDelegate.currentCountry.nameAr
    var countryCode =  AppDelegate.currentCountry.code
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        configureView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
    }
    
    // MARK: - Methods
    
    private func configureView(){
        self.title = "Add Store".localize
        self.navigationController?.navigationBar.tintColor = .white
        licenseImageView.isHidden = true
        self.countryNameButton.setTitle(self.countryName, for: .normal)
    }
    
   

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
            validateUIImage(storeLogoImage, errorMessage: "Please Choose Store logo image".localize),
            validateTextField(fullNameTextField, errorMessage: "Please enter your name".localize),
            validateTextField(activityTextFiled, errorMessage: "Please enter your activity".localize),
            validateTextField(mobileTextFiled, errorMessage: "Please enter your mobile number".localize),
            validateTextField(whatsAppNumberTextFiled, errorMessage: "Please enter your WhatsApp number".localize),
            validateTextField(emailTextFiled, errorMessage: "Please enter your email".localize),
            validateTextField(passwordTextField, errorMessage: "Please enter your password".localize),
            validateUIImage(storeLicenseImage, errorMessage: "Please Choose Store license image".localize),
            validateTextField(aboutCompanyTextField, errorMessage:  "Please enter about your company".localize),
            validateEmail()
            
            // More validations...
        ]
        
        return validateFieldsAndShowFirstError(validations: validations)
    }
    
    private  func validateEmail() -> ValidationResult {
        if isValidEmail(emailTextFiled.text!) {
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
    
    
    
    private func createStore(){
        let logoImage = storeLogoImage.jpegData(compressionQuality: 0.3)!
        let licenseImage = storeLicenseImage.jpegData(compressionQuality: 0.3)!
        
        self.registerButton.startAnimation()
        StoresController.shared.createStore(fullname: fullNameTextField.text.safeValue, mobile: (countryCode ?? "965") + mobileTextFiled.text.safeValue , whatsAppNum: whatsAppNumberTextFiled.text.safeValue, email: emailTextFiled.text.safeValue, activity: activityTextFiled.text.safeValue, countryCode: countryId, password: passwordTextField.text.safeValue, bio: aboutCompanyTextField.text.safeValue, logoImage:logoImage , licenseImage: licenseImage) { data in
            
            self.registerButton.stopAnimation()
            guard let data = data else { return }
            
            do {
                let productObject = try JSONDecoder().decode(CreateStoreSuccessfulModel.self, from: data)
                
                if productObject.statusCode == 200{
                    
                    // navigate to success view
                    let successfullVC = CreateStoreSuccessfullyVC.instantiate()
                    successfullVC.modalPresentationStyle = .overFullScreen
                    self.present(successfullVC, animated: false)
                }
                else {
                    // error
                    let error = try JSONDecoder().decode(CreateStoreFailureModel.self, from: data)
                    
                    print(error.errors )
                    
                    let keysToCheck: [KeyPath<StoresErrors, [String]? >] = [
                            \.companyName, \.companyActivity, \.phone, \.email,
                            \.whatsapp, \.countryID, \.password, \.bio,
                            \.logo, \.license
                        ]
                        
                        if let firstErrorMessage = keysToCheck.compactMap({ error.errors[keyPath: $0]?.first }).first {
                            print("First error message:", firstErrorMessage)
                            StaticFunctions.createErrorAlert(msg: firstErrorMessage)
                        }
                  
                    
                }
                
            } catch (let jerrorr){
                
                print(jerrorr)
                
            }
        }
    }
    // MARK: - IBActions
    
    
    @IBAction func didTapChangeLogo(_ sender: UIButton) {
        isStorelogo = true
        openGallery()
//        let vc = EditStoreVC.instantiate()
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapChooseCountryButton(_ sender: UIButton) {
        coountryVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COUNTRY_VCIID) as!  CounriesViewController
        coountryVC.countryBtclosure = {
            (country) in
            self.countryFlagImage.setImageWithLoading(url: country.image ?? "")
            self.contryMobileCode.text = country.code ?? "965"
            self.countryCode = country.code ?? "965"
            self.countryName = MOLHLanguage.currentAppleLanguage() == "en" ? (country.nameEn ?? "") : (country.nameAr ?? "")
            self.countryNameButton.setTitle(self.countryName, for: .normal)
            self.countryId = country.id ?? 6
        }
        self.present(coountryVC, animated: true, completion: nil)
    }
    
    @IBAction func didTapShowPasswordButton(_ sender: UIButton) {
        isPasswordHidden = !isPasswordHidden
        isPasswordHidden
        ? sender.setImage( UIImage(systemName: "eye")?.withRenderingMode(.alwaysTemplate), for: .normal) : sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        
        passwordTextField.isSecureTextEntry = isPasswordHidden
    }
    @IBAction func didTappickupCompanyLicenseButton(_ sender: UIButton) {
        isStorelogo = false
        openGallery()
        
    }
    @IBAction func didTapAgreeConditions(_ sender: UIButton) {
        isAgreeConditions = !isAgreeConditions
        isAgreeConditions ? sender.setImage( UIImage(named: "checkButtonImage")?.withRenderingMode(.alwaysTemplate), for: .normal) : sender.setImage(UIImage(named:"uncheckButtonImage"), for: .normal)
    }
    @IBAction func didTapShowConditions(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapPickupLicenseImage(_ sender: UIButton) {
        isStorelogo = false
        openGallery()
    }
    
    @IBAction func didTapRegisterButton(_ sender: UIButton) {
        if validateAndPrintMessages()  && isAgreeConditions{
            createStore()
        }else if !isAgreeConditions {
            StaticFunctions.createErrorAlert(msg: "You must agree to the terms and conditions".localize)
        }
        
    }
    
    @IBAction func didTaplogin(_ sender: UIButton) {
        
    }
    
    //MARK: Methods
    
    private func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
 
    
  
    
    
    
}
extension CreateStoreVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let capturedImage = info[.originalImage] as? UIImage {
            print("Captured image: \(capturedImage)")
            // self.images.append(capturedImage as UIImage)
            
            if isStorelogo{
                self.storeLogoImage = capturedImage
                self.storeImageView.image = capturedImage
            }else{
                self.licenseImageView.image = capturedImage
                self.storeLicenseImage = capturedImage
                self.licenseImageView.isHidden = false

            }
            
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
