//
//  RateOtherUserCell.swift
//  Bazar
//
//  Created by iOSayed on 14/06/2023.
//

import UIKit
import Cosmos

class RateOtherUserCell: UITableViewCell {

        @IBOutlet weak var rate: CosmosView!
        @IBOutlet weak var lbl_name: UILabel!
        @IBOutlet weak var lbl_comment: UILabel!
        @IBOutlet weak var lbl_date: UILabel!
        @IBOutlet weak var img: UIImageView!
        
        
        func configure(data:RateDataModel) {
//            guard let userPic = data.fromUserPic , let userName = data.fromUserName  , let userId = data.userRatedID , let date = data.date else {return}
            if data.ratedUserPic?.contains(".") == false  {
                img.image = UIImage(named: "logo_photo")
            }else{
                print(data.ratedUserPic ?? "")
                img.setImageWithLoading(url: data.ratedUserPic ?? "",placeholder: "logo_photo")
            }
                
                lbl_name.text = data.ratedUserName
                lbl_comment.text = data.comment
                lbl_comment.setLineSpacing()
                rate.rating = Double(data.rate)
//                lbl_date.text = diffDates(GetDateFromString(data.date ?? "")).replace("-", "")
            
            if let createdDate = data.date  {
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                
                let pastDate = dateFormatter.date(from:createdDate ) ?? Date()
                
                lbl_date.text = pastDate.timeAgoDisplay()
                
            }
        }
    }

