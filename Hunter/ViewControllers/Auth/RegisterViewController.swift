//
//  RegisterViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 16/04/2023.
//

import UIKit
import TransitionButton
import MOLH

class RegisterViewController: UIViewController {
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var loginiBtn: UIButton!
    @IBOutlet weak var usageAggrementBtn: UIButton!
    @IBOutlet weak var registerBtn: TransitionButton!
    @IBOutlet weak var bioTF: UITextView!
    @IBOutlet weak var regonBtn: UIButton!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var couontryBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var familyNameTF: UITextField!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var userNameErrorLbl: UILabel!
    @IBOutlet weak var nameErrorLbl: UILabel!
    @IBOutlet weak var lastNameErrorLbl: UILabel!
    @IBOutlet weak var passwordErrorLbl: UILabel!
    @IBOutlet weak var phoneErrorLbl: UILabel!
    @IBOutlet weak var emailErrorLbl: UILabel!
    @IBOutlet weak var countryErrorLbl: UILabel!
    @IBOutlet weak var regionErrorLbl: UILabel!
    var countryCode = "965"
    var isPasswordHidden = true
    var countryId = 6
    var cityId = -1
    var stateId = -1

   
    @IBOutlet weak var cityErorrLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
        couontryBtn.setTitle(MOLHLanguage.currentAppleLanguage() == "en" ? "Kuwait" : "الكويت", for: .normal)
        
        Constants.COUNTRIES.forEach { country in
            if country.code.safeValue.description.contains("965") {
                if let url = URL(string:Constants.MAIN_DOMAIN + country.image.safeValue) {
                    self.countryImageView.kf.setImage(with: url)
                }
            }
        }
    }
    @IBAction func changeCountryAction(_ sender: Any) {
        var coountryVC = CounriesViewController()

        coountryVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COUNTRY_VCIID) as!  CounriesViewController
        coountryVC.countryBtclosure = {
            (country) in
            self.countryCode = country.code ?? ""
            self.countryCodeLbl.text = country.code
            if let url = URL(string:Constants.MAIN_DOMAIN + country.image.safeValue) {
                print(url)
                self.countryImageView.kf.setImage(with: url)
            }

            self.enableButton()
        }
        self.present(coountryVC, animated: true, completion: nil)
    }
    @objc func textDidChange(_ notification: Notification){
        enableButton()
        
    }
    @IBAction func showPasswordAction(_ sender: UIButton) {
        isPasswordHidden = !isPasswordHidden
        isPasswordHidden
        ? sender.setImage( UIImage(systemName: "eye"), for: .normal) : sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        
        passwordTF.isSecureTextEntry = isPasswordHidden
    }
    @IBAction func registerAction(_ sender: Any) {
        register()
    }
    @IBAction func usageAggremntAction(_ sender: Any) {
    }
    @IBAction func loginAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func chooseCountryNameAction(_ sender: UIButton) {
        var coountryVC = CounriesViewController()

        coountryVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COUNTRY_VCIID) as!  CounriesViewController
        coountryVC.countryBtclosure = {
            (country) in
            var name = MOLHLanguage.currentAppleLanguage() == "en" ? (country.nameEn ?? "") : (country.nameAr ?? "")
            
           sender.setTitle(name, for: .normal)
            self.countryId = country.id ?? -1
            self.cityId = -1
            self.stateId = -1
            self.cityBtn.setTitle("", for: .normal)
            self.regonBtn.setTitle("", for: .normal)

            self.getCities()

            self.enableButton()
        }
        self.present(coountryVC, animated: false, completion: nil)
    }
    @IBAction func chooseCiityNameAction(_ sender: Any) {
        if countryId == -1{
            StaticFunctions.createErrorAlert(msg: "choose country first".localize)
            return
        }
        let vc = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: CITIES_VCIID) as!  CitiesViewController
        vc.countryId = self.countryId
        vc.citiesBtclosure = {
            (city) in
           var name =  MOLHLanguage.currentAppleLanguage() == "en" ? (city.nameEn ?? "") : (city.nameAr ?? "")
            self.cityBtn.setTitle(name, for: .normal)
            self.cityId = city.id ?? -1
            self.stateId = -1
            self.regonBtn.setTitle("", for: .normal)

            self.getAreas()
            self.enableButton()
        }
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func choosRegionNameAction(_ sender: Any) {
        if cityId == -1{
            StaticFunctions.createErrorAlert(msg: "choose city first".localize)
            return
        }
        let vc = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: STATE_VCID) as!  StateViewController
        vc.countryId = self.cityId
        vc.citiesBtclosure = {
            (city) in
           var name =  MOLHLanguage.currentAppleLanguage() == "en" ? (city.nameEn ?? "") : (city.nameAr ?? "")
            self.regonBtn.setTitle(name, for: .normal)
            self.stateId = city.id ?? -1
            self.enableButton()
        }
        self.present(vc, animated: false, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RegisterViewController : UITextFieldDelegate{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        let (valid , message) = ValidTextField(textField: textField)
        
        if textField == userNameTF{
            StaticFunctions.seteErrorLblStatus(errorLbl: userNameErrorLbl, status: valid, msg: message ?? "")
        }
     
        else if textField == nameTF{
            StaticFunctions.seteErrorLblStatus(errorLbl: nameErrorLbl, status: valid, msg: message ?? "")
        }
        else if textField == familyNameTF{
            StaticFunctions.seteErrorLblStatus(errorLbl: lastNameErrorLbl, status: valid, msg: message ?? "")
        }
        else if textField == passwordTF{
            StaticFunctions.seteErrorLblStatus(errorLbl: passwordErrorLbl, status: valid, msg: message ?? "")
        }
        else if textField == phoneTF{
            StaticFunctions.seteErrorLblStatus(errorLbl: phoneErrorLbl, status: valid, msg: message ?? "")
        }
        else if textField == emailTF{
            StaticFunctions.seteErrorLblStatus(errorLbl: emailErrorLbl, status: valid, msg: message ?? "")
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
      if textField == userNameTF{
            nameTF.becomeFirstResponder()
        } else  if textField == nameTF{
            familyNameTF.becomeFirstResponder()
        }
        else  if textField == familyNameTF{
            passwordTF.becomeFirstResponder()
        }else  if textField == passwordTF{
            phoneTF.becomeFirstResponder()
        }else  if textField == phoneTF{
            emailTF.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == phoneTF ){
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        return true
    }
    
}
extension RegisterViewController{
   
    func ValidTextField(textField : UITextField)->(Bool, String?) {
        if textField == phoneTF {
           if (phoneTF.text!.count != 0 ){
                if StaticFunctions.checkValidPhonNumber(Phone: countryCode + phoneTF.text!) {
                   return (true ,nil )
                }
                else {
                    return (false ,NSLocalizedString("enter valid phone number".lowercased(),comment:"") )                               }
           }
            else {
                return (false ,NSLocalizedString("enter valid phone number".lowercased(),comment:"") )                               }
           
       }
        else if textField == emailTF {
            if  !isValidEmail(testStr: emailTF.text!){
                return (false ,NSLocalizedString("enter your email address", comment: "") )
                
            }
            else {
                return (true ,nil )
                
            }
            
        }
        
        else if textField == passwordTF{
            if passwordTF.text!.count < 6{
                return (false ,NSLocalizedString("password should be greater than 6 digits", comment: ""))
                
            }
            else {
                return (true ,nil )
                
            }
        }
        else if textField == nameTF{
            if nameTF.text!.count == 0{
                return (false ,NSLocalizedString("please enter your name", comment: ""))
                
            }
            else {
                return (true ,nil )
                
            }
        }
        else if textField == familyNameTF{
            if familyNameTF.text!.count == 0{
                return (false ,NSLocalizedString("please enter your family name", comment: ""))
                
            }
            else {
                return (true ,nil )
                
            }
        }
        else if textField == userNameTF{
            if userNameTF.text!.count == 0{
                return (false ,NSLocalizedString("please enter your username", comment: ""))
                
            }
            else {
                return (true ,nil )
                
            }
        }
        return (true ,nil )
    }
    func enableButton(){
        var formIsValid = true
        for textField in textFields {
            // Validate Text Field
            let (valid,_) = ValidTextField(textField: textField)
            
            
            guard valid else {
                formIsValid = false
                break
            }
        }
        if countryId == -1{
            formIsValid = false
        }
        
        StaticFunctions.enableBtn(btn: registerBtn, status: formIsValid)
    }
    
    
     func register() {
         AppDelegate.unVerifiedUserUser = User()
         AppDelegate.currentUser = User()

         var user = User()
         user.username = userNameTF.text!
         user.name = nameTF.text!
         user.lastName = familyNameTF.text!
         user.email = emailTF.text!
         user.phone = countryCode + phoneTF.text!
         user.bio = bioTF.text!
         user.countryId = (countryId)
         user.cityId = (cityId)
         user.regionId = (stateId)

         StaticFunctions.enableBtnWithoutAlpha(btn: registerBtn, status: false)
         if Reachability.isConnectedToNetwork(){
             self.registerBtn.startAnimation()

             AuthCoontroller.shared.register(completion: {
                 check, msg in
                 self.registerBtn.stopAnimation(animationStyle: .normal, revertAfterDelay: 0, completion: nil)
                 StaticFunctions.enableBtnWithoutAlpha(btn: self.registerBtn, status: true)
                 if check == 0{
//                     UtilitiesController.shared.SendPlayerId(playerID: AppDelegate.playerID)
                     StaticFunctions.createSuccessAlert(msg: msg)
                     NotificationsController.shared.saveToken( token: AppDelegate.playerId)
                     self.basicNavigation(storyName: Auth_STORYBOARD, segueId: SIGNUP_CODE_VCID)
                 }else{
                     StaticFunctions.createErrorAlert(msg: msg)

                 }

             }, user: user, password: passwordTF.text!)

         }
         else{
             StaticFunctions.enableBtnWithoutAlpha(btn: registerBtn, status: true)

             StaticFunctions.createErrorAlert(msg: NO_INTERNET_CONNECTION)
         }
    }
    
    func getCities(){
        CountryController.shared.getCities(completion: {
            countries, check,msg in
            Constants.CITIES = countries
            if Constants.CITIES.count > 0{
                self.cityId = Constants.CITIES[0].id ?? -1
                self.cityBtn.setTitle(MOLHLanguage.currentAppleLanguage() == "en" ? Constants.CITIES[0].nameEn : Constants.CITIES[0].nameAr, for: .normal)
                self.getAreas()
            }
        }, countryId: countryId)
    }
    func getAreas(){
        CountryController.shared.getStates(completion: {
            countries, check,msg in
            Constants.STATUS = countries
            if Constants.STATUS.count > 0{
                self.stateId = Constants.STATUS[0].id ?? -1
                self.regonBtn.setTitle(MOLHLanguage.currentAppleLanguage() == "en" ? Constants.STATUS[0].nameEn : Constants.STATUS[0].nameAr, for: .normal)
            }
        }, countryId: cityId)
    }
    
}

