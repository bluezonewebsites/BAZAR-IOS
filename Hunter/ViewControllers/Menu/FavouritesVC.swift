//
//  FavouritesVC.swift
//  Bazar
//
//  Created by iOSayed on 19/06/2023.
//

import Foundation

import UIKit
import Alamofire
import MOLH

class FavouritesVC: UIViewController {
    var data = [FavProdData]()
    
    @IBOutlet weak var FavouritesTableView: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var emptyView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        self.title = "Favourites".localize
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        } else {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        headerView.cornerRadius = 40
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        emptyView.isHidden = true
         self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isHidden = false
        let customNavBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0))
        navigationController?.navigationBar.tintColor = .white
            customNavBar.backgroundColor = UIColor(named: "#0093F5")
        // Set your desired background color
            view.addSubview(customNavBar)
//        lst.backgroundColor = UIColor.clear.withAlphaComponent(0)
        FavouritesTableView.register(UINib(nibName: "FavouritesTableViewCell", bundle: nil), forCellReuseIdentifier: "FavouritesTableViewCell")
//        if let layout = lst.collectionViewLayout as? UICollectionViewFlowLayout {
//                layout.scrollDirection = .vertical
//            }
        //lst.configure(top:15, bottom:100, left: 15, right: 15,hspace:15,scroll: .vertical)
        FavouritesTableView.delegate = self
        FavouritesTableView.dataSource = self
        FavouritesTableView.semanticContentAttribute = .forceLeftToRight
        get()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
        tabBarController?.tabBar.isHidden = false
        
    }
   
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    func clear_all(){
        data.removeAll()
        FavouritesTableView.reloadData()
    }
    
    
    func get(){
        clear_all()
        let params : [String: Any]  = ["uid":AppDelegate.currentUser.id ?? 0]
        guard let url = URL(string: Constants.DOMAIN+"fav_by_user") else{return}
        print(params)
        AF.request(url, method: .post, parameters: params)
            .responseDecodable(of: FavouriteProductModel.self) { e in
               print(e)
                switch e.result {
                case let .success(data):
                    guard let favProd = data.data?.data else {return}
                    self.data = favProd
                    print(data)
                    DispatchQueue.main.async {
                        self.FavouritesTableView.reloadData()
                        if favProd.count != 0 {
                            self.emptyView.isHidden = true
                        }else{
                            self.emptyView.isHidden = false
                        }
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                    self.emptyView.isHidden = false

                }
            }
    }
   
    
}
extension FavouritesVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inx = indexPath.row
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as? FavouritesTableViewCell else{return UITableViewCell()}
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            cell.ContainerView.semanticContentAttribute = .forceLeftToRight
            cell.lbl_uname.textAlignment = .left
        }
     //   cell.ContainerView.semanticContentAttribute = .forceLeftToRight
        cell.configure(data: data[inx])
        cell.removeFromFavButton.tag = inx
        cell.removeFromFavButton.addTarget(self, action: #selector(removeFromFavs), for: .touchUpInside)
        return cell
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
//
//   }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//       let inx = indexPath.row
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouritesCollectionViewCell", for: indexPath) as? FavouritesCollectionViewCell else{return UICollectionViewCell()}
//       cell.configure(data: data[inx])
////        cell.titleText.text = "dsdsdsdsdddsdsddd"
//       cell.removeFromFavButton.tag = inx
//       cell.removeFromFavButton.addTarget(self, action: #selector(removeFromFavs), for: .touchUpInside)
//       return cell
//   }
   
   @objc func removeFromFavs(_ sender:UIButton){
       print(sender.tag)
       if let prodId = data[sender.tag].id {
           let params : [String: Any]  = ["prod_id":prodId]
           guard let url = URL(string: Constants.DOMAIN+"fav_prod") else {return}
           print(params, url)
           print(Constants.headerProd)
           AF.request(url , method: .post,parameters: params, headers:Constants.headerProd)
               .responseDecodable(of: SuccessModel.self) { res in
                   print(res.value)
                   switch res.result {
                       
                   case .success( _):
                       self.get()
                   case .failure(let error):
                       StaticFunctions.createErrorAlert(msg: "the data you entered does not match our data".localize)
                       print(error.localizedDescription)
                   }
                   
               }
           
       }
   }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inx = indexPath.row
               guard let prodId = data[inx].id else {return}
        //        order.product_id = "\(prodId)"
                 let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PRODUCT_VCID) as! ProductViewController
                 vc.modalPresentationStyle = .fullScreen
                 vc.product.id = prodId
                 self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
//   func collectionView(_ collectionView: UICollectionView,
//                       layout collectionViewLayout: UICollectionViewLayout,
//                       sizeForItemAt indexPath: IndexPath) -> CGSize {
//       return CGSize(width: lst.frame.width , height: 120)
//   }
//
//
//     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//       let inx = indexPath.row
//       guard let prodId = data[inx].id else {return}
////        order.product_id = "\(prodId)"
//         let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PRODUCT_VCID) as! ProductViewController
//         vc.modalPresentationStyle = .fullScreen
//         vc.product.id = prodId
//         self.navigationController?.pushViewController(vc, animated: true)
////        goNav("prodv","Prods")
//   }
}
extension FavouritesVC:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y

        // Check if the scroll direction is upwards
        if contentOffsetY > 0 {
            navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
}
