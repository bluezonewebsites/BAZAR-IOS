//
//  ChangeCountyTableViewCell.swift
//  Bazar
//
//  Created by iOSayed on 03/06/2023.
//

import UIKit
import MOLH

class ChangeCountyTableViewCell: UITableViewCell {

    @IBOutlet weak var cImageView: UIImageView!
    @IBOutlet weak var cNameLbl: UILabel!

    @IBOutlet weak var checkImageView: UIImageView!
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
            self.cImageView.setImageWithLoading(url: country.image ?? "")
        }
        if  MOLHLanguage.currentAppleLanguage() == "en" {
            
            cNameLbl.text = country.nameEn ?? ""
        }
        
        else{
            cNameLbl.text = country.nameAr ?? ""

        }
    }

}
