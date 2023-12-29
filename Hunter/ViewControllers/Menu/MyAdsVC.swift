//
//  MyAdsVC.swift
//  Bazar
//
//  Created by iOSayed on 24/05/2023.
//

import UIKit
import Alamofire

enum AdsStatus{
    case published
    case pending
    case finished
}

class MyAdsVC: UIViewController {

    @IBOutlet private weak var myAdsCollectionView: UICollectionView!
    
    
    @IBOutlet private weak var featuredPendingView: UIView!
    @IBOutlet private weak var featuredPendingLbl: UILabel!
    @IBOutlet private weak var pendingView: UIView!
    @IBOutlet private weak var pendingLbl: UILabel!
    @IBOutlet private weak var activatedView: UIView!
    @IBOutlet private weak var activatedLbl: UILabel!
    
    @IBOutlet weak var noAdsStackView: UIStackView!
    private  let cellIdentifier = "MyAdsCollectionViewCell"
    private var products = [Product]()
    private var productId = 0
    private var page = 1
    private var isTheLast = false
            var userId = 0
    private var invoiceURL = ""
    private var isRepostProduct = false
    private var adStatus:AdsStatus = .published
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        ConfigureUIView()
        noAdsStackView.isHidden = true
        getProductsByUser(with: "published")
        print(userId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back", style: .plain, target: nil, action: nil)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func didTapBackButton(_ sender:UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Private Methods
    
    private func ConfigureUIView(){
        navigationController?.navigationBar.tintColor = .white
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        myAdsCollectionView.delegate = self
        myAdsCollectionView.dataSource = self
        myAdsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    
    
    
    @IBAction func didTapActivatedBtnAction(_ sender: Any) {
        adStatus = .published
        getProductsByUser(with: "published")
        activatedLbl.textColor = UIColor(named: "#0093F5")
        activatedView.backgroundColor = UIColor(named: "#0093F5")
        
        pendingLbl.textColor = UIColor(named: "#929292")
        pendingView.backgroundColor = UIColor(named: "#929292")
        
        featuredPendingLbl.textColor = UIColor(named: "#929292")
        featuredPendingView.backgroundColor = UIColor(named: "#929292")
        
        activatedView.isHidden = false
        pendingView.isHidden = true
        featuredPendingView.isHidden = true
        
    }
    @IBAction func didTapPendingBtnAction(_ sender: Any) {
        adStatus = .pending
        products = []
        getProductsByUser(with: "pending")
        
        activatedLbl.textColor = UIColor(named: "#929292")
        activatedView.backgroundColor = UIColor(named: "#929292")
        
        pendingLbl.textColor = UIColor(named: "#0093F5")
        pendingView.backgroundColor = UIColor(named: "#0093F5")
        
        featuredPendingLbl.textColor = UIColor(named: "#929292")
        featuredPendingView.backgroundColor = UIColor(named: "#929292")
        
        activatedView.isHidden = true
        pendingView.isHidden = false
        featuredPendingView.isHidden = true
    }
    @IBAction func didTapFeaturedPendingBtnAction(_ sender: Any) {
        adStatus = .finished
        products = []
        getProductsByUser(with: "finished")
        
        activatedLbl.textColor = UIColor(named: "#929292")
        activatedView.backgroundColor = UIColor(named: "#929292")
        
        pendingLbl.textColor = UIColor(named: "#929292")
        pendingView.backgroundColor = UIColor(named: "#929292")
        
        featuredPendingLbl.textColor = UIColor(named: "#0093F5")
        featuredPendingView.backgroundColor = UIColor(named: "#0093F5")
        
        activatedView.isHidden = true
        pendingView.isHidden = true
        featuredPendingView.isHidden = false
    }
    
    
    @IBAction func didTapAddAdButton(_ sender: UIButton) {
        let vc = UIStoryboard(name: ADVS_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "AddAdvsVC") as! AddAdvsVC
        vc.isComeFromProfile = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK: CollectionView Delegate & DataSource

extension MyAdsVC : UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let myAdCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MyAdsCollectionViewCell else{return UICollectionViewCell()}
        myAdCell.delegate = self
        myAdCell.indexPath = indexPath
        myAdCell.setData(product: products[indexPath.item])
        return myAdCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: myAdsCollectionView.frame.width - 10, height: myAdsCollectionView.frame.height / 1.6 )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PRODUCT_VCID) as! ProductViewController
        vc.modalPresentationStyle = .fullScreen
        vc.product = products[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (products.count-1) && !isTheLast{
            page+=1
            switch self.adStatus {
                
            case .published:
                getProductsByUser(with: "published")
            case .pending:
                getProductsByUser(with: "pending")
            case .finished:
                getProductsByUser(with: "finished")
            }
            
        }
    }
}

//MARK: MyAdsCollectionViewCellDelegate

extension MyAdsVC:MyAdsCollectionViewCellDelegate {
    func deleteAdCell(buttonDidPressed indexPath: IndexPath) {
        //delete ad
        let params : [String: Any]  = ["id":products[indexPath.item].id ?? 0]
        print(params)
        guard let url = URL(string: Constants.DOMAIN+"prods_delete")else{return}
        AF.request(url, method: .post, parameters: params, encoding:URLEncoding.httpBody).responseDecodable(of:SuccessModel.self){[weak self]res in
            guard let self else {return}
            switch res.result{
            case .success(let data):
                if let success = data.success {
                    if success {
                        StaticFunctions.createSuccessAlert(msg:"Ads Deleted Seccessfully".localize)
                        
                        switch self.adStatus {
                            
                        case .published:
                            getProductsByUser(with: "published")
                        case .pending:
                            getProductsByUser(with: "pending")
                        case .finished:
                            getProductsByUser(with: "finished")
                        }
                        
//                        DispatchQueue.main.async {
//                            self.myAdsCollectionView.reloadData()
//                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func shareAdCell(buttonDidPressed indexPath: IndexPath) {
        if products[indexPath.row].status.safeValue.contains("unpaid"){
            //GO To Pay
            
            let vc = UIStoryboard(name: ADVS_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "PayingVC") as! PayingVC
            vc.isFeaturedAd = true
            vc.delegate = self
            print(AppDelegate.sharedSettings.storePriceFeaturedAds ?? 0.0)
            let product = products[indexPath.row]
            if let isStore = AppDelegate.currentUser.isStore {
                let userType: UserType = isStore ? .store : .regular
                let adType: AdType = product.isFeature ?? false ? .featured : .normal
                if let cost = StaticFunctions.fetchCost(userType: userType, adType: adType) {
                    print("Cost of Ads : \(cost)")
                    vc.amountDue = "\(cost)"
                }
            }
            
            vc.prodId = products[indexPath.row].id.safeValue
            self.present(vc, animated: true)
        }else if products[indexPath.row].status == "finished" {
            //TODO: Repost Ads
            self.productId = products[indexPath.item].id ?? 0
            self.isRepostProduct = true
            let vc = UIStoryboard(name: ADVS_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "PayingVC") as! PayingVC
            vc.isFeaturedAd = true
            vc.delegate = self
            
            let product = products[indexPath.row]
            if let isStore = AppDelegate.currentUser.isStore {
                let userType: UserType = isStore ? .store : .regular
                let adType: AdType = product.isFeature ?? false ? .featured : .normal
                if let cost = StaticFunctions.fetchCost(userType: userType, adType: adType) {
                    print("Cost of Ads : \(cost)")
                    vc.amountDue = "\(cost)"
                }
            }
                
                vc.prodId = products[indexPath.row].id.safeValue
            self.present(vc, animated: true)
            
        }else {
            shareContent(text:Constants.DOMAIN + "\(products[indexPath.row].id ?? 0)")

        }
        
        
    }
    
    func editAdCell(buttonDidPressed indexPath: IndexPath) {
        // GO TO Edit View Controller
        let product =  products[indexPath.item]
        let vc = UIStoryboard(name: ADVS_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: EDITAD_VCID) as! EditAdVC
        vc.modalPresentationStyle = .fullScreen
        vc.productId = product.id ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension MyAdsVC {
    private func getProductsByUser(with status:String){
         ProfileController.shared.getProductsByUser(completion: { [weak self]
             products, check, msg in
             guard let self else {return}
             print(products.count)
             if check == 0{
                 if self.page == 1 {
                     self.products.removeAll()
                     self.products = products
                     if self.products.isEmpty {
                         self.myAdsCollectionView.isHidden = true
                         self.noAdsStackView.isHidden = false
                     }else{
                         self.myAdsCollectionView.isHidden = false
                         self.noAdsStackView.isHidden = true
                     }
                     
                 }else{
                     self.products.append(contentsOf: products)
                 }
                 if products.isEmpty{
                     self.page = self.page == 1 ? 1 : self.page - 1
                     self.isTheLast = true
                 }
                 DispatchQueue.main.async {
                     self.myAdsCollectionView.reloadData()
                 }
             }else{
                 StaticFunctions.createErrorAlert(msg: msg)
                 self.page = self.page == 1 ? 1 : self.page - 1
             }
             
             //use 128 as user id to check
         }, userId: userId , page: page, countryId:6 ,status: status)
     }
    
    func repostAds(with id:Int){
        ProductController.shared.repostProduct(completion: { [weak self]
            product, check, msg in
            guard let self else {return}
            if check == 0{
                self.getProductsByUser(with: "finished")
            }else{
                StaticFunctions.createErrorAlert(msg: msg)
            }
            
        }, id: id ,countryId: AppDelegate.currentUser.id ?? 0)
    }
    
    private func goToSuccessfullAddAd(){
        let vc = UIStoryboard(name: ADVS_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: SUCCESS_ADDING_VCID) as! SuccessAddingVC
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
//        vc.isFromHome = self.isFromHome
        vc.delegate = self
        self.present(nav, animated: false)
    }
}

extension MyAdsVC:PayingDelegate {
    func passPaymentStatus(from PaymentStatus: String, invoiceId: String, invoiceURL: String, prodId: Int) {
        PayingController.shared.callBackFeaturedAds(completion: { [weak self] payment, check, message in
            guard let self else {return}
            if check == 0{
                print("ADS Paid Successfully",message)
                if isRepostProduct {
                    //wehen back form repay finishing ads
                    repostAds(with: productId)
                    isRepostProduct = false
                }else {
                    // when back form repay pensing ads
                    goToSuccessfullAddAd()
//                    getProductsByUser(with: "pending")
                }
            }else{
                print(message)
                StaticFunctions.createErrorAlert(msg: message)
            }
        }, invoiceId: invoiceId, invoiceURL: invoiceURL, prodId: prodId, status: PaymentStatus)
    }
    func didPayingSuccess() {
//        if isRepostProduct {
//            //wehen back form repay finishing ads
//            repostAds(with: productId)
//            isRepostProduct = false
//        }else {
//            // when back form repay pensing ads
//            getProductsByUser(with: "pending")
//        }
        
    }
    
    
}


extension MyAdsVC:SuccessAddingVCDelegate{
    func didTapUploadNewAds() {
        
    }
    
    
    func navigateToMyAdsPage (){
        if let vc = UIStoryboard(name: MENU_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: MYADS_VCID) as? MyAdsVC {
            print("ViewController instantiated successfully.")
            
            vc.modalPresentationStyle = .fullScreen
            if let currentUserID = AppDelegate.currentUser.id {
                print("User ID found: \(currentUserID)")
                vc.userId = currentUserID
            } else {
                print("User ID is nil or 0.")
            }
            
            if let navigationController = self.navigationController {
                navigationController.pushViewController(vc, animated: true)
                print("Pushing view controller.")
            } else {
                print("Navigation controller is nil.")
            }
        } else {
            print("Failed to instantiate ViewController.")
        }
        
    }
    func didTapMyAdsButton() {
        dismiss(animated: true) {
            // Then navigate to the "my ads" page
            self.navigateToMyAdsPage()
        }
    }
    
    
}
