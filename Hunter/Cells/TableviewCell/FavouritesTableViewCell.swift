//
//  FavouritesTableViewCell.swift
//  Bazar
//
//  Created by iOSayed on 13/07/2023.
//

import UIKit
import Kingfisher
import MOLH


class FavouritesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_uname: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var img_favv: UIImageView!
    @IBOutlet weak var lbl_loc: UILabel!
    @IBOutlet weak var img_verify: UIImageView!
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var price_width: NSLayoutConstraint!
    @IBOutlet weak var lbl_currency: UILabel!
    @IBOutlet weak var price_stack: UIStackView!
    @IBOutlet weak var is_video: UIView!
    
    @IBOutlet weak var removeFromFavButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var ContainerView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Flip the cell horizontally
        //            ContainerView.transform = CGAffineTransform(scaleX: -1, y: 1)
            ContainerView.semanticContentAttribute = .forceLeftToRight
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
            // Flip the cell horizontally
//        ContainerView.transform = CGAffineTransform(scaleX: -1, y: 1)
       // ContainerView.semanticContentAttribute = .forceLeftToRight
        }
        
    override class func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    func configure(data:FavProdData) {
        guard let userName = data.userName  , let userId = data.uid  else {return}
        guard  let loc = data.loc,let prodPrice = data.price else {return}
        if let prodpic = data.prodsImage , let image = data.img  {
            if prodpic != "" {
                if prodpic.contains(".mp4")  || prodpic.contains(".mov") {

                    img.kf.indicatorType = .activity

                    guard let url = URL(string: Constants.IMAGE_URL + prodpic) else { return }
                    self.img.kf.setImage(with: AVAssetImageDataProvider(assetURL: url, seconds: 1))
                    is_video.isHidden = false

                    
                }else{
                    is_video.isHidden = true
                    img.setImageWithLoading(url: prodpic )
         
                }
            }else {
                if image.contains(".mp4")  || image.contains(".mov") {

                    img.kf.indicatorType = .activity

                    guard let url = URL(string: Constants.IMAGE_URL + image) else { return }
                    self.img.kf.setImage(with: AVAssetImageDataProvider(assetURL: url, seconds: 1))
                    is_video.isHidden = false

                    
                }else{
                    is_video.isHidden = true
                    img.setImageWithLoading(url: image )
         
                }
            }
            
        }
        
        if let date = data.createdAt {
            dateLabel.text = cDate(GetDateFromString(date))
            print(cDate(GetDateFromStringLocalizable(date)))
            //            }
            
                        
            lbl_uname.text = data.userName ?? ""
           
            
            self.lbl_name.text = data.name ?? ""
            print(prodPrice)
            self.lbl_price.text = "\(prodPrice)"
            
            if MOLHLanguage.currentAppleLanguage() == "en" {
                 let cityName = data.citiesNameEn ?? ""
                self.lbl_loc.text = cityName
                
                 let currancy = data.countriesCurrencyEn ?? ""
                self.lbl_currency.text = currancy
             }else{
                 let cityName = data.citiesNameAr ?? ""
                 self.lbl_loc.text = cityName
                 let currancy = data.countriesCurrencyAr ?? ""
                self.lbl_currency.text = currancy
            }
            
            
            
            if data.userVerified ?? 0 == 1 {
                img_verify.isHidden = false
            }else{
                img_verify.isHidden = true
            }
//                        img_user.imgUrl = data.user.pic
        }
    }
    
}
