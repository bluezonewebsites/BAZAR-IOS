//
//  monasba
//
//  Created by iOSAYed on 1/16/21.
//  Copyright © 2023 roll. All rights reserved.
//

import UIKit
import Alamofire

class EditAdVC:UIViewController  {
    
    
    
    @IBOutlet weak private var adsMainImage: UIImageView!
    @IBOutlet weak private var titleLabel: UITextField!
    @IBOutlet weak private var descTextView: UITextView!
    @IBOutlet weak private var oneImageView: UIView!
    @IBOutlet weak private var collectionView: UICollectionView!
    //price
    @IBOutlet weak private var PriceTxetField: UITextField!
    @IBOutlet weak private var sw_price: UISwitch!
    @IBOutlet weak private var pricev: UIView!
    //contact
    @IBOutlet weak private var lbl_put_phone: UILabel!
    @IBOutlet weak private var txt_phone: UITextField!
    @IBOutlet weak private var view_put_phone: UIView!
    @IBOutlet weak private var sw_my_phone: UISwitch!
    //tajeer
    @IBOutlet weak private var tajeerView: UIView!
    @IBOutlet weak private var tajeerButtonImage: UIImageView!
    @IBOutlet weak private var tajeerLabel: UILabel!
    //sell
    @IBOutlet weak private var sellView: UIView!
    @IBOutlet weak private var sellButtonImage: UIImageView!
    @IBOutlet weak private var sellLabel: UILabel!
    //has_phone
    @IBOutlet weak private var has_phonev: UIView!
    @IBOutlet weak private var has_phone_img: UIImageView!
    @IBOutlet weak private var has_phone_txt: UILabel!
    //has_wts
    @IBOutlet weak private var has_wtsv: UIView!
    @IBOutlet weak private var has_wts_img: UIImageView!
    @IBOutlet weak private var has_wts_txt: UILabel!
    //has_chat
    @IBOutlet weak private var has_chatv: UIView!
    @IBOutlet weak private var has_chat_img: UIImageView!
    @IBOutlet weak private var has_chat_txt: UILabel!
    //location
    @IBOutlet weak private var loc_main: UILabel!
    @IBOutlet weak private var loc_sub: UILabel!
   
   private var tajeer = 0
   private var has_phone = "on"
   private var has_wts = "off"
   private var has_chat = "off"
   private var deletedImages = [String]()
   private var catId = ""
   private var cityId = ""
   private var countryId = ""
   private var regionId = ""
   private var subCatId = ""
   private var editedMainImage = false
    
    var product = Product()
    var images = [String]()
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Private Methods
    
    private func configureUI(){
        has_chatv.borderWidth = 0.7
        has_wtsv.borderWidth = 0.7
        tajeerView.borderWidth = 0.7
        configerSelectedButtons()
    }
    
    
    
    //MARK: IBActions
    
    @IBAction func didTapEditMainImageButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapShowPickedImageViewButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapTajeerButton(_ sender: UIButton) {
        setupTajeerViewUI()
    }
    
    @IBAction func didTapSellButton(_ sender: UIButton) {
        setupSellViewUI()
    }
    
    @IBAction func didTapChatButton(_ sender: UIButton) {
        if (has_chat == "off"){
            has_chat = "on"
            has_chatv.borderWidth = 1.2
            has_chatv.borderColor = .white
            has_chatv.backgroundColor = UIColor(named: "#0EBFB1")
            StaticFunctions.setTextColor(has_chat_txt, UIColor.white)
            StaticFunctions.setImageFromAssets(has_chat_img, "checkbox")
        }else{
            has_chat = "off"
            has_chatv.borderWidth = 1.2
            has_chatv.borderColor = .gray
            has_chatv.backgroundColor = .white
            StaticFunctions.setTextColor(has_chat_txt, UIColor.black)
            StaticFunctions.setImageFromAssets(has_chat_img, "")
        }
    }
    
    @IBAction func didTapWhatsButton(_ sender: UIButton) {
        if (has_wts == "off"){
            setupWhatsOff()
        }else{
            setupWhatsOn()
        }
    }
    
    
    @IBAction func didTapCallButton(_ sender: UIButton) {
        if (has_phone == "off"){
            setupHasPhoneViewUI()
        }else{
            setupNotHasPhoneViewUI()
        }
    }
    
    @IBAction func didTapSwitchPhoneButton(_ sender: Any) {
        if sw_my_phone.isOn{
            lbl_put_phone.isHidden = true
            view_put_phone.isHidden = true
        }else{
            lbl_put_phone.isHidden = false
            view_put_phone.isHidden = false
        }
    }
    
    @IBAction func didTapSaveButton(_ sender: UIButton) {
    }
    
    @IBAction func didTapDeleteButton(_ sender: UIButton) {
    }
    
}
//MARK: fileprivate Methods
extension EditAdVC{
    
    fileprivate  func getData(){
        ProductController.shared.getProducts(completion: {
            product, check, msg in
            
            if check == 0{
                self.product = product.data
                print(product.images)
                for i in product.images{
                    self.images.append(i.image ?? "")
                }
                print(self.images)
                self.setData()
                
            }else{
                StaticFunctions.createErrorAlert(msg: msg)
                self.navigationController?.popViewController(animated: true)
            }
            
        }, id: 9571)
    }
    
    fileprivate func setData(){
        self.titleLabel.text = product.name
        
        self.descTextView.text = product.description
        if let price = product.price {
            self.PriceTxetField.text = "\(price)"
        }
        if let tajeer = product.type {
            self.tajeer = tajeer
        }
        
        if let countryId = product.countryId {
            self.countryId = "\(countryId)"
        }
        if let cityId = product.cityId {
            self.cityId = "\(cityId)"
        }
        if let regionId = product.regionId {
            self.regionId = "\(regionId)"
        }
//        if let catId = data.prod?.catID {
//            self.catId = "\(catId)"
//        }
//        if let subCatId = data.prod?.subCatID {
//            self.subCatId = "\(subCatId)"
//        }
            //contact
        self.has_phone = product.hasPhone == "on" ? "off":"on"
        self.has_wts = product.hasWhatsapp == "on" ? "off":"on"
        self.has_chat = product.hasChat == "on" ? "off":"on"
        
        self.txt_phone.text = product.phone
        
        
        //Main Image
        if let mainImage = product.image {
            adsMainImage.setImageWithLoading(url: mainImage)
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func configerSelectedButtons() {
        descTextView.textAlignment = .center
        setupSellViewUI()
        setupHasPhoneViewUI()
        tajeerButtonImage.isHidden = true
        tajeerLabel.textColor = .black
        StaticFunctions.setImageFromAssets(has_wts_img, "")
        StaticFunctions.setImageFromAssets(has_chat_img, "")
        has_chat_txt.textColor = .black
        has_wts_txt.textColor = .black
        has_wtsv.borderWidth = 1.2
        has_chatv.borderWidth =  1.2
        has_wtsv.borderColor = .gray
        has_chatv.borderColor =  .gray
        view_put_phone.isHidden = true
        lbl_put_phone.isHidden = true
    }
    fileprivate func setupTajeerViewUI() {
        sellView.borderWidth = 0.7
        tajeerView.borderWidth = 1.2
        sellButtonImage.borderWidth = 0.7
        sellButtonImage.borderColor = .white
        tajeerView.backgroundColor = UIColor(named: "#0EBFB1")
        sellView.backgroundColor = .white
    sellView.borderColor = .gray
        tajeerView.borderColor = .white
        sellButtonImage.isHidden = true
        tajeerButtonImage.isHidden = false
    StaticFunctions.setImageFromAssets(tajeerButtonImage, "radiobtn")
    StaticFunctions.setTextColor(sellLabel, UIColor.black)
    StaticFunctions.setTextColor(tajeerLabel, UIColor.white)
        
    }
    
    fileprivate func setupSellViewUI() {
        sellView.borderWidth = 1.2
        tajeerView.borderWidth = 0.7
        tajeerButtonImage.borderWidth = 0.7
        tajeerButtonImage.borderColor = .white
        sellView.backgroundColor = UIColor(named: "#0EBFB1")
        tajeerView.backgroundColor = .white
        sellView.borderColor = .white
        tajeerView.borderColor = .gray
        StaticFunctions.setImageFromAssets(sellButtonImage, "radiobtn")
        sellButtonImage.isHidden = false
        tajeerButtonImage.isHidden = true
        StaticFunctions.setTextColor(sellLabel, UIColor.white)
        StaticFunctions.setTextColor(tajeerLabel, UIColor.black)
    }
    
    fileprivate func setupHasPhoneViewUI(){
        has_phone = "on"
        has_phonev.borderWidth = 1.2
        has_phonev.backgroundColor = UIColor(named: "#0EBFB1")
        has_phonev.borderColor = .white
        StaticFunctions.setTextColor(has_phone_txt,UIColor.white)
        StaticFunctions.setImageFromAssets(has_phone_img, "checkbox")
    }
    fileprivate func setupNotHasPhoneViewUI() {
        has_phone = "off"
        has_phonev.borderWidth = 1.2
        has_phonev.borderColor = .gray
        has_phonev.backgroundColor = .white
        StaticFunctions.setTextColor(has_phone_txt, UIColor.black)
        StaticFunctions.setImageFromAssets(has_phone_img, "")
    }
    fileprivate func setupWhatsOff() {
        has_wts = "on"
        has_wtsv.borderWidth = 1.2
        has_wtsv.borderColor = .white
        has_wtsv.backgroundColor = UIColor(named: "#0EBFB1")
        StaticFunctions.setTextColor(has_wts_txt, UIColor.white)
        StaticFunctions.setImageFromAssets(has_wts_img, "checkbox")
    }
    
    fileprivate func setupWhatsOn() {
        has_wts = "off"
        has_wtsv.borderWidth = 1.2
        has_wtsv.borderColor = .gray
        has_wtsv.backgroundColor = .white
        StaticFunctions.setTextColor(has_wts_txt, UIColor.black)
        StaticFunctions.setImageFromAssets(has_wts_img, "")
    }
}
extension EditAdVC : UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvsImagesCollectionViewCell", for: indexPath) as? AdvsImagesCollectionViewCell else {return UICollectionViewCell()}
        if let url = URL(string:  self.images[indexPath.item]) {
            cell.imageView.sd_setImage(with:url , placeholderImage: nil)
        }
       
        return cell
    }
    
}
