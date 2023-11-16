//
//  CategoryTableViewCell.swift
//  NewBazar
//
//  Created by Amal Elgalant on 16/11/2023.
//

import UIKit
import MOLH



class CategoryTableViewCell: UITableViewCell {
    
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
    func setData(category: Category){
        if cImageView != nil{
            self.cImageView.setImageWithLoading(url: category.image ?? "")
        }
        if  MOLHLanguage.currentAppleLanguage() == "en" {
            
            cNameLbl.text = category.nameEn ?? ""
        }
        
        else{
            cNameLbl.text = category.nameAr ?? ""
            
        }
    }
    
}
