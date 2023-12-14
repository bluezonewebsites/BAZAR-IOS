//
//  UserBlockedTableViewCell.swift
//  NewBazar
//
//  Created by iOSayed on 23/11/2023.
//

import UIKit
import MOLH

protocol UserBlockedDelegate: AnyObject {
    func didTapOnBlockOrUnblockButton(in cell: UserBlockedTableViewCell)
}


class UserBlockedTableViewCell: UITableViewCell {

    @IBOutlet weak var cImageView: UIImageView!
    @IBOutlet weak var cNameLbl: UILabel!

    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var blockOrUnblockButton: UIButton!
    
    weak var delegate:UserBlockedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cImageView.layer.cornerRadius = cImageView.frame.width / 2
    }

   
    @IBAction func didTapBlockOrUnblockButton(_ sender: UIButton) {
        delegate?.didTapOnBlockOrUnblockButton(in: self)
    }
    func setData(from user: BlockUser){
        if cImageView != nil{
            self.cImageView.setImageWithLoadingFromMainDomain(url:user.pic ?? "" )
        }
        cNameLbl.text = user.name.safeValue
        locationLabel.text = ""
    }

}
