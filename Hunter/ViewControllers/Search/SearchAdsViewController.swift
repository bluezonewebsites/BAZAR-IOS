//
//  SearchAdsViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 23/05/2023.
//

import UIKit

class SearchAdsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var ads = [Product]()
    var page = 1
    var isTheLast = false
    var searchText = ""
    @IBOutlet weak var searchNoResult: UIStackView!
    @IBOutlet weak var textStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        getData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
   
    

}

extension SearchAdsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ads.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            var cell: ProductCollectionViewCell
        
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell-grid", for: indexPath) as! ProductCollectionViewCell
            
            cell.setData(product: ads[indexPath.row])
//            if (indexPath.row % 2) == 0 {
//                cell.backView.backgroundColor = UIColor(hexString: "#F4F8FF", alpha: 1)
//                cell.backView.backgroundColor = UIColor(hexString: "#F4F8FF", alpha: 1)
//            }else{
//                cell.backView.backgroundColor = .white
//                cell.backView.backgroundColor = .white
//            }
            return cell
    
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
           
                print((UIScreen.main.bounds.width )-15)
                return CGSize(width: (UIScreen.main.bounds.width)-50, height: 350)
    
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PRODUCT_VCID) as! ProductViewController
            vc.product = ads[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (ads.count-1) && !isTheLast{
            page+=1
            getData()

        }
    }
}
extension SearchAdsViewController{
    func getData(){
        print(searchText)

        SearchController.shared.searchAds(completion: { [self]
            ads, check, msg in
            if check == 0{
                if self.page == 1 {

                    self.ads.removeAll()
                    self.collectionView.reloadData()

                    self.ads = ads
                    
                }else{
                    self.ads.append(contentsOf: ads)
                }
                if ads.isEmpty{
                    self.page = self.page == 1 ? 1 : self.page - 1
                    self.isTheLast = true
                }
                if self.ads.count == 0{
                    self.searchNoResult.isHidden = false
                }else{
                    searchNoResult.isHidden = true
                }
                self.collectionView.reloadData()
            }else{
                StaticFunctions.createErrorAlert(msg: msg)
                self.page = self.page == 1 ? 1 : self.page - 1
            }
        }, id: AppDelegate.currentUser.id ?? 0, searchText: searchText, page: self.page,countryId: AppDelegate.currentCountry.id ?? 0)
    }
}
extension SearchAdsViewController: ContentDelegate{
    func updateContent(searchText: String, isHidden: Bool) {
        print(searchText)
        self.searchText = searchText
        self.page = 1
        self.isTheLast = false
        textStackView.isHidden = isHidden
        self.collectionView.isHidden = isHidden
        
        getData()
    }
    
    
}
