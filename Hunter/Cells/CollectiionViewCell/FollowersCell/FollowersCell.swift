//
//  FollowersCell.swift
//  Bazar
//
//  Created by iOSayed on 15/06/2023.
//

import UIKit

class FollowersCell: UICollectionViewCell {
    
        @IBOutlet weak var img: UIImageView!
        @IBOutlet weak var lbl_name: UILabel!
        @IBOutlet weak var lbl_loc: UILabel!
        @IBOutlet weak var img_verified: UIImageView!
        @IBOutlet weak var btn_follow: UIButton!
        @IBOutlet weak var followIcon: UIImageView!
        
        
        func configureFollow(data:FollowersSuccessData) {
            if let verified = data.userVerified , let toID = data.toID  {
                
                if let pic = data.userPic {
                    img.setImageWithLoading(url: pic)
                }else {
                    img.image = UIImage(named:"logo_photo")
                }
                if  let userName = data.userName {
                    lbl_name.text = userName
                }
              //  if let cityId = data.citiesNameAr {
                    lbl_loc.text = data.citiesNameAr ?? "الجهراء"
               // }
                
                
                if verified == 1{
                    img_verified.isHidden = false
                }else{
                    img_verified.isHidden = true
                }
                if let isFollow = data.isFollow {
                    if isFollow == 1{
                        btn_follow.setTitleColor(UIColor(hexString: "#9AA6AE"), for: .normal)
                        btn_follow.setTitle(("unfollow".localize), for: .normal)
                        followIcon.isHidden = true
                    }else{
                        
                        btn_follow.setTitleColor(UIColor(named: "#0093F5"), for: .normal)
                        btn_follow.setTitle(("Follow".localize), for: .normal)
                        followIcon.isHidden = false
                    }
                }
                
                if toID == AppDelegate.currentUser.id{
                    btn_follow.isHidden = true
                }else{
                    btn_follow.isHidden = false
                }
            }
            
        }
        
        
        
        
//        func configure(data:UserSearchData) {
//            guard  let verified = data.verified , let fid = data.id else {return}
//            if let pic = data.pic {
//                img.setImageWithLoading(url: pic)
//            }else {
//                img.image = UIImage(named:"logo_photo")
//            }
//            
//            if let userName = data.username {
//                lbl_name.text = userName
//            }
//            
//            if let cityId = data.citiesNameAr{
//                lbl_loc.text = cityId
//            }
//           
//            
//            if verified == 1{
//                img_verified.isHidden = false
//            }else{
//                img_verified.isHidden = true
//            }
//            print(data.follow)
//            if let isFollow = data.follow {
//                print(isFollow)
//                if isFollow == 1{
//                    btn_follow.setTitleColor(UIColor(hexString: "#9AA6AE"), for: .normal)
//                    btn_follow.setTitle(("unfollow".localize), for: .normal)
//                    followIcon.isHidden = true
//                }else{
//                    
//                    btn_follow.setTitleColor(UIColor(hexString: "#0093F5"), for: .normal)
//                    btn_follow.setTitle(("Follow".localize), for: .normal)
//                    followIcon.isHidden = false
//                }
//            }
//           
//            if fid == AppDelegate.currentUser.id{
//                btn_follow.isHidden = true
//            }else{
//                btn_follow.isHidden = false
//            }
//           
//        }
    }
