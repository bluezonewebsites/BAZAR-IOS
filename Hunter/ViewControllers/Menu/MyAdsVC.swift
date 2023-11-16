//
//  MyAdsVC.swift
//  Bazar
//
//  Created by iOSayed on 24/05/2023.
//

import UIKit
import Alamofire

class MyAdsVC: UIViewController {

    @IBOutlet weak var myAdsCollectionView: UICollectionView!
    
    
    @IBOutlet weak var featuredPendingView: UIView!
    @IBOutlet weak var featuredPendingLbl: UILabel!
    @IBOutlet weak var pendingView: UIView!
    @IBOutlet weak var pendingLbl: UILabel!
    @IBOutlet weak var activatedView: UIView!
    @IBOutlet weak var activatedLbl: UILabel!
    
    @IBOutlet weak var noAdsStackView: UIStackView!
    private  let cellIdentifier = "MyAdsCollectionViewCell"
    private var products = [Product]()
    private var page = 1
    private var isTheLast = false
            var userId = 0
    
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
        products = []
        getProductsByUser(with: "unpaid_normal")
        
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
        products = []
        getProductsByUser(with: "unpaid_feature")
        
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
            getProductsByUser(with: "")
            
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
        AF.request(url, method: .post, parameters: params, encoding:URLEncoding.httpBody).responseDecodable(of:SuccessModel.self){res in
            switch res.result{
            case .success(let data):
                if let success = data.success {
                    if success {
                        StaticFunctions.createSuccessAlert(msg:"Ads Deleted Seccessfully".localize)
                        self.getProductsByUser(with: "")
                        self.myAdsCollectionView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func shareAdCell(buttonDidPressed indexPath: IndexPath) {
        if products[indexPath.row].status == "unpaid_feature" {
            //GO To Pay
            PayingController.shared.payingFeaturedAd(completion: { payment, check, message in
                if check == 0{
                    let vc = UIStoryboard(name: ADVS_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "PayingVC") as! PayingVC
                    vc.urlString = payment?.data.invoiceURL ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    StaticFunctions.createErrorAlert(msg: message)
                }
            }, countryId: AppDelegate.currentUser.countryId ?? 5, productId: products[indexPath.item].id ?? 0)
        }else{
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
         ProfileController.shared.getProductsByUser(completion: {
             products, check, msg in
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
                 self.myAdsCollectionView.reloadData()
             }else{
                 StaticFunctions.createErrorAlert(msg: msg)
                 self.page = self.page == 1 ? 1 : self.page - 1
             }
             
             //use 128 as user id to check
         }, userId: userId , page: page, countryId:6 ,status: status)
     }
    
}

