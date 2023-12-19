//
//  StoreCollectionViewCell.swift
//  Bazar
//
//  Created by iOSayed on 02/09/2023.
//

import UIKit

class StoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var storeTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    
    
    
    func setData(store:StoreObject){
        if !store.coverPhoto.safeValue.isEmpty {
            imageView.setImageWithLoading(url: store.coverPhoto.safeValue)
        }else {
            imageView.setImageWithLoading(url: store.logo.safeValue)
        }
        storeTitle.text = store.companyName ?? ""
    }
}
