//
//  FollowerTableViewCell.swift
//  Bazar
//
//  Created by Amal Elgalant on 23/05/2023.
//

import UIKit
import MOLH

class FollowerTableViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locatioonLbl: UILabel!
    @IBOutlet weak var verifiesImage: UIImageView!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var followIcon: UIImageView!
    var followBtclosure : (() -> Void)? = nil

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//#9AA6AE
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(user: User){


        if user.verified == 1{
            verifiesImage.isHidden = false
        }else{
            verifiesImage.isHidden = true
        }
        
        userImage.setImageWithLoading(url: user.pic ?? "",placeholder: "logo_photo")
        
        nameLbl.text = user.name ?? ""
        
        locatioonLbl.text = MOLHLanguage.currentAppleLanguage() == "en" ? user.citiesNameEn : user.citiesNameAr
        
       
       
        
        if(AppDelegate.currentUser.id  == user.id){
            followBtn.isHidden = true
            followIcon.isHidden = true

        }else{
            followBtn.isHidden = false
        }
        
        if let isFollow = user.searchIsFollow {
            print(isFollow)
            if isFollow == 1{
                followBtn.setTitleColor(UIColor(named: "#9AA6AE"), for: .normal)
                followBtn.setTitle("Cancel following".localize, for: .normal)
                followIcon.isHidden = true
            }else{
                followBtn.setTitleColor(UIColor.black, for: .normal)
                followBtn.setTitle("Follow".localize, for: .normal)
                followIcon.isHidden = false
            }
        }else if let isFollow = user.isFollow {
            print(isFollow)
            if isFollow == 1{
                followBtn.setTitleColor(UIColor(named: "#9AA6AE"), for: .normal)
                followBtn.setTitle("Cancel following".localize, for: .normal)
                followIcon.isHidden = true
            }else{
                followBtn.setTitleColor(UIColor.black, for: .normal)
                followBtn.setTitle("Follow".localize, for: .normal)
                followIcon.isHidden = false
            }
        }
       
        
       
    }
    @IBAction func followAction(_ sender: Any) {
        followBtclosure!()
    }
    
}
