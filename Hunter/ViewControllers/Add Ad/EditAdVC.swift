//
//  Bazar
//
//  Created by iOSAYed on 1/16/21.
//  Copyright © 2023 roll. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import TransitionButton
import MOLH

enum ImageDataSource {
    case url(URL)
    case image(UIImage)
}

class EditAdVC:UIViewController, PickupMediaPopupEditAdsVCDelegate  {
    
    @IBOutlet weak var mainImageFlagView: UIView!
    @IBOutlet weak var deleteMainImageButton: UIButton!
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
    @IBOutlet weak var saveButton: TransitionButton!
    @IBOutlet weak var deleteButton: TransitionButton!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    
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
   private var mainImageDeleted = false
    
    var selectedImages = [UIImage]()
    var selectedVideos = [Data]()
    var selectedMedia = [String:Data]()
    var productId = 0
    var product = Product()
//    var images = [String]()
    var dataSource: [ImageDataSource] = []
    var isMainImage = false
    var isEditImages = false
    var mainImage:Data?
    var productsImages = [ProductImage]()
    var imagesDeleted = [Int]()
    
    var countPhoneNumber: Int {
        if AppDelegate.currentUser.countryId ==  5 || AppDelegate.currentUser.countryId == 10{
            return 9
        }else{
            return  8
        }
    }
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        configureUI()
        txt_phone.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        getData()
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    //MARK: Private Methods
    
    private func configureUI(){
        deleteMainImageButton.setImage(UIImage(named: "delete_chat")?.withRenderingMode(.alwaysTemplate), for: .normal)
       
        tajeerView.borderWidth = 0.7
        configerSelectedButtons()
    }
    
    
    
    func PickupMediaPopupEditVC(_ controller: PickupMediaPopupEditAdsVC, didSelectImages image: UIImage,mainVideo:Data?, videos: [Data], selectedMedia: [String : Data]) {
        if isMainImage {
            adsMainImage.image = image
            mainImageDeleted = false
            UIView.animate(withDuration: 0.3) {
                self.mainImageFlagView.isHidden = false
            }
            if mainVideo == nil {
                mainImage = image.jpegData(compressionQuality: 0.1)!
            }else {
                // main image = video
                guard let mainVideo = mainVideo else {return}
                mainImage = mainVideo
            }
           
            editedMainImage = true
//            guard  mainImage == image.jpegData(compressionQuality: 0.1) else {return}
        }else{
            isEditImages = true
            self.dataSource.append(.image(image))
        }
        
//        self.selectedImages = images
        self.selectedVideos = videos
        self.selectedMedia = selectedMedia
//        print("Images Count ", images.count)
        print(selectedVideos)
        print("Videos Count " , selectedVideos.count)
        print("selectedMedia ------->",selectedMedia)
        self.collectionView.reloadData()
    }
    
    //MARK: IBActions
    
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTapDeleteMainImage(_ sender: UIButton) {
        mainImage = nil
        isEditImages = true
        editedMainImage = true
        mainImageDeleted = true
        UIView.animate(withDuration: 0.3) {
            self.mainImageFlagView.isHidden = true
        }
        if MOLHLanguage.currentAppleLanguage() == "en"{
            DispatchQueue.main.async {
                self.adsMainImage.image = UIImage(named: "addimageEnglish")
            }
        }else {
            DispatchQueue.main.async {
                self.adsMainImage.image = UIImage(named: "addimageArabic")
            }
        }
        
    }
    
    @IBAction func didTapEditMainImageButton(_ sender: UIButton) {
        isMainImage = true
        
        let vc = UIStoryboard(name: ADVS_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier:  PICKUP_MEDIA_POPUP_EDIT_VCID) as! PickupMediaPopupEditAdsVC
        vc.delegate = self
        vc.image = adsMainImage.image ?? UIImage()
//            vc.images = selectedImages
        //vc.videos = selectedVideos
       // vc.selectedMedia = selectedMedia
        present(vc, animated: false)
    }
    
    @IBAction func didTapShowPickedImageViewButton(_ sender: UIButton) {
        isMainImage = false
        if selectedImages.count < 6 {
            let vc = UIStoryboard(name: ADVS_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier:  PICKUP_MEDIA_POPUP_EDIT_VCID) as! PickupMediaPopupEditAdsVC
            vc.delegate = self
//            vc.images = selectedImages
            vc.videos = selectedVideos
            vc.selectedMedia = selectedMedia
            present(vc, animated: false)
        }else{
            StaticFunctions.createErrorAlert(msg: "You have reached the limit of videos and photos".localize)
        }
    }
    
    @IBAction func didTapTajeerButton(_ sender: UIButton) {
        setupTajeerViewUI()
    }
    
    @IBAction func didTapSellButton(_ sender: UIButton) {
        setupSellViewUI()
    }
    
    @IBAction func didTapChatButton(_ sender: UIButton) {
        if (has_chat == "off"){
            setupChatON()
        }else{
            setupChatOFF()
        }
    }
    
    @IBAction func didTapWhatsButton(_ sender: UIButton) {
        if (has_wts == "off"){
            setupWhatsON()
        }else{
            setupWhatsOFF()
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
        
//        var phone = AppDelegate.currentUser.phone ?? ""
        guard var phone = AppDelegate.currentUser.phone else {return}
        if(!sw_my_phone.isOn){
            phone = AppDelegate.currentCountry.code ?? "" + txt_phone.text!
        }
        let errors = "لايوجد"
        guard let price = PriceTxetField.text else {return}
        guard let url = URL(string: Constants.DOMAIN+"prods_update")else{return}
        var params : [String: Any]  = ["id":product.id ?? 0,
                                       "name":titleLabel.text ?? "", "price":price,
                                       "uid":AppDelegate.currentUser.id ?? 0,"cat_id":catId,"sub_cat_id":subCatId,
                                       "country_id":countryId,"city_id":cityId,"region_id":regionId,
                                       "amount":0,
                                      "errors":errors,
                                       "brand_id":"NIKE",
                                       "material_id":"Hareer",
                                       "phone":phone,"wts":phone,"descr":descTextView.text!,
                                       "has_chat":has_chat,"has_wts":has_wts,"has_phone":has_phone,
                                       "tajeer_or_sell":tajeer]
        print(params)
        var type = ""
        var index = ""
        var indexDeletedImage = 0
        var image = Data()
        
        if !mainImageDeleted {
            if isEditImages || editedMainImage {
                saveButton.startAnimation()
                self.view.alpha = 0.5
                AF.upload(multipartFormData: { [weak self] multipartFormData in
                    guard let self = self else {return}
                    print(self.editedMainImage)
                    print(self.selectedMedia.count , self.isEditImages)
                    if self.editedMainImage {
                        if self.mainImageDeleted{
                            multipartFormData.append(Data(), withName: "main_image",fileName: "file.jpg", mimeType: "image/jpg")
                        }else{
                            guard let mainImage = self.mainImage else {return}
                            multipartFormData.append(mainImage, withName: "main_image",fileName: "file.jpg", mimeType: "image/jpg")
                        }
                    }
                    print(self.selectedMedia.count , self.isEditImages)
                    
                    if self.selectedMedia.count > 0 || self.isEditImages{
                        for (value,key) in self.selectedMedia {
                            
                            if value.contains("IMAGE"){
                                type = value.components(separatedBy: " ")[0]
                                index = value.components(separatedBy: " ")[1]
                                //                            type = value
                                image = key
                                print( "VALUE  ",value ,"KEY  " ,key)
                                params["mtype[]"] = type
                                multipartFormData.append(image, withName: "sub_image[]",fileName: "file\(index).jpg", mimeType: "image/jpg")
                            }else{
                                index = "6"
                                type = value
                                image = key
                                params["mtype[]"] = type
                                multipartFormData.append(image, withName: "sub_image[]",fileName: "video\(index).mp4", mimeType: "video/mp4")
                            }
                        }
                    }
                    
                    if self.imagesDeleted.count > 0 {
                        for img in self.imagesDeleted {
                            indexDeletedImage += 1
                            //                          , "delete_img_ids[]":"6235"
                            params["delete_img_ids[\(indexDeletedImage)]"] = img
                            
                        }
                    }
                    
                    
                    for (key,value) in params {
                        multipartFormData.append((value as AnyObject).description.data(using: String.Encoding.utf8)!, withName: key)
                    }
                    
                    print("send Image Parameters : -----> ", params)
                    
                },to:"\(url)")
                .responseDecodable(of:EditAdvSuccessModel.self){ response in
                    print(response)
                    self.view.alpha = 1.0
                    self.saveButton.stopAnimation()
                    switch response.result {
                    case .success(let data):
                        if let message = data.message , let success = data.success{
                            if success {
                                print(message)
                                StaticFunctions.createSuccessAlert(msg:message)
                                self.navigationController?.popViewController(animated: true)
                            }else{
                                StaticFunctions.createErrorAlert(msg: message)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }else{
                
                if imagesDeleted.count > 0 {
                    for img in imagesDeleted {
                        indexDeletedImage += 1
                        //                          , "delete_img_ids[]":"6235"
                        params["delete_img_ids[\(indexDeletedImage)]"] = img
                        
                    }
                }
                print(params)
                AF.request(url, method: .post, parameters: params, encoding:URLEncoding.httpBody).responseDecodable(of:EditAdvSuccessModel.self){ response in
                    print(response)
                    switch response.result {
                    case .success(let data):
                        if let message = data.message , let success = data.success{
                            if success {
                                print(message)
                                StaticFunctions.createSuccessAlert(msg:message)
                                self.navigationController?.popViewController(animated: true)
                            }else{
                                StaticFunctions.createErrorAlert(msg:message)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
                
                
            }
        }else {
            StaticFunctions.createErrorAlert(msg: "Please add main Image for your Ad.".localize)
        }
        
    }
    
    @IBAction func didTapDeleteButton(_ sender: UIButton) {
        deleteButton.startAnimation()
        self.view.alpha = 0.5
        let params : [String: Any]  = ["id":product.id ?? 0]
        guard let url = URL(string: Constants.DOMAIN+"prods_delete")else{return}
        AF.request(url, method: .post, parameters: params, encoding:URLEncoding.httpBody).responseDecodable(of:SuccessModel.self){res in
            self.deleteButton.stopAnimation()
            self.view.alpha = 1.0
            switch res.result{
            case .success(let data):
                if let success = data.success {
                    if success {
                        StaticFunctions.createSuccessAlert(msg:"Ads Deleted Seccessfully".localize)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
//MARK: fileprivate Methods
extension EditAdVC{
    
//    fileprivate  func getData(){
//        ProductController.shared.getProducts(completion: {
//            product, check, msg in
//            
//            if check == 0{
//                self.product = product.data
//                self.productsImages = product.images
//                print(product.images)
//                for i in product.images{
////                    self.images.append(i.image ?? "")
//                    guard let imageURL = URL(string: i.image ?? "" ) else { return }
//                    if i.image?.contains(".mp4") == true {
//                        self.dataSource.append(.image(self.generateThumbnailImage(url: imageURL)))
//                        
//                    }else{
//                        self.dataSource.append(.url(imageURL))
//                    }
//                    
//                }
//                print(self.dataSource)
//                self.setData()
//                
//            }else{
//                StaticFunctions.createErrorAlert(msg: msg)
//                self.navigationController?.popViewController(animated: true)
//            }
//            
//        }, id: productId)
//    }
    fileprivate func getData() {
        ProductController.shared.getProducts(completion: { product, check, msg in
            // Check if the operation was successful
            if check == 0 {
                self.product = product.data
                self.productsImages = product.images
                print(product.images)

                for imageInfo in product.images {
                    // Safely unwrap the image URL
                    if let imageUrlString = imageInfo.pimage, let imageURL = URL(string: Constants.IMAGE_URL+imageUrlString) {
                        print(imageUrlString)
                        // Handle .mp4 files differently
                        if imageUrlString.contains(".mp4") {
                            // Assuming generateThumbnailImage(url:) returns an image or nil
                             let thumbnailImage = self.generateThumbnailImage(url: imageURL)
                                self.dataSource.append(.image(thumbnailImage))
                            
                        } else {
                            self.dataSource.append(.url(imageURL))
                        }
                    } else {
                        print("Invalid URL or nil found in product images.")
                    }
                }
                print(self.dataSource)
                // Call setData() after processing all images
                self.setData()
            } else {
                StaticFunctions.createErrorAlert(msg: msg)
                self.navigationController?.popViewController(animated: true)
            }
        }, id: productId)
    }

    
    fileprivate func setData(){
        self.titleLabel.text = product.name
        self.countryFlagImageView.setImageWithLoading(url: AppDelegate.currentCountry.image ?? "")
        if let phoneNumber = product.phone, phoneNumber.count >= 3 {
            self.countryCodeLabel.text = String(phoneNumber.prefix(3))
        } else {
            // Handle the case where product.phone is nil or has less than 3 characters
            self.countryCodeLabel.text = "N/A"
        }

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
        
        self.has_wts = product.hasWhatsapp ?? ""
        self.has_chat = product.hasChat ?? ""
        self.has_phone = product.hasPhone ?? ""
        
        print(product.hasPhone ?? "")
        print(product.hasChat ?? "")
        print(product.hasWhatsapp ?? "")
        
        configureButtons()
            //contact
//        self.has_phone = product.hasPhone == "on" ? "off":"on"
//        self.has_wts = product.hasWhatsapp == "on" ? "off":"on"
//        self.has_chat = product.hasChat == "on" ? "off":"on"
        
      
        
        
        self.txt_phone.text = removeCountryCode(from: product.phone ?? "")
        
        print(product.type)
        if product.type == 1 {
            
            setupTajeerViewUI()
           // self.sellView.isHidden = true

        }else{
            setupSellViewUI()
           // self.tajeerView.isHidden = true

        }
        
        
        //Main Image
        if let mainImage = product.mainImage {
            if mainImage == "" {
                mainImageFlagView.isHidden = true
            }else{
                mainImageFlagView.isHidden = false
                if mainImage.contains(".mp4")  || mainImage.contains(".mov") {

                    adsMainImage.kf.indicatorType = .activity

                    guard let url = URL(string: Constants.IMAGE_URL + mainImage) else { return }
                    self.adsMainImage.kf.setImage(with: AVAssetImageDataProvider(assetURL: url, seconds: 1))

                }else{
                    adsMainImage.setImageWithLoading(url: mainImage )
         
                }
            }
            
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func configureButtons() {
        // Check if hasWhatsapp ,hasPhone,hasChat is "on" and set the UI state accordingly
        if product.hasWhatsapp ?? "" == "on" {
            setupWhatsON()
        } else {
            setupWhatsOFF()
        }
        if product.hasPhone ?? "" == "on" {
            setupHasPhoneViewUI()
        } else {
            setupNotHasPhoneViewUI()
        }
        if product.hasChat ?? "" == "on" {
          setupChatON()
        } else {
           setupChatOFF()
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
        sellView.isHidden = true
        tajeer = 1
        sellView.borderWidth = 0.7
        tajeerView.borderWidth = 1.2
        sellButtonImage.borderWidth = 0.7
        sellButtonImage.borderColor = .white
        tajeerView.backgroundColor = UIColor(named: "#0093F5")
        sellView.backgroundColor = .white
    sellView.borderColor = .gray
        tajeerView.borderColor = .white
        sellButtonImage.isHidden = true
        tajeerButtonImage.isHidden = false
    StaticFunctions.setImageFromAssets(tajeerButtonImage, "checkbox")
    StaticFunctions.setTextColor(sellLabel, UIColor.black)
    StaticFunctions.setTextColor(tajeerLabel, UIColor.white)
        
    }
    
    fileprivate func setupSellViewUI() {
        tajeerView.isHidden = true
        tajeer = 0
        sellView.borderWidth = 1.2
        tajeerView.borderWidth = 0.7
        tajeerButtonImage.borderWidth = 0.7
        tajeerButtonImage.borderColor = .white
        sellView.backgroundColor = UIColor(named: "#0093F5")
        tajeerView.backgroundColor = .white
        sellView.borderColor = .white
        tajeerView.borderColor = .gray
        StaticFunctions.setImageFromAssets(sellButtonImage, "checkbox")
        sellButtonImage.isHidden = false
        tajeerButtonImage.isHidden = true
        StaticFunctions.setTextColor(sellLabel, UIColor.white)
        StaticFunctions.setTextColor(tajeerLabel, UIColor.black)
    }
    
    fileprivate func setupHasPhoneViewUI(){
        has_phone = "on"
        has_phonev.backgroundColor = UIColor(named: "#0093F5")
        StaticFunctions.setTextColor(has_phone_txt,UIColor.white)
        StaticFunctions.setImageFromAssets(has_phone_img, "checkbox")
    }
    fileprivate func setupNotHasPhoneViewUI() {
        has_phone = "off"
        has_phonev.borderWidth = 1.2
        StaticFunctions.setTextColor(has_phone_txt, UIColor.black)
        StaticFunctions.setImageFromAssets(has_phone_img, "")
    }
    
    private func setupChatON(){
        has_chat = "on"
       
        has_chatv.backgroundColor = UIColor(named: "#0093F5")
        StaticFunctions.setTextColor(has_chat_txt, UIColor.white)
        StaticFunctions.setImageFromAssets(has_chat_img, "checkbox")
    }
    private func setupChatOFF(){
        has_chat = "off"
        has_chatv.borderWidth = 1.2
     
        StaticFunctions.setTextColor(has_chat_txt, UIColor.black)
        StaticFunctions.setImageFromAssets(has_chat_img, "")
    }
    fileprivate func setupWhatsON() {
        has_wts = "on"
      
        has_wtsv.backgroundColor = UIColor(named: "#0093F5")
        StaticFunctions.setTextColor(has_wts_txt, UIColor.white)
        StaticFunctions.setImageFromAssets(has_wts_img, "checkbox")
    }
    
    fileprivate func setupWhatsOFF() {
        has_wts = "off"
      
        has_wtsv.backgroundColor = .white
        StaticFunctions.setTextColor(has_wts_txt, UIColor.black)
        StaticFunctions.setImageFromAssets(has_wts_img, "")
    }
}
extension EditAdVC : UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvsImagesCollectionViewCell", for: indexPath) as? AdvsImagesCollectionViewCell else {return UICollectionViewCell()}
//        if let url = URL(string:  self.dataSource[indexPath.item]) {
//            cell.imageView.sd_setImage(with:url , placeholderImage: nil)
//        }
        let data = dataSource[indexPath.item]
            
            switch data {
            case .url(let url):
                // Load image from URL and set it in the cell
                cell.imageView.sd_setImage(with:url , placeholderImage: nil)
            case .image(let image):
                // Set the gallery image in the cell
                cell.imageView.image = image
            }
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
}

extension EditAdVC: AdvsImagesCollectionViewCellDelegate {
    func didSelectCell(indexPath: IndexPath) {
        //code
    }
    
    func didRemoveCell(indexPath: IndexPath) {        self.imagesDeleted.append(self.productsImages[indexPath.item].id ?? 0)
        productsImages.remove(at: indexPath.item)
        self.dataSource.remove(at: indexPath.item)
        print(imagesDeleted)
        self.collectionView.reloadData()
    }
    
    
}

extension EditAdVC :UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txt_phone{
            let maxLength = countPhoneNumber
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.count <= maxLength
        }
        return true
    }
}
