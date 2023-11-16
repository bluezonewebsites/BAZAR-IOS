//
//  VerifyAccountVC.swift
//  Bazar
//
//  Created by iOSayed on 10/06/2023.
//

    import UIKit
    import Alamofire
    import DropDown
    import MOLH
//    import NextGrowingTextView

class VerifyAccountVC: UIViewController, UITextFieldDelegate {
        
        @IBOutlet weak var pic: UIImageView!
        var tajeer = 0
        
        //tajeer
        @IBOutlet weak var tajeerv: UIView!
        @IBOutlet weak var tajeer_img: UIImageView!
        @IBOutlet weak var tajeer_txt: UILabel!
        
        //sell
        @IBOutlet weak var sellv: UIView!
        @IBOutlet weak var sell_img: UIImageView!
        @IBOutlet weak var sell_txt: UILabel!
        

        @IBOutlet weak var oneImageView: UIView!
        
        @IBOutlet weak var moreThanOneView: UIView!
        @IBOutlet weak var phoneNumber: UITextField!
        
        @IBOutlet weak var countryImage: UIImageView!
        @IBOutlet weak var phoneCode: UILabel!
        
        
        let textField = UITextField()
        lazy var dropDowns: [DropDown] = {
            return [
                self.countries,
                self.cats,
                self.documents
            ]
        }()
        
        var countPhoneNumber: Int {
            if AppDelegate.currentUser.countryId == 5 || AppDelegate.currentUser.countryId  == 10 {
                    return 9
                }else{
                    return  8
                }
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
            tajeerv.borderWidth = 0.7
            StaticFunctions.setImageFromAssets(sell_img, "checkbox")
            sellv.backgroundColor = UIColor(named: "#0093F5")
            StaticFunctions.setTextColor(sell_txt, UIColor.white)
            phoneNumber.delegate = self
            phoneNumber.text = removeCountryCode(from: "\(AppDelegate.currentUser.phone ?? "")")
            
//            phoneCode.text = "\(AppDelegate.currentUser.phone?.prefix(3) ?? "")"
           if MOLHLanguage.currentAppleLanguage() == "en" {
               pic.image = UIImage(named: "addDocumentEng")
            }else{
                pic.image = UIImage(named: "addDocumentAR")
            }

            countriesBtn.setTitle(AppDelegate.currentUser.countriesNameEn, for: .normal)
            
            dropDowns.forEach { $0.dismissMode = .onTap }
            dropDowns.forEach { $0.direction = .any }
            customizeDropDown()
            setupDropDownCats()
//            getCountries()
            getCountriesList()
            documents_name = ["ID card".localize,"passport".localize ,"Driving License".localize]
            setupDropDownDocuments()
            
        }
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = .white
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
        tabBarController?.tabBar.isHidden = false
        
    }
    
    private func getCountriesList(){
        CountryController.shared.getCountries { countries,check, message in
            
            if check == 0 {
                if MOLHLanguage.currentAppleLanguage() == "en"{
                    self.countries_name = countries.compactMap(\.nameEn)
                }else {
                    self.countries_name = countries.compactMap(\.nameAr)
                }
                self.countriesCode = countries.compactMap(\.code)
                self.countries_id = countries.compactMap(\.id)
                self.setupCountriesDropDown()
            }else {
               print(message)
            }
        }
    }
        
        //===================================     cats   ===================================
        @IBOutlet weak var catsBtn: UIButton!
        
        var cat_name:String = ""
    var cats_name =
    [
        "select category".localize,
        "sports".localize,
        "music and singing".localize,
        "entertainment".localize,
        "acting".localize,
        "Fashion".localize,
        "Content Creator/Blogger/Influencer".localize,
        "writer/author".localize,
        "Government and Politics".localize,
        "business/brand".localize
    ]
        let cats = DropDown()
        
        func setupDropDownCats() {
            cats.anchorView = catsBtn
            cats.textColor = .black
            cats.bottomOffset = CGPoint(x: 0, y: catsBtn.bounds.height)
            cats.dataSource = cats_name
            catsBtn.setTitle(cats_name[0], for: .normal)
            self.cat_name = self.cats_name[0]
            cats.selectionAction = { [unowned self] (index: Int, item: String) in
                self.cat_name = self.cats_name[index]
                self.catsBtn.setTitle(self.cat_name, for: .normal)
            }
        }

        
        @IBAction func selectCountry(_ sender: UIButton) {
          //  open_country_dialog()
        }
        
        
        @IBAction func show_cats(_ sender: Any) {
            cats.show()
        }

        @IBOutlet weak var documentsBtn: UIButton!
        
        var document_name:String = ""
        var documents_name = [String]()
      
        let documents = DropDown()
        
        func setupDropDownDocuments() {
            documents.anchorView = documentsBtn
            documents.textColor = .black
            documents.bottomOffset = CGPoint(x: 0, y: documentsBtn.bounds.height)
            documents.dataSource = documents_name
            documentsBtn.setTitle(documents_name[0], for: .normal)
            self.document_name = self.documents_name[0]
            documents.selectionAction = { [unowned self] (index: Int, item: String) in
                self.document_name = self.documents_name[index]
                self.documentsBtn.setTitle(self.document_name, for: .normal)
            }
        }
        
        @IBAction func show_documents(_ sender: Any) {
            documents.show()
        }
        //===================================    END documents   ===================================
        
        
      
        
        func getCountries(){
            guard let url = URL(string: Constants.DOMAIN+"countries")else {return}
            AF.request(url, method: .post)
                .responseJSON { [weak self] (e) in
                    guard let self = self else {return}
                    if let result = e.value {
                        if let dataDic = result as? NSDictionary {
                            if let arr = dataDic["data"] as? NSArray {
                                for itm in arr {
                                    if let d = itm as? NSDictionary {
                                        if MOLHLanguage.currentAppleLanguage() == "en"{
                                            if let name = d.value(forKey: "name_en") as? String {
                                                self.countries_name.append(name)
                                            }
                                        }else {
                                            if let name = d.value(forKey: "name_ar") as? String {
                                                self.countries_name.append(name)
                                            }
                                        }
                                       
                                        if let id = d.value(forKey: "id") as? Int {
                                            self.countries_id.append(id)
                                        }
                                        if let code = d.value(forKey: "code") as? Int {
                                            self.countriesCode.append("\(code)")
                                        }
                                        

                                    }
                                }
                                print(self.countries_name)
                                print(self.countriesCode)
                            }

                            self.setupCountriesDropDown()
                        }

                    }
                }
        }
        
        //===================================     countries   ===================================
        @IBOutlet weak var countriesBtn: UIButton!
        
        var country_id:Int = 0
        var country_name:String = ""
        var countries_name = [String]()
        var countries_id = [Int]()
        var countriesCode = [String]()
        var countryCode:String = ""
            
        let countries = DropDown()
        
        func setupCountriesDropDown() {
            countries.anchorView = countriesBtn
            countries.textColor = .black
            countries.bottomOffset = CGPoint(x: 0, y: countriesBtn.bounds.height)
            countries.dataSource = countries_name
            if countries_name.count > 0 {
                self.countryCode = self.countriesCode[countries_id.firstIndex(of: (AppDelegate.currentUser.countryId ?? 0))!]
                countriesBtn.setTitle(countries_name[countries_id.firstIndex(of: (AppDelegate.currentUser.countryId ?? 0))!], for: .normal)
            }else {
                countriesBtn.setTitle("Country".localize, for: .normal)
            }
            
            countries.selectionAction = { [unowned self] (index: Int, item: String) in
                self.country_id = self.countries_id[index]
                self.country_name = self.countries_name[index]
                self.countryCode = self.countriesCode[index]
                phoneCode.text =  self.countryCode
                print(self.country_id)
                self.countriesBtn.setTitle(self.country_name, for: .normal)
            }
        }
        
        @IBAction func show_countries(_ sender: Any) {
            countries.show()
        }
        //=================================    END countries   ===============================
        
        
        @IBAction func go() {
            //order.askImage
//                BG.load(self)
            guard let mobile = phoneNumber.text else{return}
            
            guard let imageData = pic.image?.jpegData(compressionQuality: 0.1) else {return}
            let params : [String: Any]  = ["uid":AppDelegate.currentUser.id ?? 0,
                                              "note":" ",
                                               "account_type":tajeer,
                                               "category":cat_name,
                                               "document_type":document_name,
                                           "country_id":AppDelegate.currentUser.countryId ?? 0, "mobile":mobile]
            if cat_name == "" && country_name == "" && document_name == "" {
                StaticFunctions.createErrorAlert(msg:"من فضلك ادخل جميع البيانات")
            }else {
                guard let url = URL(string: Constants.DOMAIN+"users_pending")else{return}
                print(params)
                AF.upload(multipartFormData: {multipartFormData in
                    
                    multipartFormData.append(imageData, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
                    print("send Image Parameters : -----> ", params)
                    for (key,value) in params {
                        multipartFormData.append((value as AnyObject).description.data(using: String.Encoding.utf8)!, withName: key)
                    }
                    
                    
                },to:"\(url)")
                .responseDecodable(of:SuccessfulVerifyModel.self){ response in
                    print(response)
//                    BG.hide(self)
                    switch response.result {
                    case .success(let data):
                        print(data)
                        if let success = data.success{
                            if success {
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        
    
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
        @IBAction func go_pick_img() {
            
            print("login")
            
            let vc = UIStoryboard(name: CATEGORRY_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier:ASK_IMAGE_PICKER_VCID ) as! AskImagePickerViewController
            vc.chooseImageBtclosure = {
                image in
                self.pic.image = image
            }
            self.present(vc, animated: false, completion: nil)
        }
        
        
        @IBAction func rd_sell_tajeer(_ sender:UIButton) {
            tajeer = sender.tag
            if(sender.tag == 1){
                sellv.borderWidth = 0.7
                tajeerv.borderWidth = 1.2
                sellv.borderColor = UIColor.gray
                tajeerv.borderColor =  UIColor(named: "#0093F5")
                StaticFunctions.setImageFromAssets(sell_img, "radio_grey")
                StaticFunctions.setImageFromAssets(tajeer_img, "checkbox")
                StaticFunctions.setTextColor(sell_txt, UIColor.gray)
                StaticFunctions.setTextColor(tajeer_txt, UIColor.white)
                sellv.backgroundColor = UIColor.white
                tajeerv.backgroundColor = UIColor(named: "#0093F5")
                
                documents_name = [
                    "Establishment contract".localize,
                    "Commercial Record".localize,
                    "Commercial license".localize
                ]
                
                
            }else{
    //            sellv.backgroundColor = colors.whiteColor
    //            tajeerv.backgroundColor = colors.main
                
                sellv.borderWidth = 1.2
                tajeerv.borderWidth = 0.7
                sellv.borderColor = UIColor(named: "#0093F5")
                tajeerv.borderColor = UIColor.gray
                StaticFunctions.setImageFromAssets(sell_img, "checkbox")
                StaticFunctions.setImageFromAssets(tajeer_img, "radio_grey")
                StaticFunctions.setTextColor(sell_txt, UIColor.white)
                StaticFunctions.setTextColor(tajeer_txt, UIColor.gray)
                sellv.backgroundColor = UIColor(named: "#0093F5")
                tajeerv.backgroundColor = UIColor.white
                documents_name = ["ID card".localize,"passport".localize ,"Driving License".localize]
            }
            setupDropDownDocuments()
        }

    }
  
    extension VerifyAccountVC  {
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


