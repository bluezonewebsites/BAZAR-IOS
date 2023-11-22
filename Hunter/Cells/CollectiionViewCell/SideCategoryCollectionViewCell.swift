//
//  SideCategoryCollectionViewCell.swift
//  Bazar
//
//  Created by Amal Elgalant on 03/05/2023.
//

import UIKit
import MOLH

class SideCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var CategoryImageView: UIImageView!
    
    func setData(category: Category){
        CategoryImageView.setImageWithLoadingFromMainDomain(url: category.image ?? "")
        if  MOLHLanguage.currentAppleLanguage() == "en" {
            nameLbl.text = category.nameEn ?? category.nameAr ?? ""
        }
        else{
            nameLbl.text = category.nameAr ?? category.nameEn ?? ""
            
        }
    }
}
