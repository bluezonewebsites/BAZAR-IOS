//
//  UserSearchCell.swift
//  NewBazar
//
//  Created by iOSayed on 13/12/2023.
//

import UIKit
import MOLH

class UserSearchCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locatioonLbl: UILabel!
    @IBOutlet weak var verifiesImage: UIImageView!
    @IBOutlet weak var blockBtn: UIButton!
    var blockBtclosure : (() -> Void)? = nil

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(user: User){

        blockBtn.setTitle("Block".localize, for: .normal)

        if user.verified == 1{
            verifiesImage.isHidden = false
        }else{
            verifiesImage.isHidden = true
        }
        
        userImage.setImageWithLoading(url: user.pic ?? "",placeholder: "logo_photo")
        
        nameLbl.text = user.name ?? ""
        
        locatioonLbl.text = MOLHLanguage.currentAppleLanguage() == "en" ? user.citiesNameEn : user.citiesNameAr
        
       
       
        
        if(AppDelegate.currentUser.id  == user.id){
            blockBtn.isHidden = true
//            followIcon.isHidden = true
        }else{
            blockBtn.isHidden = false
        }
        
//        if let isFollow = user.searchIsFollow {
//            print(isFollow)
//            if isFollow == 1{
//                blockBtn.setTitleColor(UIColor(named: "#9AA6AE"), for: .normal)
//                blockBtn.setTitle("Cancel following".localize, for: .normal)
//                followIcon.isHidden = true
//            }else{
//                blockBtn.setTitleColor(UIColor.black, for: .normal)
//                blockBtn.setTitle("Follow".localize, for: .normal)
//                followIcon.isHidden = false
//            }
//        }else if let isFollow = user.isFollow {
//            print(isFollow)
//            if isFollow == 1{
//                blockBtn.setTitleColor(UIColor(named: "#9AA6AE"), for: .normal)
//                blockBtn.setTitle("Cancel following".localize, for: .normal)
//                followIcon.isHidden = true
//            }else{
//                blockBtn.setTitleColor(UIColor.black, for: .normal)
//                blockBtn.setTitle("Follow".localize, for: .normal)
//                followIcon.isHidden = false
//            }
//        }
       
        
       
    }
    @IBAction func blockBtnAction(_ sender: Any) {
        blockBtclosure!()
    }
    
}

