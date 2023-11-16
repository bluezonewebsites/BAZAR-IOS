//
//  AskSubCategoryCollectionViewCell.swift
//  Bazar
//
//  Created by Amal Elgalant on 26/05/2023.
//

import UIKit
import MOLH

class AskSubCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var lbl_name: UILabel!

   
    
    func setData(city:Country) {
        if  MOLHLanguage.currentAppleLanguage() == "en" {
            lbl_name.text = city.nameEn ?? ""
        }
        else{
            lbl_name.text = city.nameAr ?? ""
        }
    }
}
