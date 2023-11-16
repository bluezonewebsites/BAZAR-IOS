//
//  ProfileProductsCollectionViewCell.swift
//  Bazar
//
//  Created by iOSayed on 21/05/2023.
//

import UIKit
import MOLH
import SDWebImage
import Kingfisher


class ProfileProductsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var currencuLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var videoIcone: UIImageView!
    @IBOutlet weak var subscribeImage: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var sellLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func setData(product: Product){
        
        nameLbl.text = product.name
        priceLbl.text = "\(product.price ?? 0)"
        
        if  MOLHLanguage.currentAppleLanguage() == "en" {
            currencuLbl.text = product.currencyEn
            cityLbl.text = product.cityNameEn
            
        }else{
            currencuLbl.text = product.currencyAr
            cityLbl.text = product.cityNameAr
            
        }
        
        
        
        
        
        
        ownerName.text = "\(product.userName ?? "") \(product.userLastName ?? "")"
        
        
        if product.userVerified == 1{
            subscribeImage.isHidden = false
        }else{
            subscribeImage.isHidden = true
        }
        
        if let tajeerOrSell = product.type  {
            
            if( tajeerOrSell == 1){
                sellLbl.text = "rent".localize
                sellLbl.textColor = .black
                sellView.layer.borderWidth = 1.0
                sellView.layer.borderColor = UIColor.black.cgColor
                sellView.clipsToBounds = true
                sellView.backgroundColor = .white
            }else{
                sellLbl.text = "sell".localize
                sellView.layer.borderWidth = 1.0
                sellView.layer.borderColor = UIColor(named: "#0093F5")?.cgColor
                sellView.clipsToBounds = true
                sellLbl.textColor = .white
                sellView.backgroundColor = UIColor(named: "#0093F5")
            }
            
            
            
        }
        if let createDate = product.createdAt{
//            if createDate.count > 11 {
//                self.timeLbl.text =  diffDates(GetDateFromString(createDate)).replace("-", "")
//            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            let pastDate = dateFormatter.date(from:createDate ) ?? Date()
            
            self.timeLbl.text = pastDate.timeAgoDisplay()
        }
        var imageLink = ""
        if product.mainImage == "" {
             imageLink = product.image ?? ""
        }else{
             imageLink = product.mainImage ?? ""
        }
        
       
        
        if imageLink.contains(".mp4")  || imageLink.contains(".mov") {

            imageView.kf.indicatorType = .activity

            guard let url = URL(string: Constants.IMAGE_URL + imageLink) else { return }
            self.imageView.kf.setImage(with: AVAssetImageDataProvider(assetURL: url, seconds: 1))
            videoIcone.isHidden = false

            
        }else{
            videoIcone.isHidden = true
            imageView.setImageWithLoading(url: imageLink )

        }
        
    }
}
