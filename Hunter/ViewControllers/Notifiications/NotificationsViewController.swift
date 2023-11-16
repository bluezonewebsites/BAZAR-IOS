//
//  NotificationsViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 25/05/2023.
//

import UIKit
import M13Checkbox

class NotificationsViewController: UIViewController {
    var notiiifications = [UserNotification]()
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var checkBoxValueChanged: M13Checkbox!
    @IBOutlet weak var selectAllView: UIView!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var deleteImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    //    let cellSpacingHeight: CGFloat = 8
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        if let navigationBar = navigationController?.navigationBar {
                    navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Change the color to your desired color
                }
        self.title = "Notifications".localize
        navigationController?.navigationBar.tintColor = .white
        if !StaticFunctions.isLogin(){
            basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
        }
        self.navigationController?.navigationBar.isHidden = false
        
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)

    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)

        if !StaticFunctions.isLogin(){
            basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
            
        }
        else{
            
            getData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        deleteNotifications()
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
extension NotificationsViewController{
    func getData(){
        NotificationsController.shared.getNotifications(completion: {
            notifications, check, msg in
            
            self.notiiifications = notifications
            self.tableView.reloadData()
            if check == 1{
                StaticFunctions.createErrorAlert(msg: msg)
            }
        })
    }
    func deleteNotifications(){
        NotificationsController.shared.deleteNotifications(completion: {
            check, msg in
            if check == 0{
                self.notiiifications.removeAll()
                self.tableView.reloadData()
                StaticFunctions.createSuccessAlert(msg: msg)
                
            }
            else{
                StaticFunctions.createErrorAlert(msg: msg)
            }
        })
    }
}
extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notiiifications.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationTableViewCell
        cell.setData(userNotification: notiiifications[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        if let notificatinSenderId = notiiifications[index].oid {
            switch notiiifications[index].ntype {
            case "ASK_REPLY" , "LIKE_REPLY_Questions":
                
                let vc = UIStoryboard(name: CATEGORRY_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COMMENT_REPLY_VCID ) as! AskRepliesViewController
                vc.data.question = Ask()
                vc.data.question?.id = notificatinSenderId
                self.navigationController?.pushViewController(vc, animated: true)
                print("ASK_REPLY")
            case "REPLY_COMMENT" , "LIKE_REPLY":
                print("REPLY_COMMENT")
                let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COMMENT_REPLY_VCID) as! CommentRepliesViewController
                vc.data.comment = Comment()
                vc.data.comment?.id = notificatinSenderId
                self.navigationController?.pushViewController(vc, animated: true)
            case "COMMENT_ADV":
                print("COMMENT_ADV")
                let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PRODUCT_VCID) as! ProductViewController
                vc.product.id = notificatinSenderId
                self.navigationController?.pushViewController(vc, animated: true)
            case "ADD_ADV":
                let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PRODUCT_VCID) as! ProductViewController
                vc.product.id = notificatinSenderId
                self.navigationController?.pushViewController(vc, animated: true)
                print("ADD_ADV")
            case "LIKE_COMMENT":
                let vc = UIStoryboard(name: PRODUCT_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PRODUCT_VCID) as! ProductViewController
                vc.product.id = notificatinSenderId
                self.navigationController?.pushViewController(vc, animated: true)
                print("LIKE_COMMENT")
            case "FOLLOW":
                let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: OTHER_USER_PROFILE_VCID) as! OtherUserProfileVC
                vc.navigationController?.navigationBar.isHidden = true
                vc.OtherUserId = notificatinSenderId
                self.navigationController?.pushViewController(vc, animated: true)
                print("FOLLOW")
            case "CHAT":
                //
                print(receiver.room_id)
                receiver.room_id = "\(notificatinSenderId)"
                print(receiver.room_id)
                
                
                if notiiifications[index].userf?.count != 0 {
                    if let userName = notiiifications[index].userf?[0].username , let userPic =  notiiifications[index].userf?[0].pic , let userId = notiiifications[index].userf?[0].id {
                        Constants.userOtherId = "\(userId)"
                        Constants.otherUserPic = userPic
                        Constants.otherUserIsStore = notiiifications[index].userf?[0].isStore ?? false
                        Constants.otherUserName = userName
                    }
                    basicNavigation(storyName: "Chat", segueId: "ChatVC")
                    
                    //                        goNav("chatv","Chat")
                    print("CHAT")
                }else {
                    // let userId = data[index].userf?[0].id
                    StaticFunctions.createErrorAlert(msg: "this is a deleted user")
                }
            default:
                print(notiiifications[index].ntype)
            }
        }
    }
}
