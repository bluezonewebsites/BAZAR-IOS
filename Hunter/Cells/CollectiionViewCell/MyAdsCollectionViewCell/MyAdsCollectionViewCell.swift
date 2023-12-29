//
//  MyAdsCollectionViewCell.swift
//  Bazar
//
//  Created by iOSayed on 27/05/2023.
//

import UIKit
import MOLH
import Kingfisher

protocol MyAdsCollectionViewCellDelegate: AnyObject{
    func deleteAdCell(buttonDidPressed indexPath: IndexPath)
    func shareAdCell(buttonDidPressed indexPath: IndexPath)
    func editAdCell(buttonDidPressed indexPath: IndexPath)
}

class MyAdsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var adTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var isVideoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var verifiedImage: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var sellLabel: UILabel!
    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var deleteAdButton: UIButton!
    @IBOutlet weak var shareAdButton: UIButton!
    
    @IBOutlet weak var featuredImage: UIImageView!
    
    @IBOutlet weak var shareLabel: UILabel!
    weak var delegate:MyAdsCollectionViewCellDelegate?
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setData(product: Product){
        
        userImageView.setImageWithLoading(url: product.userPic ?? "",placeholder: "logo_photo")
        adTitleLabel.text = product.name
        priceLabel.text = "\(product.price ?? 0)"
        
        if  MOLHLanguage.currentAppleLanguage() == "en" {
            currencyLabel.text = product.currencyEn
//            currencyLabel.text = product.cityNameEn
            cityLabel.text = product.cityNameEn
        }else{
            currencyLabel.text = product.currencyAr
//            currencyLabel.text = product.cityNameAr
            cityLabel.text = product.cityNameAr
            
        }
        userNameLabel.text = "\(product.userName ?? "") \(product.userLastName ?? "")"
        print("\(product.userName ?? "") \(product.userLastName ?? "")")

        if product.userVerified == 1{
            verifiedImage.isHidden = false
        }else{
            verifiedImage.isHidden = true
        }  

        if let tajeerOrSell = product.adType  {
            
            if( tajeerOrSell == "rent"){
                sellLabel.text = "RENT".localize
                sellLabel.textColor = .white
                sellView.layer.borderWidth = 1.0
                sellView.layer.borderColor = UIColor(named: "#213970")?.cgColor
                sellView.clipsToBounds = true
                sellView.backgroundColor = UIColor(named: "#213970")
            }else if ( tajeerOrSell == "sell") {
                sellLabel.text = "SELL".localize
                sellView.layer.borderWidth = 1.0
                sellView.layer.borderColor = UIColor(named: "#0093F5")?.cgColor
                sellView.clipsToBounds = true
                sellLabel.textColor = .white
                sellView.backgroundColor = UIColor(named: "#0093F5")
            } else if ( tajeerOrSell == "donation") {
                sellLabel.text = "DONATION".localize
                sellView.layer.borderWidth = 1.0
                sellView.layer.borderColor = UIColor(named: "DonationColor")?.cgColor
                sellView.clipsToBounds = true
                sellLabel.textColor = .white
                sellView.backgroundColor = UIColor(named: "DonationColor")
            }else if ( tajeerOrSell == "buying") {
                sellLabel.text = "BUYING".localize
                sellView.layer.borderWidth = 1.0
                sellView.layer.borderColor = UIColor(named: "buyingColor")?.cgColor
                sellView.clipsToBounds = true
                sellLabel.textColor = .white
                sellView.backgroundColor = UIColor(named: "buyingColor")
            }
        }
        if let createDate = product.createdAt{
//            if createDate.count > 11 {
//                self.timeLabel.text =  diffDates(GetDateFromString(createDate)).replace("-", "")
//                
//            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            let pastDate = dateFormatter.date(from:createDate ) ?? Date()
            
            self.timeLabel.text = pastDate.timeAgoDisplay()
        }
        var imageLink = ""
        if product.mainImage == "" {
             imageLink = product.image ?? ""
        }else{
             imageLink = product.mainImage ?? ""
        }
        
        if product.isFeature  ?? false{
            featuredImage.isHidden = false
        }else{
            featuredImage.isHidden = true
        }
       
        
        if imageLink.contains(".mp4")  || imageLink.contains(".mov") {

            adImageView.kf.indicatorType = .activity

            guard let url = URL(string: Constants.IMAGE_URL + imageLink) else { return }
            self.adImageView.kf.setImage(with: AVAssetImageDataProvider(assetURL: url, seconds: 1))
            isVideoImageView.isHidden = false

            
        }else{
            isVideoImageView.isHidden = true
            adImageView.setImageWithLoading(url: imageLink )
 
        }
        
        if product.status.safeValue.contains("unpaid") {
            shareLabel.text = "Pay Now".localize
        }else if product.status == "finished" {
            shareLabel.text = "Repost".localize
        }else {
            shareLabel.text = "Share".localize
        }
    }
    
    
    @IBAction func didTapEditAdButton(_ sender: UIButton) {
        guard let delegate = delegate, let indexPath = indexPath else { return }
        
        delegate.editAdCell(buttonDidPressed: indexPath)
    }
    
    @IBAction func didTapDeleteAdButton(_ sender: UIButton) {
        guard let delegate = delegate, let indexPath = indexPath else { return }
        
        delegate.deleteAdCell(buttonDidPressed: indexPath)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let delegate = delegate, let indexPath = indexPath else { return }
        
        delegate.shareAdCell(buttonDidPressed: indexPath)
    }
    
}
