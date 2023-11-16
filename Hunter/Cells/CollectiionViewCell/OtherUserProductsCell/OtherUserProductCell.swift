//
//  OtherUserProductCell.swift
//  Bazar
//
//  Created by iOSayed on 14/06/2023.
//

import UIKit
import Kingfisher

class OtherUserProductCell: UICollectionViewCell {
        
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var is_video: UIView!
    
    override class func awakeFromNib() {
            //view.shadow(2, 0.1)
        }
        
        func configure(data:SpecialProdModel) {
            if let image = data.img , let prodImage = data.prodsImage {
                print(image)
                if image != "" {
                    if image.contains(".mp4")  || image.contains(".mov") {

                        img.kf.indicatorType = .activity

                        guard let url = URL(string: Constants.IMAGE_URL + image) else { return }
                        self.img.kf.setImage(with: AVAssetImageDataProvider(assetURL: url, seconds: 1))
                        is_video.isHidden = false

                        
                    }else{
                        is_video.isHidden = true
                        img.setImageWithLoading(url: image )
                    }
                }else {
                    if prodImage.contains(".mp4")  || prodImage.contains(".mov") {

                        img.kf.indicatorType = .activity

                        guard let url = URL(string: Constants.IMAGE_URL + prodImage) else { return }
                        self.img.kf.setImage(with: AVAssetImageDataProvider(assetURL: url, seconds: 1))
                        is_video.isHidden = false

                        
                    }else{
                        is_video.isHidden = true
                        img.setImageWithLoading(url: prodImage )
                    }
                }
                
            }
            
    //        let prodpic = data.prodsImage ?? ""
    //        if prodpic.contains(".mp4") || prodpic.contains(".mov"){
    //            img.videoUrl = prodpic
    //            is_video.showMe()
    //        }else{
    //            img.imgUrl = prodpic
    //            is_video.hideMe()
    //        }
        }
    }

