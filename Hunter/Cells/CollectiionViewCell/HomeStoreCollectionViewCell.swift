//
//  sa.swift
//  Bazar
//
//  Created by iOSayed on 13/08/2023.
//

import UIKit

class HomeStoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var storeSubTitleLabel: UILabel!
    @IBOutlet weak var storeTitleLabel: UILabel!
    
    
    func setData(from store:StoreObject){
        
        if !store.coverPhoto.safeValue.isEmpty &&  store.coverPhoto.safeValue.contains("image") {
            imageView.setImageWithLoadingFromMainDomain(url: store.coverPhoto.safeValue)
        }else if !store.coverPhoto.safeValue.isEmpty {
            imageView.setImageWithLoading(url: store.coverPhoto.safeValue)
        }else {
            imageView.setImageWithLoading(url: store.logo.safeValue)

        }
        storeTitleLabel.text = store.companyName ?? ""
        storeSubTitleLabel.text = store.bio ?? ""
    }
    
}

