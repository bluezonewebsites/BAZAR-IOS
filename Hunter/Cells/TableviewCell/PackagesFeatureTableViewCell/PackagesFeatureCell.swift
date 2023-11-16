//
//  PackagesFeatureCell.swift
//  Bazar
//
//  Created by iOSayed on 05/09/2023.
//

import UIKit
import MOLH

class PackagesFeatureCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var countOfAds: UILabel!
    @IBOutlet weak var autoSubscripeImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setData(from data:Feature , index:Int){
        if MOLHLanguage.currentAppleLanguage() == "en" {
            self.titleLabel.text = data.titleEn
            self.subTitleLabel.text = data.descriptionEn
        }else{
            self.titleLabel.text = data.titleAr
            self.subTitleLabel.text = data.descriptionAr
        }
        if index == 0 {
            self.countOfAds.isHidden = false
            self.countOfAds.text = data.value
            self.checkImage.isHidden = true
        }else {
            self.countOfAds.isHidden = true
            self.checkImage.isHidden = false
        }
        
        
    }
    
}
