//
//  StoresVC.swift
//  Bazar
//
//  Created by iOSayed on 24/08/2023.
//

import UIKit
import FSPagerView
import MOLH
import WoofTabBarController

protocol StoresVCDelegate:AnyObject{
    func didChangeCounty()
}

enum SliderType {
    case normalSlider(NormalSlider)
    case prods(SliderObject)
}

class StoresVC: UIViewController {
    static func instantiate()->StoresVC{
        let controller = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier:"StoresVC" ) as! StoresVC
        return controller
    }
    
    @IBOutlet weak var storesCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var customNavView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var createStoreView: UIView!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }

    weak var delegate:StoresVCDelegate?
    let titleLabel = UILabel()
    var coountryVC = CounriesViewController()
    var countryName = MOLHLanguage.currentAppleLanguage() == "en" ? AppDelegate.currentCountry.nameEn : AppDelegate.currentCountry.nameAr
    var countryId = AppDelegate.currentCountry.id ?? 6
    var cityId = -1
    var storesList = [StoreObject]()
    
    //MARK: Sliders Variables
    var unifiedSliderData = [UnifiedSliderData]()
    
    var sliderProdsList = [SliderObject]()
    var normalSliderList = [NormalSlider]()
    let badgeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 15, height: 15))

    //MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        CollectionView.isScrollEnabled = false
        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(changeCountryName(_:)), name: NSNotification.Name("changeCountryName"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(countryDidChange), name: .countryDidChange, object: nil)

        searchTextField.delegate = self
        pagerView.delegate = self
        pagerView.dataSource = self
        getStores()
        getSliders()
        configureNavButtons()
        customNavView.cornerRadius = 30
        customNavView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        createChangeCountryButton()
            searchTextField.setPlaceHolderColor(.white)
        badgeLabel.isHidden = true
        if AppDelegate.currentUser.isStore ?? false {
            createStoreView.isHidden = true
        }else{
            createStoreView.isHidden = false
        }
    }
    
    private func configureNavButtons(){
        // Create images
            let image1 = UIImage(named: "chatIcon 1")
            let image2 = UIImage(named: "notificationn 1")
        
        let chatButton = UIButton(type: .custom)
        chatButton.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
        chatButton.setImage(UIImage(named:"chatIcon 1"), for: .normal)
        chatButton.addTarget(self, action: #selector(didTapChatButton), for: UIControl.Event.touchUpInside)

           let chatBarItem = UIBarButtonItem(customView: chatButton)
        
        let notificationButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        notificationButton.setImage(image2, for: .normal)
        notificationButton.addTarget(self, action: #selector(didTapNotificationButton), for: .touchUpInside)

        self.badgeLabel.backgroundColor = .red
        self.badgeLabel.clipsToBounds = true
        self.badgeLabel.layer.cornerRadius = badgeLabel.frame.height / 2
        self.badgeLabel.textColor = UIColor.white
        self.badgeLabel.font = UIFont.systemFont(ofSize: 12)
        self.badgeLabel.textAlignment = .center

        notificationButton.addSubview(self.badgeLabel)

//        self.navigationItem.rightBarButtonItems = []
            // Add buttons to the right side of the navigation bar
            navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: notificationButton),chatBarItem]
    }
   
    // Update the badge count
    func updateBadgeCount(_ count: Int) {
        if count > 0 {
            badgeLabel.text = "\(count)"
            badgeLabel.isHidden = false
        } else {
            badgeLabel.isHidden = true
        }
    }
    @objc private func didTapChatButton() {
        // Handle chat  tap
        print("Chat")
        let messagesVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "msgsv") as! msgsC
        messagesVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(messagesVC, animated: true)
    }
    @objc private func didTapNotificationButton() {
        // Handle notification  tap
        print("Notifications")
        let notificationsVC = UIStoryboard(name: "Notifications", bundle: nil).instantiateViewController(withIdentifier: "notifications") as! NotificationsViewController
        notificationsVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(notificationsVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        getnotifictionCounts()
        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
    }
    
    
    func createChangeCountryButton(){
        //MARK: Right Button
        
         let rightView = UIView()
        rightView.backgroundColor = .clear
        rightView.frame = CGRect(x: 0, y: 0, width: 130, height: 30) // Increase the width

        let cornerRadius: CGFloat = 16.0
        rightView.layer.cornerRadius = cornerRadius // Apply corner radius

        let dropDownImage = UIImageView(image: UIImage(named: "dropDownIcon")?.withRenderingMode(.alwaysTemplate))
        dropDownImage.tintColor = .white
        dropDownImage.contentMode = .scaleAspectFill
        dropDownImage.frame = CGRect(x: 10 , y: 10, width: 14, height: 10) // Adjust the position and size of the image

        rightView.addSubview(dropDownImage)

        let locationImage = UIImageView(image: UIImage(named: "locationBlack")?.withRenderingMode(.alwaysTemplate))
        locationImage.tintColor = .white
        locationImage.contentMode = .scaleAspectFill
        locationImage.frame = CGRect(x: rightView.frame.width - 25, y: 10, width: 14, height: 10) // Adjust the position and size of the image

        rightView.addSubview(locationImage)
        
        titleLabel.text = countryName // Assuming you have a "localized" method for localization
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        rightView.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 20, y: 0, width: rightView.frame.width - 40, height: rightView.frame.height) // Adjust the position and width of the label
        
        let categoryButton = UIButton(type: .custom)
        categoryButton.frame = rightView.bounds
        categoryButton.addTarget(self, action: #selector(didTapChangeCountryButton), for: .touchUpInside)

        rightView.addSubview(categoryButton)

        let countryButton = UIBarButtonItem(customView: rightView)
//        navigationItem.rightBarButtonItems = []
        navigationItem.leftBarButtonItems = [countryButton]
    }
    @objc func countryDidChange(notification: Notification) {
        if let country = notification.userInfo?["country"] as? Country {
            AppDelegate.currentCountry = country
            self.countryName = MOLHLanguage.currentAppleLanguage() == "en" ? (country.nameEn ?? "") : (country.nameAr ?? "")
//            self.rightButton.setTitle(self.countryName, for: .normal)
            self.titleLabel.text = self.countryName
            self.countryId = country.id ?? 6
            self.getStores()
            self.cityId = -1
        }
    }
    @objc func didTapChangeCountryButton(){
        coountryVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COUNTRY_VCIID) as!  CounriesViewController
        coountryVC.countryBtclosure = { [weak self]
            (country) in
            guard let self else {return}
//            AppSettings.shared.currentCountry = country // Set this when the country changes
            AppDelegate.currentCountry = country
            self.countryName = MOLHLanguage.currentAppleLanguage() == "en" ? (country.nameEn ?? "") : (country.nameAr ?? "")
//            self.rightButton.setTitle(self.countryName, for: .normal)
            self.titleLabel.text = self.countryName
            self.countryId = country.id ?? 6
            self.getStores()
            self.cityId = -1
//            self.resetProducts()
//            self.getData()
        }
        self.present(coountryVC, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func changeCountryName(_ notification:Notification){
        titleLabel.text = MOLHLanguage.currentAppleLanguage() == "en" ? AppDelegate.currentCountry.nameEn : AppDelegate.currentCountry.nameAr
    }
    //MARK: IBActions
    
    @IBAction func didTapCreateStoreButton(_ sender: UIButton) {
        let addStoreVC = CreateStoreVC.instantiate()
        navigationController?.pushViewController(addStoreVC, animated: true)
        
    }
    
}

//MARK: UICollectionView DataSource
extension StoresVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         return storesList.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCollectionViewCell", for: indexPath) as? StoreCollectionViewCell else {return UICollectionViewCell()}
         cell.setData(store: storesList[indexPath.item])
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/2)-10, height: 175)
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let storeProfile = StoreProfileVC.instantiate()
         storeProfile.otherUserId = storesList[indexPath.item].userID ?? 0
         storeProfile.countryId = storesList[indexPath.item].countryID ?? 6
         navigationController?.pushViewController(storeProfile, animated: true)
    }
    
}

//extension StoresVC:FSPagerViewDelegate , FSPagerViewDataSource {
//    func numberOfItems(in pagerView: FSPagerView) -> Int {
//        return sliderList.count == 0 ? 3 : sliderList.count
//    }
//
//    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
//        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
//            cell.imageView?.setImageWithLoading(url: sliderList[index].img ?? "")
//            return cell
//    }
//
//    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        if sliderList.count == 0 {
//            openURL("https://bazar-kw.com")
//        }else {
//            let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PRODUCT_VCID) as! ProductViewController
//            vc.modalPresentationStyle = .fullScreen
//            vc.product.id  = sliderList[index].id ?? 0
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        
//    }
//
//}
extension StoresVC: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return unifiedSliderData.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let slider = unifiedSliderData[index]
        switch slider.type{
            
        case .normalSlider(_):
                cell.imageView?.setImageWithLoadingFromMainDomain(url: slider.imageUrl.safeValue)
        case .prods(_):
            if slider.imageUrl.safeValue.contains("/image"){
                cell.imageView?.setImageWithLoadingFromMainDomain(url: slider.imageUrl.safeValue)
            }else{
                cell.imageView?.setImageWithLoading(url: slider.imageUrl.safeValue)
            }
        }
        return cell
    }
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let selectedSlider = unifiedSliderData[index]

        switch selectedSlider.type {
        case .prods(let prod):
            let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PRODUCT_VCID) as! ProductViewController
            vc.modalPresentationStyle = .fullScreen
            vc.product.id = prod.id
            self.navigationController?.pushViewController(vc, animated: true)

        case .normalSlider(let normalSlider):
            if let url = normalSlider.link, let urlObj = URL(string: url) {
                UIApplication.shared.open(urlObj)
            }
        }
    }

}

extension StoresVC {
    func getStores(){
        print(countryId)
        ProductController.shared.getStores(completion: { stores, check, message in
            if check == 0{
                print(stores.count)
                DispatchQueue.main.async {
                    if stores.count < 4 {
                        self.storesCollectionViewHeightConstraint.constant = 350
                    }else {
                        self.storesCollectionViewHeightConstraint.constant = (CGFloat(Double(stores.count)) * 200)
                    }
                    self.storesList.removeAll()
                    self.storesList.append(contentsOf: stores)
                    self.CollectionView.reloadData()
                }
              
            }else{
                StaticFunctions.createErrorAlert(msg: message)
            }
        }, countryId: countryId)
    }
    
    
    func getSliders() {
        StoresController.shared.getSliders(completion: {[weak self] sliders, check, message in
            guard let self = self else { return }
            if check == 0 {
                if let prods = sliders?.prods, let normalSliders = sliders?.normalSliders {
                    self.prepareSlidersData(from: prods, and: normalSliders)
                    self.pagerView.reloadData()
                }
            } else {
                StaticFunctions.createErrorAlert(msg: message)
            }
        }, countryId: countryId)
    }
    
    private func prepareSlidersData(from prods:[SliderObject], and normalSliders:[NormalSlider]){
        
        unifiedSliderData = normalSliders.map({ slider in
            return UnifiedSliderData(type: .normalSlider(slider), imageUrl: slider.image, link: slider.link, id: slider.id.safeValue)
        }) + prods.map({ prod in
            return UnifiedSliderData(type: .prods(prod), imageUrl: prod.img ?? prod.prodsImage.safeValue, link: nil, id: prod.id.safeValue)
        })
        
    }
    
    private func getnotifictionCounts(){
        NotificationsController.shared.getNotificationsCount(completion: {
            count, check, msg in
            
            if check == 1{
                StaticFunctions.createErrorAlert(msg: msg)
            }else{
                self.updateBadgeCount(count?.data?.count ?? 0)
            }
        })
    }
}
extension StoresVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Perform the segue when the Return key is pressed
        let vc = UIStoryboard(name: SEARCH_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "search") as! SearchViewController
        if searchTextField.text.safeValue != "" {
            vc.searchText = searchTextField.text!
            navigationController?.pushViewController(vc, animated: true)
        }else{
            StaticFunctions.createErrorAlert(msg: "Please type in anything you want to search for in Bazar".localize)
        }
       
            return true
        }
}
//extension StoresVC:WoofTabBarControllerDataSource, WoofTabBarControllerDelegate {
//    
//    func woofTabBarItem() -> WoofTabBarItem {
//        return WoofTabBarItem(title: "Commercial".localize, image: "storeIconGray", selectedImage: "storeButtonIcon")
//    }
//}
