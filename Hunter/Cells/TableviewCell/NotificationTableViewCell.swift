//
//  NotificationTableViewCell.swift
//  Bazar
//
//  Created by Amal Elgalant on 25/05/2023.
//

import UIKit
import M13Checkbox

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var msg: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var checkBox: M13Checkbox!
    
    
    var checkBoxBtclosure : (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(userNotification: UserNotification){
        if userNotification.userf?.count != 0 {
            if let name = userNotification.userf?[0].name {
                 self.name.text = name
            }else{
                self.name.text = "user".localize
            }
            
            img.setImageWithLoading(url: userNotification.userf?[0].pic ?? "",placeholder: "logo_photo")
             
        }else {
             self.name.text = "user".localize
             self.img.image = UIImage(named: "logo_photo")
        }
       
         self.msg.text = userNotification.ncontent
         self.msg.sizeToFit()
        
        

        //cell.timeLbl.text = cdates[inx]
        if let createdDate = userNotification.ndate  {
          
            
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

            let pastDate = dateFormatter.date(from:createdDate ?? "") ?? Date()
            
            
//            timeLbl.text = diffDates(GetDateFromString(createdDate)).replace("-", "")
        }

       

    }

    @IBAction func checkBoxAction(_ sender: Any) {
//        checkBoxBtclosure!()

    }
}
