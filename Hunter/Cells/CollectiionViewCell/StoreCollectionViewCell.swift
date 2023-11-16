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
        imageView.setImageWithLoading(url:store.coverPhoto ?? "")
        storeTitle.text = store.companyName ?? ""
    }
}
