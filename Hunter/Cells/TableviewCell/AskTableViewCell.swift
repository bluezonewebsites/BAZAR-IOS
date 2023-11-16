//
//  AskTableViewCell.swift
//  Bazar
//
//  Created by Amal Elgalant on 24/05/2023.
//

import UIKit

class AskTableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_comment: UILabel!
    @IBOutlet weak var img_comment: UIImageView!
    @IBOutlet weak var number_of_comments: UILabel!
    
    @IBOutlet weak var pictureQuestContainer: UIView!
    @IBOutlet weak var openQuestPictureButton: UIButton!
    @IBOutlet weak var btn_view_comments: UIButton!
    @IBOutlet weak var btn_del: UIButton!
    @IBOutlet weak var btn_profile: UIButton!
    @IBOutlet weak var delv: UIView!
    @IBOutlet weak var verificationImage: UIImageView!
    var showUserBtclosure : (() -> Void)? = nil
    var deleteBtclosure : (() -> Void)? = nil
    var zoomBtclosure : (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(ask: Ask) {
      
        img.setImageWithLoading(url: ask.userPic ?? "")
        
        
        lbl_name.text = ask.name ?? ""
        lbl_comment.text = ask.quest ?? ""
        lbl_comment.sizeToFit()
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        print(TimeZone.current)
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let pastDate = dateFormatter.date(from:ask.cdate ?? "") ?? Date()
        print(pastDate)
        
        lbl_date.text = pastDate.timeAgoDisplay()

        number_of_comments.text = "(\(ask.comments ?? 0 ))"
        if(AppDelegate.currentUser.id == ask.userId){
            delv.isHidden = false
        }else{
            delv.isHidden = true
        }
        
        if ask.userVerified == 1{
            verificationImage.isHidden = false
        }else{
            verificationImage.isHidden = true
        }
        
        if(ask.pic == "-") || (ask.pic == nil){
            img_comment.isHidden = true
            pictureQuestContainer.isHidden = true
        }else{
            img_comment.isHidden = false
            pictureQuestContainer.isHidden = false
            img_comment.setImageWithLoading(url: ask.pic ?? "")
        }
    }
    @IBAction func profileAction(_ sender: Any) {
       showUserBtclosure!()
        
    }
    @IBAction func deleteBtnAction(_ sender: Any) {
        deleteBtclosure!()

    }
    
    @IBAction func showIImageAction(_ sender: Any) {
        zoomBtclosure!()

      
    }
}
