//
//  SearchStoreCell.swift
//  Bazar
//
//  Created by iOSayed on 07/09/2023.
//

import UIKit

class SearchStoreCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var storeTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    
    
    
    func setData(store:StoreObject){
        imageView.setImageWithLoading(url:store.coverPhoto ?? "")
        storeTitle.text = store.companyName ?? ""
    }
}
