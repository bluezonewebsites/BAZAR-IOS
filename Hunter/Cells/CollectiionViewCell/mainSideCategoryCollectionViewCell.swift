//
//  mainSideCategoryCollectionViewCell.swift
//  Bazar
//
//  Created by Amal Elgalant on 03/05/2023.
//

import UIKit
import MOLH

class mainSideCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageBackView: UIView!
    
    @IBOutlet weak var cImageView: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var divider: UIView!
    
    func setData(category:Category) {
        if let name = category.nameAr  {
            if name.contains("اسال"){
                if  MOLHLanguage.currentAppleLanguage() == "en" {
                    lbl_name.text = "ask \(AppDelegate.currentCountry.nameEn ?? "")"
                }
                else{
                    lbl_name.text = "اسال \(AppDelegate.currentCountry.nameAr ?? "")"
                    
                }
                cImageView.image = UIImage(named: "askImage")
            }
            else{
                if  MOLHLanguage.currentAppleLanguage() == "en" {
                    lbl_name.text = category.nameEn ?? category.nameAr ?? ""
                }
                else{
                    lbl_name.text = category.nameAr ?? category.nameEn ?? ""
                    
                }
                cImageView.setImageWithLoading(url: category.image ?? "")
            }
        }
        
       
    }
    override var isSelected: Bool {
        didSet {
            if isSelected{
                backgroundColor = UIColor(named: "#F5F5F5")
                
                imageBackView.backgroundColor = UIColor.white
                divider.backgroundColor = UIColor(named: "#0093F5")
            }else{
                backgroundColor = .clear
                imageBackView.backgroundColor = UIColor(named: "#F5F5F5")
                
                divider.backgroundColor = .clear
            }
            
            
        }
        
    }
    
    
    
    
}
