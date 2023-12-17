//
//  sas.swift
//  Bazar
//
//  Created by iOSayed on 25/06/2023.
//

import UIKit
import Alamofire
import PhoneNumberKit
import DropDown
import MOLH
import TransitionButton

class ChangePhoneVC:UIViewController, UITextFieldDelegate{
    
    @IBOutlet var chooseLabels: [UILabel]!
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var lbl_flag: UILabel!
    @IBOutlet weak var img_flag: UIImageView!
    
    @IBOutlet weak var citiesButton: UIButton!
    
    @IBOutlet weak var countryButton: UIButton!
    
    @IBOutlet weak var regionButton: UIButton!
    
    @IBOutlet weak var continueButton: TransitionButton!
    let phoneNumberKit = PhoneNumberKit()
    
    var countryCode:String = "965"
    var country_id:Int = 6
    var country_name:String = ""
    var countries_name = [String]()
    var countries_id = [Int]()
    var countriesPicture = [String]()
    var countriesPhoneCode = [String]()
    
    
    
    var city_id:Int = -1 
    var city_name:String = ""
    var cities_name = [String]()
    var cities_id = [Int]()
    
    var region_id:Int = 0
    var region_name:String = ""
    var regions_name = [String]()
    var regions_id = [Int]()
    
    
    let countries = DropDown()
    let cities = DropDown()
    let regions = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.countries,
            self.cities,
            self.regions
        ]
    }()
    
    
    var countPhoneNumber: Int {
        if country_id ==  5 || country_id == 10{
            return 9
        }else{
            return  8
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        country_id = AppDelegate.currentUser.countryId ?? 0
        city_id = AppDelegate.currentUser.cityId ?? 0
        region_id = AppDelegate.currentUser.regionId ?? 0
        customizeDropDown()
        getCountries()
        getCities()
      //  getRegions(cityId: city_id)
        phone.delegate = self
        
        chooseLabels.forEach { label in
            //
        }
        
        do {
            
            let phoneNumberCustomDefaultRegion = try phoneNumberKit.parse(AppDelegate.currentUser.phone ?? "", ignoreType: false)
            print(phoneNumberCustomDefaultRegion)
            phone.text = String(phoneNumberCustomDefaultRegion.nationalNumber)
            lbl_flag.text = String(phoneNumberCustomDefaultRegion.countryCode)                }
        catch {
         //   let mobile = AppDelegate.currentUser.phone?.dropFirst(3) ?? ""
            let mobile = AppDelegate.currentUser.phone ?? ""
            phone.text = String(mobile)
            
            print("Generic parser error")
        }
        
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func showCountryClicked(_ sender: UIButton) {
        print("showCountryClicked")
        countries.show()
    }
    
    @IBAction func showRegionClicked(_ sender: UIButton) {
        print("showRegionClicked")
        regions.show()
    }
    
    @IBAction func showCitiesClicked(_ sender: UIButton) {
        print("showCitiesClicked")
        cities.show()
    }
    
    
    
    @IBAction func go_country_code(_ sender: Any) {
        var coountryVC = CounriesViewController()
        
        coountryVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COUNTRY_VCIID) as!  CounriesViewController
        coountryVC.countryBtclosure = {
            (country) in
            self.countryCode = country.code ?? ""
            self.lbl_flag.text = country.code
            self.img_flag.setImageWithLoading(url: country.image ??
                                              "")
        }
        self.present(coountryVC, animated: true, completion: nil)
    }
    
    @IBAction func go(_ sender: Any) {
        guard let phone = phone.text else {return}
        
        let mobile = "\(countryCode)\(phone)"
        
        if !phone.isEmpty {
            continueButton.startAnimation()
            //Check Exist User
            let params1 : [String: Any]  = ["email":mobile ,"type":"ChangePhone"]
            print("parameters of check user ",params1)
            guard let url = URL(string: Constants.DOMAIN+"check-user")else {return}
            AF.request(url, method: .post, parameters: params1, encoding:URLEncoding.httpBody , headers: Constants.header).responseDecodable(of:SuccessModelLike.self){ res in
                switch res.result {
                    
                case .success(let data):
                    if let success = data.success , let message = data.message {
                        if success {
                            // send code
                            let params : [String: Any]  = ["user_id":AppDelegate.currentUser.id ?? 0, "mobile":mobile ]
                            print(params)
                            guard let url = URL(string: Constants.DOMAIN+"resend_code")else{return}
                            AF.request(url, method: .post, parameters: params)
                                .responseDecodable(of:SuccessVerifiationModel.self){ res in
                                    self.continueButton.stopAnimation()
                                    switch res.result {
                                    case .success(let data):
                                        guard let success = data.success , let message = data.message else{return}
                                        if success {
                                            let storyboard = UIStoryboard(name: Auth_STORYBOARD, bundle: nil)
                                            let vc = storyboard.instantiateViewController(withIdentifier:"VerifyCodeVC") as! VerifyCodeVC
                                            vc.userPhoneNumber = mobile
                                            vc.countryId = self.country_id
                                            vc.cityId = self.city_id
                                            vc.regionId = self.region_id
                                            self.navigationController?.pushViewController(vc,animated: true)
                                        }else{
                                            StaticFunctions.createErrorAlert(msg:message)
                                        }
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                            //
                        }else {
                            //phone is Exist in system
                            self.continueButton.stopAnimation()
                            StaticFunctions.createErrorAlert(msg:message)
                        }
                    }
                case .failure(let error):
                    self.continueButton.stopAnimation()
                    print(error)
                }
            }
            
            //
            //
            //
            //                .responseString { (e) in
            //                    print(e)
            //                    if let res = e.value {
            //                        if res.contains("true"){
            //                            self.msg("هذا الرقم مسجل لدينًا مسبقًا","msg")
            //
            //                        }else{
            ////                            BG.load(self)
            ////                            let params : [String: Any]  = ["method":"changeMobile",
            ////                                                           "type":user.type,
            ////                                                           "id":user.id,
            ////                                                           "mobile": mobile,
            ////                                                           "country_id":self.country_id,
            ////                                                           "city_id":self.city_id,
            ////                                                           "region_id":self.region_id]
            ////
            ////                            print(" Parameters of Edit Mobile ", params)
            ////                            AF.request(user.url, method: .post, parameters: params, encoding:URLEncoding.httpBody , headers: temp.header)
            ////                                .responseString { (e) in
            ////                                    print(e)
            ////                                    if let res = e.value {
            ////                                        if res.contains("true"){
            ////                                            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            ////                                            let vc = storyboard.instantiateViewController(withIdentifier:"ForgetPasswordVC") as! ForgetPasswordVC
            ////                                            vc.isChangePhone = true
            ////                                            self.navigationController?.pushViewController(vc,animated: true)
            ////
            ////                                        }else{
            ////                                            print("error")
            ////                                        }
            ////                                    }
            ////                                }
            //                        }
            //                    }
            //                }
        }
        
    }
    
    
    
    
}
extension ChangePhoneVC  {
    
    func setupCitiesDropDown(completion:@escaping (_ success:Bool)->()) {
        if MOLHLanguage.currentAppleLanguage() == "en"{
            cities.anchorView = citiesButton
        }else{
            cities.anchorView = regionButton
        }
        cities.bottomOffset = CGPoint(x: 0, y: citiesButton.bounds.height)
        cities.dataSource = cities_name
        if cities_name.count > 0{
            if let city = cities_id.firstIndex(of: city_id) {
                citiesButton.setTitle(cities_name[city], for: .normal)
                city_name = self.cities_name[city]
            }else {
                citiesButton.setTitle(cities_name[0], for: .normal)
            }
            completion(true)
           
            
        }else {
            completion(false)
            citiesButton.setTitle("Not have cities".localize, for: .normal)

        }
        cities.selectionAction = { [unowned self] (index: Int, item: String) in
            self.city_id = self.cities_id[index]
            self.city_name = self.cities_name[index]
            print(self.city_id)
            
            self.citiesButton.setTitle(self.city_name, for: .normal)
            completion(true)
            
        }
    }
    func getCities(){
        cities_name.removeAll()
        cities_id.removeAll()
        let params : [String: Any]  = ["country_id":country_id]
        print(params)
        guard let url = URL(string: Constants.DOMAIN+"cities_by_country_id")else {return}
        AF.request(url, method: .post, parameters: params)
            .responseJSON { (e) in
                if let result = e.value {
                    if let dataDic = result as? NSDictionary {
                        if let arr = dataDic["data"] as? NSArray {
                            for itm in arr {
                                if let d = itm as? NSDictionary {
                                    
                                    
                                    if  MOLHLanguage.currentAppleLanguage() == "en" {
                                        
                                        if let name = d.value(forKey: "name_en") as? String {
                                            self.cities_name.append(name)
                                        }
                                    }
                                    else{
                                        if let name = d.value(forKey: "name_ar") as? String {
                                            self.cities_name.append(name)
                                        }
                                    }
                                    if let cityId = d.value(forKey: "id") as? Int {
                                        self.cities_id.append(cityId)
                                    }
                                }
                            }
                            if self.city_id == -1 && !self.cities_id.isEmpty{
                                self.city_id = self.cities_id[0]
                            }else{
                                //self.citiesButton.setTitle("Not have cities".localize, for: .normal)
                               // self.regionButton.setTitle("Not have regions".localize, for: .normal)
//
                            }
                           
                            
                        }
                    }
                    self.setupCitiesDropDown{ success in
                        if success{
                            self.getRegions(cityId: self.city_id)
                        }else{
                            self.regions_name.removeAll()
                            self.regions.dataSource = []
                            self.regionButton.setTitle("Not have regions".localize, for: .normal)
                        }
                    }
                    
                    
                }
                
            }
    }
    
    func getRegions(cityId:Int){
        regions_name.removeAll()
        regions_id.removeAll()
        let params : [String: Any]  = ["city_id":cityId]
        guard let url = URL(string: Constants.DOMAIN+"region_by_city_id")else {return}
        AF.request(url, method: .post, parameters: params, encoding:URLEncoding.httpBody , headers: Constants.header)
            .responseJSON { (e) in
                if let result = e.value {
                    if let dataDic = result as? NSDictionary {
                        if let arr = dataDic["data"] as? NSArray {
                            for itm in arr {
                                if let d = itm as? NSDictionary {
//                                    if let name = d.value(forKey: "name_ar") as? String {
//                                        self.regions_name.append(name)
//                                    }
                                    
                                    if  MOLHLanguage.currentAppleLanguage() == "en" {
                                        
                                        if let name = d.value(forKey: "name_en") as? String {
                                            self.regions_name.append(name)
                                        }
                                    }
                                    else{
                                        if let name = d.value(forKey: "name_ar") as? String {
                                            self.regions_name.append(name)
                                        }
                                    }
                                    if let cityId = d.value(forKey: "id") as? Int {
                                        self.regions_id.append(cityId)
                                    }
                                }
                            }
                            print("regions ",self.regions_name)
                        }
                    }
      
                    self.setupRegionsDropDown()
                }
                
            }
    }
    
    func getCountries(){
        countries_name.removeAll()
        countries_id.removeAll()
        countriesPicture.removeAll()
        countriesPhoneCode.removeAll()
        //  let params : [String: Any]  = ["method":"countries"]
        guard let url = URL(string: Constants.DOMAIN+"countries")else {return}
        AF.request(url, method: .post)
            .responseJSON { (e) in
                if let result = e.value {
                    if let dataDic = result as? NSDictionary {
                        if let arr = dataDic["data"] as? NSArray {
                            for itm in arr {
                                if let d = itm as? NSDictionary {
                                    if  MOLHLanguage.currentAppleLanguage() == "en" {
                                        if let name = d.value(forKey: "name_en") as? String {
                                            self.countries_name.append(name)
                                        }
                                    }
                                    else{
                                        if let name = d.value(forKey: "name_ar") as? String {
                                            self.countries_name.append(name)
                                        }
                                    }
                                    
                                    if let id = d.value(forKey: "id") as? Int {
                                        self.countries_id.append(id)
                                    }
                                    if let pic = d.value(forKey: "pic") as? String {
                                        self.countriesPicture.append(pic)
                                    }
                                    if let code = d.value(forKey: "code") as? String {
                                        self.countriesPhoneCode.append(code)
                                    }
                                }
                            }
                            print(self.countries_name)
                        }
                    }
                    self.setupCountriesDropDown()
                }
            }
    }
    func setupCountriesDropDown() {
        //  countryCode = ""
        countries.anchorView = countryButton
        countries.bottomOffset = CGPoint(x: 0, y: countryButton.bounds.height)
        countries.dataSource = countries_name
        countryButton.setTitle(countries_name[countries_id.firstIndex(of: country_id)! ], for: .normal)
        
        countries.selectionAction = { [unowned self] (index: Int, item: String) in
            self.country_id = self.countries_id[index]
            self.country_name = self.countries_name[index]
            //  user.country_code = self.countries_id[index]
            img_flag.setImageWithLoading(url:countriesPicture[index])
            print(countriesPhoneCode)
            countryCode = countriesPhoneCode[index]
            print(countryCode)
            self.city_id = -1
            DispatchQueue.main.async {
                self.lbl_flag.text = "\(self.countryCode)"
                print(self.country_id)
                print(self.country_name)
                self.countryButton.setTitle(self.country_name, for: .normal)
            }
            getCities()
        }
    }
    
    func setupRegionsDropDown() {
        //        regions.anchorView = regionButton
        if MOLHLanguage.currentAppleLanguage() == "en"{
            regions.anchorView = regionButton
        }else{
            regions.anchorView = citiesButton
        }
        regions.bottomOffset = CGPoint(x: 0, y: regionButton.bounds.height)
        regions.dataSource = regions_name
        if regions_name.count > 0 {
            if let region = regions_id.firstIndex(of: region_id) {
                print(region)
                regionButton.setTitle(regions_name[region], for: .normal)
                region_name = self.regions_name[region]
                print(region_name)
            }else {
                regionButton.setTitle(regions_name[0], for: .normal)
            }
            
        }else{
            regionButton.setTitle("Not have regions".localize, for: .normal)
        }
        
        print(cities_name.count)
        regions.selectionAction = { [unowned self] (index: Int, item: String) in
            self.region_id = self.regions_id[index]
            self.region_name = self.regions_name[index]
            print(self.region_id)
            self.regionButton.setTitle(self.region_name, for: .normal)
        }
    }
    
    
}
extension ChangePhoneVC  {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phone{
            let maxLength = countPhoneNumber
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.count <= maxLength
        }
        return true
    }
}
