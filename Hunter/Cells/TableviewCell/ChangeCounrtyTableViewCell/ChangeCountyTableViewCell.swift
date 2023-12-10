//
//  ChangeCountyTableViewCell.swift
//  Bazar
//
//  Created by iOSayed on 03/06/2023.
//

import UIKit
import Kingfisher
import MOLH

class ChangeCountyTableViewCell: UITableViewCell {

    @IBOutlet private weak var cImageView: UIImageView!
    @IBOutlet private weak var cNameLbl: UILabel!
    @IBOutlet  weak var checkImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if isSelected {
            checkImageView.isHidden = false
        }else{
            checkImageView.isHidden = true
        }
    }
    func setData(country: Country){
        if cImageView != nil{
            if let url = URL(string:Constants.MAIN_DOMAIN + country.image.safeValue) {
                print(url)
                cImageView.kf.setImage(with: url)
            }

//            self.cImageView.setImageWithLoading(url: country.image ?? "")
        }
        if  MOLHLanguage.currentAppleLanguage() == "en" {
            
            cNameLbl.text = country.nameEn ?? ""
        }
        
        else{
            cNameLbl.text = country.nameAr ?? ""

        }
    }

}
