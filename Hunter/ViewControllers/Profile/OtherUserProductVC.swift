//
//  OtherUserProductVC.swift
//  Bazar
//  Created by iOSayed on 14/06/2023.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class OtherUserProductVC: UIViewController {
    var products = [SpecialProdModel]()
    var page = 1
    var lastPage = 0
    var otherUserID = "0"
    var otherUserCountryId = 0
    
    @IBOutlet weak var lst: UICollectionView!
    
    @IBOutlet weak var loadingindecator: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingindecator.type = .ballPulse
        loadingindecator.color = UIColor(named: "#0EBFB1") ?? .yellow
//        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUserIDNotification(_:)), name:NSNotification.Name(rawValue: "passUserID"), object: nil)
        lst.register(UINib(nibName: "OtherUserProductCell", bundle: nil), forCellWithReuseIdentifier: "OtherUserProductCell")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            print(self.self.otherUserID , "Country:  " , self.otherUserCountryId)
            self.products.removeAll()
//            self.get(page: self.page)
        }
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            print(self.self.otherUserID , "Country:  " , self.otherUserCountryId)
            self.products.removeAll()
            self.get(page: self.page)
        }
    }
    
    @objc func handleUserIDNotification(_ notification: Notification) {
        if let userID = notification.userInfo?["userID"]  as? String {
            // Use the userID here
            print(userID)
            self.otherUserID = userID
            otherUserCountryId = 6
            products.removeAll()
            get(page: page)
        }
    }
    
    func clear_all(){
        lst.reloadData()
    }
    func get(page:Int){
        loadingindecator.startAnimating()
       // products.data?.data?.removeAll()
        let params : [String: Any]  = ["uid":otherUserID,"country_id":AppDelegate.currentUser.countryId ?? 0, "page":page,"status":"published"]
        print("parameters for get my advs ======> ", params)
        guard let url = URL(string: Constants.DOMAIN+"prods_by_user") else{return}
        AF.request(url, method: .post, parameters: params)
            .responseDecodable(of: SpecialProductModel.self) {[weak self] e in
                print("my advs response =======> " , e)
                guard let self else {return}
                loadingindecator.stopAnimating()
                switch e.result {
                case let .success(data):
                    print(data.data?.data)
                    if let data = data.data?.data {
                        self.products.append(contentsOf: data)
                    }
                    
                    if let lastPage = data.data?.lastPage {
                        self.lastPage = lastPage
                    }
                    print("My advs Data  =======> ",self.products)
                    DispatchQueue.main.async {
                        self.lst.reloadData()
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        
        
    }
    
}
extension OtherUserProductVC :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
//        guard let count = products.count else{return Int()}
//        print(count)
        return products.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let inx = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherUserProductCell", for: indexPath) as! OtherUserProductCell
            cell.configure(data: products[inx])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: lst.frame.width / 2 - 20, height: 170)
    }
    
   
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let inx = indexPath.row
        if let prodId = products[inx].id {
            let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PRODUCT_VCID) as! ProductViewController
            vc.modalPresentationStyle = .fullScreen
            vc.product.id = prodId
            navigationController?.pushViewController(vc, animated: true)
        }
       
    }
     func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      //  guard let count = products.data?.data?.count else{return}
        if indexPath.item == products.count - 1 {
                
                print(" ------------ fetch  More Data ---------")
            if page < lastPage  && indexPath.row == products.count - 1{
                    page += 1
                    DispatchQueue.main.async {
                        self.get(page: self.page)
                    }
                    
                    
                }
                
            }
        }
    
}
