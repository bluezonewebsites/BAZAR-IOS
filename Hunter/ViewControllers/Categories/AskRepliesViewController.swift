//
//  AskRepliesViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 27/05/2023.
//

import UIKit

class AskRepliesViewController: UIViewController {

    //comments
    @IBOutlet weak var lst: UITableView!
    var data = AsksReplayObject()
    
    //data
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_comment: UILabel!
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var askImageView: UIImageView!

    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        lst.rowHeight = UITableView.automaticDimension
        getData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData(_:)), name: NSNotification.Name(rawValue: "updateData"), object: nil)
        
//        countOfCommentsLabel.text = "مشاهدة التعليقات (\(replaiesCount))"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
    }
  
    @objc func updateData(_ notification: NSNotification) {
        getData()
        
    }
    
    @IBAction func showUserProfile(_ sender: Any) {
        let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: OTHER_USER_PROFILE_VCID) as! OtherUserProfileVC
        vc.OtherUserId = self.data.question?.userId ?? 0
        vc.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func addReplyAction(_ sender: Any) {
        let vc = UIStoryboard(name: CATEGORRY_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: REPLY_VCID) as! ReplyAskViewController
        print(self.data.question?.id ?? 0)
        vc.id = self.data.question?.id ?? 0
        self.present(vc, animated: false, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AskRepliesViewController{
func getData(){
        CategoryController.shared.getAsksReply(completion: {
            commentReply, check, msg in
            if check == 0{

                self.data = commentReply
                self.setData()

                self.lst.reloadData()
            }else{
                self.data = commentReply
                self.lst.reloadData()
                StaticFunctions.createErrorAlert(msg: msg)
                
            }
            
            
        }, id: data.question?.id ?? 0)
    }
   func setData(){
            self.img_user.setImageWithLoading(url: data.question?.userPic ?? "users/1675802939.png")
            self.askImageView.setImageWithLoading(url: data.question?.userPic ?? "users/1675802939.png")

        self.lbl_name.text = (data.question?.name ?? "") + " " + (data.question?.lastName ?? "")
//        self.lbl_date.text = data.comment?.createdAt?.formattedDateSince
            self.lbl_comment.text = data.question?.quest
       self.lbl_comment.sizeToFit()
      

    }
}
extension AskRepliesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.comment?.data.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CommentReplyTableViewCell
        cell.setData(reply: data.comment?.data[indexPath.row] ?? Comment())
        
        cell.removeBtclosure = {
            self.deleteReply(id: self.data.comment?.data[indexPath.row].id ?? 0)
        }
        
        cell.replyBtclosure = {
            let vc = UIStoryboard(name: CATEGORRY_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: REPLY_VCID) as! ReplyAskViewController
            print(self.data.question?.id ?? 0)
            vc.id = self.data.question?.id ?? 0
            self.present(vc, animated: false, completion: nil)
            
        }
        cell.flagBtclosure = {
            let vc = UIStoryboard(name: CATEGORRY_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: REPORT_REPLY_VCID) as! ReportAskReplyViewController
            vc.id = self.data.comment?.data[indexPath.row].id ?? 0
            self.present(vc, animated: false, completion: nil)
            
        }
        cell.showUserProfileBtclosure = {
            let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: OTHER_USER_PROFILE_VCID) as! OtherUserProfileVC
            vc.OtherUserId = self.data.comment?.data[indexPath.row].userId ?? 0
            vc.navigationController?.navigationBar.isHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.likeBtclosure  = {
            CategoryController.shared.likeAskReply(completion: {
                check, msg in
                if check == 0{
                    
                    
                    
                    var isLike =  self.data.comment?.data[indexPath.row].isLike == 1 ? 0 : 1
                    
                    self.data.comment?.data[indexPath.row].isLike = isLike
                    if self.data.comment?.data[indexPath.row].isLike == 1{
                        self.data.comment?.data[indexPath.row].countLike! += 1
                        cell.likeImage.image = UIImage(named: "heartFill")
                    }else{
                        self.data.comment?.data[indexPath.row].countLike! += -1
                        cell.likeImage.image = UIImage(named: "heartgrey")
                    }
                    cell.favCountLbl.text = "\(self.data.comment?.data[indexPath.row].countLike ?? 0)"

                }else{
                    StaticFunctions.createErrorAlert(msg: msg)

                }
            }, id:  self.data.comment?.data[indexPath.row].id ?? 0)
        }
        return cell
    }
    
    func deleteReply(id: Int){
        CategoryController.shared.deleteAskReply(completion: {
            check, msg in
            if check == 0{
                StaticFunctions.createSuccessAlert(msg: msg)

                self.getData()
            }else{
                StaticFunctions.createErrorAlert(msg: msg)

            }
        }, id:  id)
    }
}
