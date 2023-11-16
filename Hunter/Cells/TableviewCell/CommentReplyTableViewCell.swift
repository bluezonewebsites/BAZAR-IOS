//
//  CommentReplyTableViewCell.swift
//  Bazar
//
//  Created by Amal Elgalant on 25/05/2023.
//

import UIKit

class CommentReplyTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var lbl_comment: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var stk_del: UIView!
    @IBOutlet weak var btn_del: UIButton!
    @IBOutlet weak var btn_reply: UIButton!
    @IBOutlet weak var btn_report: UIButton!
    
    @IBOutlet weak var favStackView: UIStackView!
    @IBOutlet weak var favCountLbl: UILabel!
    
    
    var replyBtclosure : (() -> Void)? = nil
    var flagBtclosure : (() -> Void)? = nil
    var likeBtclosure : (() -> Void)? = nil
    var removeBtclosure : (() -> Void)? = nil
    var showUserProfileBtclosure : (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setData(reply: Reply){
        
        img.setImageWithLoading(url: reply.userPic ?? "users/1675802939.png")
        
        lbl_name.text = reply.userName
        lbl_comment.text = reply.comment
        lbl_comment.sizeToFit()
        // should created response
        
        if let createdDate = reply.date  {
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

            let pastDate = dateFormatter.date(from:createdDate ) ?? Date()
//            lbl_date.text = diffDates(GetDateFromString(createdDate)).replace("-", "")
            lbl_date.text = pastDate.timeAgoDisplay()
        }
        
        if(AppDelegate.currentUser.id == reply.uid){
            stk_del.isHidden = false
            btn_del.isHidden = false
            favStackView.isHidden = true
        }else{
            stk_del.isHidden = true
            btn_del.isHidden = true
            favStackView.isHidden = false
        }
        if (reply.isLike ?? 0) >= 1 {
            likeImage.image = UIImage(named: "heartFill")
        }else {
            likeImage.image = UIImage(named: "heartgrey")
        }
        
        favCountLbl.text = String(reply.likeCount ?? 0)
        
        
    }
    func setData(reply: Comment){
        
        img.setImageWithLoading(url: reply.commentUserPic ?? "users/1675802939.png")
        
        lbl_name.text = reply.commentUserName
        lbl_comment.text = reply.comment
        lbl_comment.sizeToFit()
        // should created response
        
        if let createdDate = reply.createdAt  {
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

            let pastDate = dateFormatter.date(from:createdDate ) ?? Date()
            
            lbl_date.text = pastDate.timeAgoDisplay()
        }
        
        if(AppDelegate.currentUser.id == reply.userId){
            stk_del.isHidden = false
            btn_del.isHidden = false
            favStackView.isHidden = true
        }else{
            stk_del.isHidden = true
            btn_del.isHidden = true
            favStackView.isHidden = false
        }
        if (reply.isLike ?? 0) >= 1 {
            likeImage.image = UIImage(named: "heartFill")
        }else {
            likeImage.image = UIImage(named: "heartgrey")
        }
        
        favCountLbl.text = String(reply.countLike ?? 0)
        
        
    }
    @IBAction func deleteAction(_ sender: Any) {
        removeBtclosure!()
    }
    
    @IBAction func replyBtnAction(_ sender: Any) {
        replyBtclosure!()
    }
    
    @IBAction func likeAction(_ sender: Any) {
        likeBtclosure!()
    }
    @IBAction func reportAction(_ sender: Any) {
        flagBtclosure!()

    }
    
    @IBAction func showUserProfile(_ sender: Any) {
        showUserProfileBtclosure!()
    }
    
}
