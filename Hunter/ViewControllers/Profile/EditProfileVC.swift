//
//  EditProfileVC.swift
//  Bazar
//
//  Created by iOSayed on 17/06/2023.
//

import UIKit
import Alamofire
import DropDown
import PhoneNumberKit
import MOLH

extension UITextView {
    func setLineSpacing(){
        guard let labelText = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .right
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}


class EditProfileVC : UIViewController {
    
    var cityId:String = ""
    var cityName:String = ""
    var citiesName = [String]()
    var citiesId = [String]()
    
    var regionId:String = ""
    var regionName:String = ""
    var regionsName = [String]()
    var regionsId = [String]()
    
    var userImageData = Data()
    private var EditProfileParams = [String:Any]()
    
    @IBOutlet weak var citiesDrop: UIButton!
    @IBOutlet weak var regionsDrop: UIButton!
    @IBOutlet weak var upic: UIImageView!
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_lastName: UITextField!
    @IBOutlet weak var txt_pass: UITextField!

    @IBOutlet weak var userNameEN: UITextField!
    
    @IBOutlet weak var phoneCode: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    
    let phoneNumberKit = PhoneNumberKit()
    
    let citiesDropDwon = DropDown()
    let regionsDropDwon = DropDown()
    
    lazy var dropDownn: [DropDown] = {
        return [
            self.countriesDropDown,
            self.citiesDropDwon,
            self.regionsDropDwon

        ]
    }()
    
    var countPhoneNumber: Int {
        if AppDelegate.currentUser.countryId == 5 || AppDelegate.currentUser.countryId  == 10 {
                return 9
            }else{
                return  8
            }
    }
    let countryImageList = ["6":"flag_kw.png",
                            "5":"flag_sa.png",
                            "10":"flag_ae.png",
                            "15":"flag_bh.png",
                            "18":"flag_om.png",
                            "78":"flag_qa.png"]
    let countryList = ["6":"965","5":"966","10":"971","15":"973","18":"968","78":"974"]
    
//MARK: VC Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
//        countryImage.image = UIImage(named: Ap.country_Image)
//        phoneNumber.delegate = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
    }
    
    
    fileprivate func setupUI(){

        getCitiesList()
        getRegionsList()
        
        EditProfileParams =
        [
            "id":AppDelegate.currentUser.id ?? 0,
            "mobile":AppDelegate.currentUser.phone ?? "",
            "country_id":AppDelegate.currentUser.countryId ?? 6
        ]
        userNameEN.text = AppDelegate.currentUser.username
        regionId = "\(AppDelegate.currentUser.regionId ?? 0)"
        cityId = "\(AppDelegate.currentUser.cityId ?? 0)"
        txt_name.text = AppDelegate.currentUser.name
        txt_lastName.text = AppDelegate.currentUser.name
        txt_pass.text = "******"
        emailTxt.text = AppDelegate.currentUser.email
        
                do {
                   
                    let phoneNumberCustomDefaultRegion = try phoneNumberKit.parse("\(AppDelegate.currentUser.phone ?? "")", ignoreType: false)
                    
                    phoneNumber.text = String(phoneNumberCustomDefaultRegion.nationalNumber)
                    phoneCode.text = String(phoneNumberCustomDefaultRegion.countryCode)                }
                catch {
                    let mobile = AppDelegate.currentUser.phone?.dropFirst(3)
//                    order.phoneCode = String(user.mobile.prefix(3))
                    phoneNumber.text = AppDelegate.currentUser.phone ?? ""
                    print("Generic parser error")
                }
        
        
        upic.setImageWithLoading(url: AppDelegate.currentUser.pic ?? "",placeholder: "logo_photo")
        bio.text = AppDelegate.currentUser.bio ?? ""
//        bio.setLineSpacing()
        
        
        getCountries2()
        dropDownn.forEach { $0.dismissMode = .onTap }
        dropDownn.forEach { $0.direction = .any }
        setupDropDowns2()
    }
    
    @IBAction func changePasswordActiion(_ sender: Any) {
        
        let vc = UIStoryboard(name: Auth_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changePhoneAction(_ sender: Any) {
        
        let vc = UIStoryboard(name: Auth_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "ChangePhoneVC") as! ChangePhoneVC
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    var countryId:String = ""
    var countryName:String = ""
    var countriesName = [String]()
    var countriesId = [String]()
    
    func getCountries2(){
        countriesName.removeAll()
        countriesId.removeAll()
//        BG.load(self)
       // let params : [String: Any]  = ["method":"countries"]
        guard let url = URL(string: Constants.DOMAIN+"countries")else {return}
        AF.request(url, method: .post)
            .responseJSON { [weak self](e) in
                guard let self = self else {return}
//                BG.hide(self)
                if let result = e.value {
                    if let dataDic = result as? NSDictionary {
                        if let arr = dataDic["data"] as? NSArray {
                            for itm in arr {
                                if let d = itm as? NSDictionary {
                                    if let name = d.value(forKey: "name_ar") as? String {
                                        self.countriesName.append(name)
                                    }
                                    if let name = d.value(forKey: "id") as? Int {
                                        self.countriesId.append("\(name)")
                                    }
                                }
                            }
                        }
                    }
                    self.setupCountriesDropDown2()
                }
                
        }
    }
    @IBOutlet weak var countriesButton: UIButton!
    
    let countriesDropDown = DropDown()
    
    func setupCountriesDropDown2() {
        countriesDropDown.anchorView = countriesButton
        countriesDropDown.bottomOffset = CGPoint(x: 0, y: countriesButton.bounds.height)
        countriesDropDown.dataSource = countriesName
        
        if countriesName.count > 0 && countriesId.count > 0{
            if let countryID = countriesId.firstIndex(of: countryId) {
                countriesButton.setTitle(countriesName[countryID], for: .normal)
            }else {
                countriesButton.setTitle(countriesName[0], for: .normal)
            }
        }
      //  countriesButton.setTitle(countriesName[countriesId.firstIndex(of: "\(AppDelegate.currentUser.countryId ?? 0)")!], for: .normal)
        countriesDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.countryId = self.countriesId[index]
            self.countryName = self.countriesName[index]
            self.countriesButton.setTitle(self.countryName, for: .normal)
          //  self.getCities()

        }
    }
    
    func setupDropDowns2() {
        customizeDropDown2()
    }
    
    func customizeDropDown2() {
        let appearance = DropDown.appearance()
        appearance.cellHeight = 37
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.separatorColor = UIColor(white: 1, alpha: 0.8)
        //appearance.cornerRadius = 4
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
//        appearance.shadowOpacity = 0.9
//        appearance.shadowRadius = 8
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
//        appearance.textFont =  UIFont(name: "Almarai-Regular", size: 14)!
        //appearance.textFont = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
    }
    
    

    @IBAction func showCitiesClicked(_ sender: UIButton) {
        print("showCitiesClicked")
        citiesDropDwon.show()
    }
    
    @IBAction func showRegionsClicked(_ sender: UIButton) {
        regionsDropDwon.show()
    }
    @IBAction func show_countries2(_ sender: Any) {
        countriesDropDown.show()
    }
    //=================================    END countries   ===============================

    
    @IBAction func changePasswordAction(_ sender: Any) {
//        goNav("chngPassv","Auth")
    }
    @IBAction func changeePhoneAction(_ sender: Any) {
//        goNav("chngMobilev","Auth")

    }
    

    
    @IBAction func selectCountry(_ sender: Any) {
        
    //    open_country_dialog()

    }
    
//    func open_country_dialog() {
//        let countrisC = countriesC(nibName: "countriesC", bundle: nil)
//        countrisC.delegate3 = self
//        presentDialogViewController(countrisC, animationPattern: .zoomInOut)
//    }
    
    func closeDialog(){
        dismissDialogViewController(.fadeInOut)
    }

    @IBAction func pick_img(_ sender: Any) {

        openGallery()
           
    }
    
    
    @IBAction func go(_ sender: Any) {
//        BG.load(self)
        self.view.alpha = 0.5
        guard let image = upic.image else {return}
       let imageData = image.jpegData(compressionQuality: 0.2)!
        guard let url = URL(string: Constants.DOMAIN+"user_edit"),let email = emailTxt.text , let bio = bio.text else {return}
        var params : [String: Any]  = [
            "id":AppDelegate.currentUser.id ?? 0,
                                       "name":txt_lastName.text!,
                                       "username":userNameEN.text!,
                                       "last_name": txt_lastName.text!,
            "mobile": phoneNumber.text ?? "0",
                                       "email": email,
            "country_id":AppDelegate.currentUser.countryId ?? 0,
                                       "city_id":cityId,
                                       "region_id":regionId,
                                       "bio":bio]
        
        print("Parameters of Edit profile",params)
        
        AF.upload(multipartFormData: {multipartFormData in
                
                  //  params["image"] = imageData
//                    multipartFormData.append(imageData, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
                 print("send Image Parameters : -----> ", params)
            for (key,value) in params {
                multipartFormData.append((value as AnyObject).description.data(using: String.Encoding.utf8)!, withName: key)
            }

             
        },to:"\(url)")
        .responseDecodable(of:EditProfileModel.self){ response in
            switch response.result {
            case .success(let data):
                print(data)
                if let data = data.data{
                    self.view.alpha = 1
                    self.fileData(data: data)
                }
                self.navigationController?.popViewController(animated: true)
//                 self.showMiracle()
            case .failure(let error):
                self.view.alpha = 1
                print(error)
                
            }
        }
    }
    
    
    private func fileData(data:EditProfileData){
        print(AppDelegate.currentUser.name)
        if let name = data.name  {
            AppDelegate.currentUser.name = name
        }
        print(AppDelegate.currentUser.name)
        if let lastName = data.lastName {
            AppDelegate.currentUser.lastName = lastName
        }
        if let pass = data.pass {
            AppDelegate.currentUser.pass = pass
        }
        if let pic = data.pic{
            AppDelegate.currentUser.pic = pic
        }
        if let mobile = data.mobile {
            AppDelegate.currentUser.phone = mobile
        }
        if let email = data.email {
            AppDelegate.currentUser.email = email
        }
        if let cityId = data.cityID{
            AppDelegate.currentUser.cityId = Int(cityId)
        }
        if let regionId = data.regionID {
            AppDelegate.currentUser.regionId = Int(regionId)
        }
        if let bio = data.bio {
            AppDelegate.currentUser.bio = bio
        }
        
    }

}
//MARK: DropDwon

extension EditProfileVC {
    
    private func changeProfileImage(image:UIImage){
        APIConnection.apiConnection.uploadImageConnection(completion: { success, message in
            if success {
//                StaticFunctions.createSuccessAlert(msg: message)
            }else {
                StaticFunctions.createErrorAlert(msg: message)
            }
            
        }, link: Constants.EDIT_USER_URL, param: EditProfileParams, image: image, imageType: .profileImage)
    }
    
    func setupCitiesListDropDown(completion:@escaping (_ success:Bool)->()) {
        if MOLHLanguage.currentAppleLanguage() == "en"{
            citiesDropDwon.anchorView = citiesDrop
        }else{
            citiesDropDwon.anchorView = regionsDrop
        }
      
        citiesDropDwon.bottomOffset = CGPoint(x: 0, y: citiesDrop.bounds.height)
        citiesDropDwon.dataSource = citiesName
        if citiesName.count > 0{
//            guard let userCity = UserDefaults.standard.string(forKey: "user_city") else{return}
            if let city = citiesId.firstIndex(of: "\(AppDelegate.currentUser.cityId ?? 0)") {
                citiesDrop.setTitle(citiesName[city], for: .normal)
                cityName = citiesName[city]
                cityId = "\(AppDelegate.currentUser.cityId ?? 0)"
                completion(true)
                
            }

               
        }
        citiesDropDwon.selectionAction = { [unowned self] (index: Int, item: String) in
            self.cityId = self.citiesId[index]
            self.cityName = self.citiesName[index]
            print(self.cityId)
                self.citiesDrop.setTitle(self.cityName, for: .normal)

            completion(true)

        }
    }
    func getCitiesList(){
        citiesName.removeAll()
        citiesId.removeAll()
      //  var params : [String: Any]  = ["method":"cities","country_id":order.countryId]
        
        let params : [String: Any]  = ["country_id":AppDelegate.currentUser.countryId]
        print(params)
        guard let url = URL(string: Constants.DOMAIN+"cities_by_country_id")else {return}
        AF.request(url, method: .post, parameters: params)
            .responseJSON { (e) in
                if let result = e.value {
                    if let dataDic = result as? NSDictionary {
                        if let arr = dataDic["data"] as? NSArray {
                            for itm in arr {
                                if let d = itm as? NSDictionary {
//                                    if let name = d.value(forKey: "name_ar") as? String {
//                                        self.citiesName.append(name)
//                                    }
                                    if  MOLHLanguage.currentAppleLanguage() == "en" {
                                        
                                        if let name = d.value(forKey: "name_en") as? String {
                                            self.citiesName.append(name)
                                        }
                                    }
                                    else{
                                        if let name = d.value(forKey: "name_ar") as? String {
                                            self.citiesName.append(name)
                                        }
                                    }
                                    if let cityId = d.value(forKey: "id") as? Int {
                                        self.citiesId.append("\(cityId)")
                                    }
                                }
                            }
                        }
                    }

                    self.setupCitiesListDropDown{ success in
                        if success {
                            self.getRegionsList()
                        }
                    }
                       
                    
                }

        }
    }
    
    func getRegionsList(){
        regionsName.removeAll()
        regionsId.removeAll()
        let params : [String: Any]  = ["city_id":cityId]
        print(params)
        guard let url = URL(string: Constants.DOMAIN+"region_by_city_id")else {return}
        AF.request(url, method: .post, parameters: params)
            .responseJSON { (e) in
                if let result = e.value {
                    if let dataDic = result as? NSDictionary {
                        if let arr = dataDic["data"] as? NSArray {
                            for itm in arr {
                                if let d = itm as? NSDictionary {
//                                    if let name = d.value(forKey: "name_ar") as? String {
//                                        self.regionsName.append(name)
//                                    }
                                    if  MOLHLanguage.currentAppleLanguage() == "en" {
                                        
                                        if let name = d.value(forKey: "name_en") as? String {
                                            self.regionsName.append(name)
                                        }
                                    }
                                    else{
                                        if let name = d.value(forKey: "name_ar") as? String {
                                            self.regionsName.append(name)
                                        }
                                    }
                                    if let cityId = d.value(forKey: "id") as? Int {
                                        self.regionsId.append("\(cityId)")
                                    }
                                }
                            }
                            print(self.regionsName)
                        }
                    }
                    self.setupRegionsListDropDown()
                    }
                       
                    
                }

    }
    
    func setupRegionsListDropDown() {
//        regionsDropDwon.anchorView = regionsDrop
        if MOLHLanguage.currentAppleLanguage() == "en"{
            regionsDropDwon.anchorView = regionsDrop
        }else{
            regionsDropDwon.anchorView = citiesDrop
        }
        regionsDropDwon.bottomOffset = CGPoint(x: 0, y: regionsDrop.bounds.height)
        regionsDropDwon.dataSource = regionsName
        print(regionsName)
        if regionsName.count > 0 {
          //  regionsDrop.setTitle(regionsName[0], for: .normal)
            //regionId = self.regionsId[0]
//            guard let userRegion = UserDefaults.standard.string(forKey: "user_region") else{return}
            if let region = regionsId.firstIndex(of: "\(AppDelegate.currentUser.regionId ?? 0)") {
                regionsDrop.setTitle(regionsName[region], for: .normal)
                regionId = "\(AppDelegate.currentUser.regionId ?? 0)"
            }
        }else{
            regionsDrop.setTitle("لا توجد مدن", for: .normal)
        }

        regionsDropDwon.selectionAction = { [unowned self] (index: Int, item: String) in
            self.regionId = self.regionsId[index]
            self.regionName = self.regionsName[index]
            print(self.regionId)
            self.regionsDrop.setTitle(self.regionName, for: .normal)
        }
    }
    
    private func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}
extension EditProfileVC  {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumber{
            let maxLength = countPhoneNumber
               let currentString = (textField.text ?? "") as NSString
               let newString = currentString.replacingCharacters(in: range, with: string)

               return newString.count <= maxLength
        }
        return true
    }
}

//MARK: Picked image From Gallery

extension EditProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let capturedImage = info[.originalImage] as? UIImage {
            print("Captured image: \(capturedImage)")
           // self.images.append(capturedImage as UIImage)
            
            self.upic.image = capturedImage
                changeProfileImage(image: capturedImage)
            
            
        }
    }
        
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
