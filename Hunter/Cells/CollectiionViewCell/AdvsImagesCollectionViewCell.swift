//
//  AdvsImagesCollectionViewCell.swift
//  Bazar
//
//  Created by iOSayed on 07/05/2023.
//

import UIKit

protocol AdvsImagesCollectionViewCellDelegate:AnyObject{
    func didRemoveCell(indexPath:IndexPath)
    func didSelectCell(indexPath: IndexPath)
}

class AdvsImagesCollectionViewCell: UICollectionViewCell {
    
    var indexPath:IndexPath?
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var mainImageFlag: UILabel!
    
    @IBOutlet weak var removeButton: UIButton!
    
    weak var delegate:AdvsImagesCollectionViewCellDelegate?
    
    override class func awakeFromNib() {
    }
    
    var isSelectedCell: Bool = false {
            didSet {
                mainImageFlag.isHidden = !isSelectedCell
            }
        }

        override var isSelected: Bool {
            didSet {
                if isSelected {
                    guard let delegate = delegate, let indexPath = indexPath else { return }
     delegate.didSelectCell(indexPath: indexPath)
                }
            }
        }

    
    func configureCell(images: [UIImage], selectedIndex: IndexPath?,mainImageKey:String,imagekeyOfIndex  key:String) {
            guard let indexPath = indexPath else { return }

            mainImageFlag.isHidden = true
            imageView.image = images[indexPath.row]

        if indexPath == selectedIndex && mainImageKey == key {
                isSelectedCell = true
            } else {
                isSelectedCell = false
            }
        
    }
    
    
    @IBAction func didTapRemoveCellButton(_ sender: UIButton) {
        
        guard let delegate = delegate, let indexPath = indexPath else { return }
        delegate.didRemoveCell(indexPath: indexPath)
    }
    
}
