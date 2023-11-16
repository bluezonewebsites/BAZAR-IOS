//
//  CountryTableViewCell.swift
//  Bazar
//
//  Created by Amal Elgalant on 29/04/2023.
//

import UIKit
import MOLH

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var cImageView: UIImageView!
    @IBOutlet weak var cNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
