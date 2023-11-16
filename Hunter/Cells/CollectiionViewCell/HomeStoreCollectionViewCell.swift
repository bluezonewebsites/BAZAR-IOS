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
        imageView.setImageWithLoading(url: store.coverPhoto ?? "")
        storeTitleLabel.text = store.companyName ?? ""
        storeSubTitleLabel.text = store.bio ?? ""
    }
    
}

