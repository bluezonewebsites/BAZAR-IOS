//
//  ProdSpecialCell.swift
//  Bazar
//
//  Created by khaled on 21/05/2022.
//  Copyright © 2022 roll. All rights reserved.
//

import UIKit
import Kingfisher

class MsgMediaCellReciver: MsgGlobalCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var videov: UIView!
    @IBOutlet weak var img_video: UIImageView!
    override func awakeFromNib() {
        img.apply_right_bubble()
        videov.apply_right_bubble()
        container.apply_right_bubble()
    }
    
    override func configure(data:Result) {
//        if data.rid == AppDelegate.currentUser.id {
//            container.backgroundColor = .gray
//        }else {
//            container.backgroundColor =  UIColor(named: "#0093F5")
//        }
        
        if let image = data.image {
            
            if data.mtype == "VIDEO"{
                
                img.kf.indicatorType = .activity
                
                guard let url = URL(string: Constants.IMAGE_URL + image) else { return }
                self.img.kf.setImage(with: AVAssetImageDataProvider(assetURL: url, seconds: 1))
                
                videov.hideMe()
                img_video.showMe()
            }else{
                img.setImageWithLoading(url: image)
                videov.hideMe()
                img_video.hideMe()
            }
        }
        
    }
}
