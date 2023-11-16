//
//  MainCategoryCollectionViewCell.swift
//  Bazar
//
//  Created by Amal Elgalant on 25/04/2023.
//

import UIKit
import SDWebImage
import MOLH

class MainCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryContainerView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var dropDwonImage: UIImageView!
    override var isSelected: Bool {
            didSet {
//                self.contentView.backgroundColor = isSelected ? UIColor(named: "#0093F5") : UIColor(named: "#F3F3F3")
//                self.titleLbl.textColor = isSelected ? UIColor.white :  UIColor(named: "blackColor")
                
                dropDwonImage.isHidden = !isSelected
            }
          
        }
    func setData(category: Category){
        dropDwonImage.isHidden = true
        if category.id == -1{
            categoryImageView.image = UIImage(named: "CategoryIcon")
        }else{
            categoryImageView.setImageWithLoading(url: category.image ?? "")
//            sd_setImage(with: URL(string: category.image ?? ""), placeholderImage: UIImage(named: "logo_Bazar"))
        }
        
      //  categoryImageView.sd_setImage(with: URL(string: category.image ?? ""), placeholderImage: UIImage(named: "logo_Bazar"))
        if  MOLHLanguage.currentAppleLanguage() == "en" {
            
            titleLbl.text = category.nameEn ??  category.nameAr ?? ""
        }
        
        else{
            titleLbl.text = category.nameAr ?? category.nameEn ?? ""

        }
    }
    
}
