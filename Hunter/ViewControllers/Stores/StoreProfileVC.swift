//
//  StoreProfileVC.swift
//  Bazar
//
//  Created by iOSayed on 31/08/2023.
//

import UIKit
import MOLH
import Alamofire
import TransitionButton
import FirebaseDynamicLinks
import FirebaseAuth



class StoreProfileVC: UIViewController {
    
    
    static func instantiate()-> StoreProfileVC{
        let editStoreVC = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier: "StoreProfileVC") as! StoreProfileVC
        
        return editStoreVC
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var changeCoverButton: UIButton!
    @IBOutlet weak var changeProfileImageButton: UIButton!
    @IBOutlet weak var storeProfileimageContaineView: UIView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var StoreLocationLabel: UILabel!
    @IBOutlet weak var storeCoverImageView: UIImageView!
    @IBOutlet weak var storeProfileImageView: UIImageView!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    @IBOutlet weak var storeBioLabel: UILabel!
    @IBOutlet weak var planTypeLabel: UILabel!
    @IBOutlet weak var countOfPaidAdsLabel: UILabel!
    @IBOutlet weak var storeAdsCountLabel: UILabel!
    @IBOutlet weak var storeRatingCountLabel: UILabel!
    @IBOutlet weak var storeFollowersCountLabel: UILabel!
    @IBOutlet weak var storeFollowingsCountLabel: UILabel!
    
    @IBOutlet weak var packesTypeStackView: UIStackView!
    @IBOutlet weak var storesPackagesButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var chatButton: TransitionButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var blockImage: UIImageView!
    @IBOutlet weak var flagImag: UIImageView!
    // MARK: - Proprerties
    var otherUserId = AppDelegate.currentUser.id ?? 0
    var countryId = AppDelegate.currentUser.countryId
    private var products = [Product]()
    private var page = 1
    private var isTheLast = false
    private var EditProfileParams = [String:Any]()
    private var imageType = 0 //profileImage
    private var isUpdateCover = false
    private var userModel = User()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        changeCoverButton.isHidden = true
        changeProfileImageButton.isHidden = true
        storesPackagesButton.isHidden = true
        blockButton.isHidden = true
        reportButton.isHidden = true
        flagImag.isHidden = true
        blockImage.isHidden = true
        packesTypeStackView.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        getProfile()
    
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        configureView()
        getProductsByUser()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
    }
    
    // MARK: - Methods
    private func configureView(){
        navigationController?.navigationBar.isHidden = true
        blockButton.isHidden = true
        reportButton.isHidden = true
        storeProfileimageContaineView.layer.cornerRadius = storeProfileimageContaineView.frame.height / 2
        reportButton.layer.cornerRadius = reportButton.frame.height/2
        blockButton.layer.cornerRadius = blockButton.frame.height/2
    }
    // MARK: - IBActions

    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func didTapChangeCoverImageButton(_ sender: UIButton) {
        isUpdateCover = true
        imageType = 1 //Cover image
        displayImageActionSheet()
        
    }
    @IBAction func didTapChangeProfileImageButton(_ sender: UIButton) {
        isUpdateCover = false
        imageType = 0 // profile image
        displayImageActionSheet()
    }
    
    //SocialMedia Buttons
    
    @IBAction func didTapPhoneButton(_ sender: UIButton) {
        self.makePhoneCall(phone: userModel.phone ?? "")
    }
    
    @IBAction func didTapWhatsAppButton(_ sender: UIButton) {
        self.openWhatsApp(number: userModel.store?.whatsapp ?? "" , message: "hello I'm Contct with you from Bazar App".localize)
    }
    
    @IBAction func didTapWebSiteButton(_ sender: UIButton) {
        
        self.openURL(userModel.store?.website ?? "")
    }
    @IBAction func didTapInstgramButton(_ sender: UIButton) {
        self.openURL(userModel.store?.instagram ?? "")
    }
    @IBAction func didTapLocationButton(_ sender: UIButton) {
//        self.openURL(userModel. ?? "")
    }
    @IBAction func didTapTwitterButton(_ sender: UIButton) {
        self.openURL(userModel.store?.twitter ?? "")
    }
    @IBAction func didTapFollowingsButton(_ sender: UIButton) {
        let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "FollowersAndFollowingsVC") as! FollowersAndFollowingsVC
        Constants.followOtherUserId = AppDelegate.currentUser.id ?? 0
        Constants.followIndex = 0
        vc.userId = userModel.id.safeValue
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapFollowersButton(_ sender: UIButton) {
        let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "FollowersAndFollowingsVC") as! FollowersAndFollowingsVC
        Constants.followOtherUserId = AppDelegate.currentUser.id ?? 0
        Constants.followIndex = 0
        vc.userId = userModel.id.safeValue
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapMyAdsButtons(_ sender: UIButton) {
        print("nothing")
    }
    @IBAction func didTapStoresPackagesButton(_ sender: UIButton) {
        let packagesVC = PackagesVC.instantiate()
        navigationController?.pushViewController(packagesVC, animated: true)
        
    }
    
    @IBAction func didTapEditProfileButton(_ sender: UIButton) {
        if AppDelegate.currentUser.id ?? 0 == otherUserId  {
            let editStore = EditStoreVC.instantiate()
            navigationController?.pushViewController(editStore, animated: true)
        }else {
            if StaticFunctions.isLogin() {
                ProfileController.shared.followUser(completion: { check, message in
                    if check == 0 {
                        self.getProfile()
                    }else {
                        StaticFunctions.createErrorAlert(msg: message)
                    }
                }, OtherUserId: otherUserId)
            }else{
                StaticFunctions.createErrorAlert(msg: "Please Login First".localize)
            }
           
        }
    }
    @IBAction func didTapMyChatButton(_ sender: UIButton) {

        if AppDelegate.currentUser.id ?? 0 != otherUserId {
            self.chatButton.startAnimation()
            let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            Constants.userOtherId = "\(otherUserId)"
            print(otherUserId)
            vc.modalPresentationStyle = .fullScreen
            
            createRoom("\(otherUserId)"){[weak self] success in
                self?.chatButton.stopAnimation()
                guard let self = self else {return}
                if success {
                    //                self.present(vc, animated: true)
                    vc.navigationController?.navigationBar.isHidden = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.chatButton.stopAnimation()
                    StaticFunctions.createErrorAlert(msg: "Can't Create Room".localize)
                }
            }
        }else{
            //go to msgsC
            let messagesVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "msgsv") as! msgsC
            messagesVC.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(messagesVC, animated: true)
            
        }
        
        
    }
    
    @IBAction func didTapNotificationButton(_ sender: Any) {
        
            let notificationsVC = UIStoryboard(name: "Notifications", bundle: nil).instantiateViewController(withIdentifier: "notifications") as! NotificationsViewController
            notificationsVC.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(notificationsVC, animated: true)
        
    }
    @IBAction func didTapShareButton(_ sender: UIButton) {
//        shareContent(text: "bazaar://profile/\(AppDelegate.currentUser.id ?? 0)")
        shareStoreProfile()
    }
    @IBAction func didTapReportButton(_ sender: UIButton) {
        let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "ReportAboutUserVC") as! ReportAboutUserVC
        vc.uid = "\(otherUserId)"
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
    
    @IBAction func didTapBlockButton(_ sender: UIButton) {
        let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "BlockUserVC") as! BlockUserVC
        vc.otherUserId = otherUserId
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
    
    
    private func shareStoreProfile(){
        guard let link = URL(string: "https://www.bazar-kw.com/stores/?profile_id=" + "\(userModel.id ?? 0)") else { return }
                let dynamicLinksDomainURIPrefix = "https://bazaaarstoreprofile.page.link"
                guard let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix) else { return }
                        linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.bazaaar.app")
        // Set social meta tag parameters
        let socialTags = DynamicLinkSocialMetaTagParameters()
        if ((userModel.cover.safeValue.contains("image"))){
            socialTags.imageURL = URL(string: Constants.MAIN_DOMAIN+(userModel.cover.safeValue))

        }else{
            socialTags.imageURL = URL(string: Constants.IMAGE_URL+(userModel.cover.safeValue))
        }
        socialTags.title = userModel.name.safeValue
        socialTags.descriptionText = userModel.bio.safeValue
        linkBuilder.socialMetaTagParameters = socialTags
        
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://www.bazar-kw.com/stores/?profile_id=" + "\(userModel.id ?? 0)")
        actionCodeSettings.dynamicLinkDomain = "https://bazaaarstoreprofile.page.link"
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
                
                guard let longDynamicLink = linkBuilder.url else { return }
                print(longDynamicLink)
                linkBuilder.shorten() { url, warnings, error in
                    guard let url = url, error == nil else {
                        
                        return }
                    print("The short URL is: \(url)")
                    let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                   
                    self.present(activityViewController, animated: true, completion: nil)
                }
    }
    
}

extension StoreProfileVC:UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreProductCell", for: indexPath) as? ProductCollectionViewCell else {return UICollectionViewCell()}
        productCell.setData(product: products[indexPath.item])
        return productCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.width/2) - 10, height: 280)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == (products.count-1) && !isTheLast{
//            page+=1
//            getProductsByUser()
            
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PRODUCT_VCID) as! ProductViewController
        vc.modalPresentationStyle = .fullScreen
        vc.product = products[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
    extension StoreProfileVC {
        
        private func getProfile(){
            ProfileController.shared.getOtherProfile(completion: {[weak self] userProfile, msg in
                guard let self = self else {return}
                if let userProfile = userProfile {
                    print("======= profile Data ======== ")
                    print(userProfile)
                    self.bindProfileData(from: userProfile)
                    self.userModel = userProfile
                   // self.getProductsByUser()
                }
            }, userId: otherUserId)
        }
        
        private func bindProfileData(from profileModel:User){
//            if let cover =  profileModel.store?.coverPhoto {
//                if cover.contains(".png") || cover.contains(".jpg"){
////                    storeCoverImageView.setImageWithLoading(url:profileModel.cover ?? "" )
//                    print(cover)
//                    storeCoverImageView.setImageWithLoading(url:cover,placeholder: "coverBG" )
//                }
//            }else{
//                
//                if let cover =  profileModel.cover {
//                    if cover.contains(".png") || cover.contains(".jpg"){
//    //                    storeCoverImageView.setImageWithLoading(url:profileModel.cover ?? "" )
//                        print(cover)
//                        storeCoverImageView.setImageWithLoading(url:cover ,placeholder: "coverBG" )
//                    }
//                }
//            }
            if profileModel.cover.safeValue.contains("image"){
                storeCoverImageView.setImageWithLoadingFromMainDomain(url:profileModel.cover ?? profileModel.store?.coverPhoto  ?? "" ,placeholder: "cover" )

            }else {
                storeCoverImageView.setImageWithLoading(url:profileModel.cover ?? profileModel.store?.coverPhoto  ?? "" ,placeholder: "cover" )

            }

            if let userPic =  profileModel.store?.logo {
                Constants.otherUserPic = userPic
                Constants.otherUserIsStore = profileModel.isStore ?? false
                
                if userPic.contains(".png") || userPic.contains(".jpg"){
                    print(userPic)
                    storeProfileImageView.setImageWithLoading(url:userPic)
                }
            }else{
                if let userPic =  profileModel.pic {
                    Constants.otherUserPic = userPic
                    Constants.otherUserIsStore = profileModel.isStore ?? false
                    if userPic.contains(".png") || userPic.contains(".jpg"){
                        print(userPic)
                        storeProfileImageView.setImageWithLoading(url:userPic)
                    }
                }
            }
            
            
            
            
            Constants.otherUserName = profileModel.name ?? ""
            print(profileModel.name ?? "")
            storeNameLabel.text = profileModel.store?.companyName ?? ""
            storeAdsCountLabel.text = "\(profileModel.numberOfProds ?? 0)"
            storeFollowersCountLabel.text = "\(profileModel.followers ?? 0)"
            storeFollowingsCountLabel.text = "\(profileModel.following ?? 0)"
            storeRatingCountLabel.text = "\(profileModel.userRate ?? 0)"
            storeBioLabel.text = profileModel.store?.bio ?? ""
            let planType:String = {
                if MOLHLanguage.currentAppleLanguage() == "en"{
                    return   "\(profileModel.plan?.nameEn ?? "")"
                }else{
                    return  "\(profileModel.plan?.nameAr ?? "")"
                }
            }()
            planTypeLabel.text = planType
            countOfPaidAdsLabel.text = String(describing:profileModel.availableAdsCountStoreInCurrentMonth ?? 0)
            let location:String = {
                if MOLHLanguage.currentAppleLanguage() == "en"{
                 return   "\(profileModel.countriesNameEn ?? "")"
                }else{
                  return  "\(profileModel.countriesNameAr ?? "")"
                }
            }()
            
            
            StoreLocationLabel.text = location
            EditProfileParams =
            [
                "id":profileModel.id ?? 0,
                "mobile":profileModel.phone ?? "",
                "country_id":profileModel.countryId ?? 6
            ]
            
            
            
            
            
            
            if AppDelegate.currentUser.id ?? 0 == profileModel.id ?? 0 {
                blockButton.isHidden = true
                reportButton.isHidden = true
                flagImag.isHidden = true
                blockImage.isHidden = true
                packesTypeStackView.isHidden = false
                storesPackagesButton.isHidden = false
                changeProfileImageButton.isHidden = false
                changeCoverButton.isHidden = false
                chatButton.isHidden = false
                editProfileButton.isHidden = false

            }else {
               
                notificationButton.isHidden = true
                notificationImage.isHidden = true
                editProfileButton.setTitle("Follow".localize, for: .normal)
                chatButton.setTitle("Chat".localize, for: .normal)
                changeCoverButton.isHidden = true
                changeProfileImageButton.isHidden = true
                storesPackagesButton.isHidden = true
                blockButton.isHidden = false
                reportButton.isHidden = false
                flagImag.isHidden = false
                blockImage.isHidden = false
                packesTypeStackView.isHidden = true
                chatButton.isHidden = false
                editProfileButton.isHidden = false
            }
            
            if AppDelegate.currentUser.id ?? 0 != otherUserId  {
                if profileModel.isFollow ?? 0 == 1 {
                    editProfileButton.setTitle("unfollow".localize, for: .normal)
                }else{
                    editProfileButton.setTitle("Follow".localize, for: .normal)
                }
            }
           
            
        }
        
        private func updateCollectionViewHeight() {
                let totalItems = collectionView.numberOfItems(inSection: 0)
                let numberOfRows = ceil(CGFloat(totalItems) / 2) // Adjust as per your layout
                let totalRowHeight = numberOfRows * 280 // rowHeight is height of each item
                let totalSpacingHeight = (numberOfRows - 1) * 10 // Adjust as per your layout

                let totalHeight = totalRowHeight + totalSpacingHeight
            collectionViewheightConstraint.constant = totalHeight

                view.layoutIfNeeded()
            }
        
        private func reloadData() {
                collectionView.reloadData()
                updateCollectionViewHeight()
            }
        
        private func getProductsByUser(){
//             guard let countryId = AppDelegate.currentUser.countryId else{return}
             
            ProfileController.shared.getProductsByUser(completion: { [weak self]
                 products, check, msg in
                guard let self else {return}
                 print(products.count)
                 if check == 0{
                     
                     if self.page == 1 {
                         self.products.removeAll()
                         self.products = products
                         
                     }else{
                         self.products.append(contentsOf: products)
                         
                     }
                     if products.isEmpty{
                         self.page = self.page == 1 ? 1 : self.page - 1
                         self.isTheLast = true
                     }
                     print("Count of products: \(products.count)")
                           print("Message: \(msg)")
                     DispatchQueue.main.async {
                         print(products.count)
//                         self.collectionViewheightConstraint.constant = CGFloat(products.count / 2 * 295)
//                         self.collectionView.isHidden = false
//                         self.collectionView.reloadData()
                         self.reloadData()
                     }
                     
                 }else{
                     StaticFunctions.createErrorAlert(msg: msg)
                     self.page = self.page == 1 ? 1 : self.page - 1
                 }
                 
                 //use 128 as user id to check
             }, userId: otherUserId , page: page, countryId:countryId ?? 0, status: "published")
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
            selectAction.setValue(UIColor(named: "#0093F5"), forKey: "titleTextColor")
            alertController.addAction(selectAction)
            alertController.addAction(deletAction)
            let cancelAction = UIAlertAction(title: "Cancel".localize, style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
            let imageView = UIImageView(image: UIImage(named: "imageadd")?.withRenderingMode(.alwaysTemplate))
                    imageView.contentMode = .scaleAspectFit
                    imageView.clipsToBounds = true
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
        
        
        private func openGallery() {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
        
        
        private func changeProfileImage(image:UIImage){
            APIConnection.apiConnection.uploadImageConnectionForStore(completion: { success, message in
                if success {
                    StaticFunctions.createSuccessAlert(msg: message)
                }else {
                    StaticFunctions.createErrorAlert(msg: message)
                }
                
            }, link: Constants.EDIT_STORE_URL + "\(AppDelegate.currentUser.store?.id ?? 0)", param: [:], image: image, imageType: .profileImage)
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
    }


extension StoreProfileVC {
    
    
    func confirmRemoveCover() {
        DispatchQueue.main.async( execute: {
//            let attributedtitle = NSAttributedString(string: "", attributes: [
////                NSAttributedString.Key.font : UIFont(name: "Almarai-Regular", size: 13.0)!
//            ])
            
//            let attributedmessage = NSAttributedString(string:"", attributes: [
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
                        self.changeProfileImage(image: image)
                        self.getProfile()
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
                    self.getProfile()
                case.failure(let error):
                    print(error)
                }
                
            }
    }
    
    func createRoom(_ recieverId:String, completion:@escaping (Bool)->()){
        let params : [String: Any]  = ["rid":recieverId]
        print(params , "Headers  \(Constants.headerProd)" )
        guard let url = URL(string: Constants.DOMAIN+"create_room")else{return}
        AF.request(url, method: .post, parameters: params, headers: Constants.headerProd).responseDecodable(of:RoomSuccessModel.self) { res in
            print(res)
            switch res.result {
                
            case .success(let data):
                if let receiverId = data.data?.id {
                   
                    print(data)
                    receiver.room_id = "\(receiverId)"
                    print(receiver.room_id)
                    completion(true)
                    
                }
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
        
    }
}

extension StoreProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let capturedImage = info[.originalImage] as? UIImage {
            print("Captured image: \(capturedImage)")
           // self.images.append(capturedImage as UIImage)
            
            
            if imageType == 0 {
                //profile image
                storeProfileImageView.image = capturedImage
                changeProfileImage(image: capturedImage)
            }else{
                // cover image
                storeCoverImageView.image = capturedImage
                changeCoverImage(image: capturedImage)
            }
           
        }
    }
        
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
