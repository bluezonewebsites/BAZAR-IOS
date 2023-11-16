//
//  FollowAndFollowersTapsCell.swift
//  Bazar
//
//  Created by iOSayed on 16/07/2023.
//

import UIKit

class FollowAndFollowersTapsCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var sliderView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                textLabel.textColor = UIColor(named: "#0093F5")
                sliderView.backgroundColor =  UIColor(named: "#0093F5")
                
            }else {
                textLabel.textColor = UIColor(named: "#414141")
                sliderView.backgroundColor = .clear
            }
        }
    }
    
    func setup(from data:String){
        textLabel.text = data
    }
}
