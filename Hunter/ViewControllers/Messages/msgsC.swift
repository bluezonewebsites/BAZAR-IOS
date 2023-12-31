
//
//  homeC.swift
//  Bazar
//
//  Created by khaled on 1/16/21.
//  Copyright © 2021 roll. All rights reserved.
//

import UIKit
import Alamofire
import M13Checkbox

class msgsC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource{
    @IBOutlet weak var hdr: UIView!
    
    var cids = [String]()
    var crids = [String]()
    var cimgs = [String]()
    var cnames = [String]()
    var cmsgs = [String]()
    var cdates = [String]()
    var ccounts = [String]()
    var cuser_make_block = [String]()
    var cselected = [Bool]()
    var cshow_check = [Int]()
    var roomsData = [RoomsDataModel]()
    
    @IBOutlet weak var lst: UICollectionView!
    
    @IBOutlet weak var noMessagesView: UIView!
    
    @IBOutlet weak var selectAndDeleteViewContainer: UIView!
    //secondery header
    @IBOutlet weak var lbl_del: UILabel!
    @IBOutlet weak var img_del: UIImageView!
    @IBOutlet weak var btn_del: UIButton!
    @IBOutlet weak var btn_select: UIButton!
    @IBOutlet weak var select_allv: UIView!
    @IBOutlet weak var chk_select_all: M13Checkbox!
    @IBAction func go_select() {
        if roomsData.count != 0{
            if btn_select.titleLabel?.text == "Select".localize{
//                txtBtn(btn_select,"إلغاء")
                btn_select.setTitle("Cancel".localize, for: .normal)
                btn_del.isUserInteractionEnabled = true
//                StaticFunctions.setTextColor(lbl_del, UIColor(named: "#0093F5"))
                lbl_del.textColor = UIColor.gray
//                StaticFunctions.setTextColor(lbl_del, UIColor(named: "#0093F5"))
                StaticFunctions.setImageFromAssets(img_del, "icons-trash")
//                img_del.image = UIImage(named: "delete_chat")?.withRenderingMode(.alwaysTemplate)
//                showV(v: [select_allv])
                select_allv.isHidden = false
                toggle_show_chk(1)
            }else{
                reset()
            }
        }else{
//              msg("لا توجد محادثات","msg")
            StaticFunctions.createSuccessAlert(msg: "لا توجد محادثات")
        }
    }
    
    func reset(){
        chk_select_all.checkState = .unchecked
//        txtBtn(btn_select,"تحديد")
        btn_select.setTitle("Select".localize, for: .normal)
        btn_del.isUserInteractionEnabled = false
//        setTxtColor(lbl_del, colors.gray2_hash)
        StaticFunctions.setTextColor(lbl_del, UIColor.gray)
//        simg(img_del, "del_gray")
        StaticFunctions.setImageFromAssets(img_del, "icons-trash")
//        hideV(v: [select_allv])
        select_allv.isHidden = true
        toggle_show_chk(0)
        toggle_selection(false)
    }
    
    func toggle_show_chk(_ val:Int){
        if roomsData.count != 0{
            for i in 0...roomsData.count-1{
                cshow_check[i] = val
            }
            lst.reloadData()
        }else {
          //  msg("لا توجد اشعارات","msg")
        }
        
        
    }
    
    func toggle_selection(_ val:Bool){
        for i in 0...cselected.count-1{
            cselected[i] = val
        }
        lst.reloadData()
    }
    
    
    @IBAction func go_del() {
        if cselected.count != 0 {
        var ids = [String]()
        var id = "0"
        for  i in 0...cselected.count-1{
            if(cselected[i]){
                if let roomId = roomsData[i].id {
                    ids.append("\(roomId)")
                    id = "\(roomId)"
                }
                
            }
        }
        if(ids.count == 0){
//            msg("لم تقم بتحديد اي محادثة");
            StaticFunctions.createErrorAlert(msg: "You did not select any conversation".localize)
        }else{
            var endPointURL = ""
            print("ids\(ids)")
//            BG.load(self)
            var params : [String: Any]  = ["uid":AppDelegate.currentUser.id]
            if ids.count > 1 {
                endPointURL = "del_multi_room"
                for i in 0...ids.count-1 {
                    params["room_id[\(i)]"] = "\(ids[i])"
                }
            }else{
                endPointURL = "destroy_room"
                params["room_id"] = "\(id)"
            }
            print("prameters",params)
            guard let url = URL(string: Constants.DOMAIN+endPointURL)else {return}
            AF.request(url, method: .post, parameters: params, encoding:URLEncoding.httpBody).responseDecodable(of:SuccessModel.self){ res in
                switch res.result {
                    
                case .success(let data):
                    print(data)
                    if let message = data.message {
                        if message.contains("تم حذف  ينجاح"){
//                            self.msg(message,"msg")
                            StaticFunctions.createSuccessAlert(msg: message)
                            self.reset()
                            self.selectAndDeleteViewContainer.isHidden = true
                            self.get()
                            
                        }else{
//                            self.msg(message,"msg")
                            StaticFunctions.createErrorAlert(msg: message)
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                }
            }
         
        }
        }else{
//            self.msg("لا توجد محادثات لحذفها" ,"msg")
            StaticFunctions.createErrorAlert(msg: "There are no conversations to delete".localize)
        }
    }
    
    @IBAction func checkboxValueChanged(_ sender: M13Checkbox) {
        switch sender.checkState {
        case .unchecked:
            toggle_selection(false)
        case .checked:
            toggle_selection(true)
        case .mixed:
            print("mixed")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navigationBar = navigationController?.navigationBar {
                    navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Change the color to your desired color
                }
        self.title = "Messages".localize
        navigationController?.navigationBar.tintColor = .white
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        noMessagesView.isHidden = true
      
        navigationController?.navigationBar.isHidden = false
        if !StaticFunctions.isLogin(){
            basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
            
        }
        lst.backgroundColor = UIColor.clear.withAlphaComponent(0)
        selectAndDeleteViewContainer.isHidden = true
        //chk_select_all
        chk_select_all.markType = .checkmark
        chk_select_all.boxType = .square
        chk_select_all.boxLineWidth = 2
        chk_select_all.checkmarkLineWidth = 2
        chk_select_all.secondaryTintColor = UIColor(named: "#0093F5")
        chk_select_all.secondaryCheckmarkTintColor = UIColor.white
        chk_select_all.tintColor = UIColor(named: "#0093F5")
        chk_select_all.stateChangeAnimation = .bounce(.fill)
//        self.title = "Messages".localize
    
//        get()
    }
    

    
    func clear_all(){
        cids.removeAll()
        crids.removeAll()
        cimgs.removeAll()
        cnames.removeAll()
        cmsgs.removeAll()
        cdates.removeAll()
        ccounts.removeAll()
        cuser_make_block.removeAll()
        cselected.removeAll()
        cshow_check.removeAll()
        roomsData.removeAll()
        lst.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //selectAndDeleteStckView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        get()
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        if !StaticFunctions.isLogin(){
            basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
        }
        if roomsData.count == 0 {
            selectAndDeleteViewContainer.isHidden = true
        }else {
            selectAndDeleteViewContainer.isHidden = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
    }
    
    
    func get(){
        clear_all()
//        BG.load(self)
      //  let params : [String: Any]  = ["uid":user.id]
    //let headerTest = headerProd:HTTPHeaders = ["Authorization":"Bearer \(user.accessToken)"]
       // selectAndDeleteStckView.isHidden = true
        guard let url = URL(string: Constants.DOMAIN+"get_rooms")else{return}
        print(" ========> ",Constants.headerProd)
        print(AppDelegate.currentUser.toke ?? "")
        AF.request(url, method: .post, headers: Constants.headerProd).responseDecodable(of:AllRoomsSuccessModel.self){ [weak self] res in
            guard let self = self else {return}
//            BG.hide(self)
           
            print(res)
            switch res.result {
            case .success(let data):
                if let data = data.data {
                    print(data)
                    self.roomsData = data.reversed()
                    if data.count > 0 {
                            DispatchQueue.main.async {
                                self.selectAndDeleteViewContainer.isHidden = false
                                self.noMessagesView.isHidden = true
                        }
                       
                    }
                    for _ in 0..<data.count{
                        self.cshow_check.append(0)
                        self.cselected.append(false)
                    }
                    
                }
                DispatchQueue.main.async {
                    self.lst.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            
        }

    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
//        guard let count = roomsData.count else {return Int()}
        print(roomsData.count)
        return roomsData.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let inx = indexPath.row
        let cell = lst.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! roomCell
         if roomsData[indexPath.row].messages?.sid == AppDelegate.currentUser.id {
             lst.contentMode = .right
         }else {
             lst.contentMode = .left
         }
         
        if roomsData[inx].user?.count != 0{
            if  let userName = roomsData[inx].user?[0].name  {
                
                cell.name.text = userName
            }
            cell.img.setImageWithLoading(url: roomsData[inx].user?[0].pic ?? "",placeholder: "logo_photo")
        }else{
            cell.name.text = "User"
            cell.img.image = UIImage(named: "logo_photo")
        }
        
        //let pic = roomsData[inx].user?[inx].pic
        
//        cell.img.imgUrl = roomsData[inx].user?[inx].pic ?? ""
//        cell.name.text = roomsData[inx].user?[inx].username
        
        if(roomsData[inx].messages?.mtype == "TEXT"){
            cell.last_msg.text = roomsData[inx].messages?.msg
        }else{
            self.cmsgs.append("تم ارسال مرفق")
            cell.last_msg.text = cmsgs[0]

        }
        if let count = roomsData[inx].unseenCount {
            cell.count.text = "\(count)"
        }
        
         if let date = roomsData[inx].messages?.date {
//            cell.since.text = diffDates(GetDateFromString(date)).replace("-", "")
             
             let dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
             dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

             let pastDate = dateFormatter.date(from:date ) ?? Date()
             
             cell.since.text = pastDate.timeAgoDisplay()
             
             
        }
        
        if(roomsData[inx].unseenCount == 0){
//            setBgColor(cell.count, "#ffffff")
            cell.count.backgroundColor = UIColor.white
        }else{
            cell.count.backgroundColor = UIColor(hexString: "#444A50")
//            setBgColor(cell.count, "#444A50")
        }
        
        if(cshow_check[inx] == 1){
            cell.chk_width.constant = 44
            print(cshow_check[inx])
        }else{
            cell.chk_width.constant = 13
        }
        
        if(cselected[inx]){
            cell.chk.checkState = .checked
        }else{
            cell.chk.checkState = .unchecked
        }
        
        cell.chk.tag = inx
        cell.chk.addTarget(self, action: #selector(cellCheckboxValueChanged), for: .valueChanged)
        
        cell.shadow(1, 0.03)
        cell.last_msg.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 1.5)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: lst.frame.width - 30, height: 90)
    }
    
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let inx = indexPath.row
        if let roomId = roomsData[inx].id {
            receiver.room_id = "\(roomId)"
            Constants.room_id = "\(roomId)"
        }
         if roomsData[inx].user?.count != 0 {
             if let receiverName = roomsData[inx].user?[0].name{
                 receiver.name = receiverName
                 Constants.otherUserName = receiverName
                 print(receiverName)
             }
             if let receiverId = roomsData[inx].user2{
                 receiver.id = "\(receiverId)"
                 
                 if receiverId == AppDelegate.currentUser.id ?? 0 {
                     guard let id = roomsData[inx].user1 else {return}
                     Constants.userOtherId = "\(id)"
                     Constants.otherUserIsStore = roomsData[inx].user?[0].isStore ?? false
                 }else{
                     Constants.userOtherId = "\(receiverId)"
                     Constants.otherUserIsStore = roomsData[inx].user?[0].isStore ?? false
                 }
                     
             }
             if let receiverPic = roomsData[inx].user?[0].pic {
                 Constants.otherUserPic = receiverPic
             }
     //        goNav("chatv","Chat")
             //Goto Chat
             let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
             vc.modalPresentationStyle = .fullScreen
//             present(vc, animated: true)
             navigationController?.pushViewController(vc, animated: true)
             
         }else {
//             self.msg(" لم يعد بإمكانك التحدث مع هذا المستخدم تم حذف بياناتة من بازار ","msg")
             StaticFunctions.createErrorAlert(msg: " لم يعد بإمكانك التحدث مع هذا المستخدم تم حذف بياناتة من بازار ")
         }
        
        //receiver.name = cnames[inx]
       // receiver.id = crids[inx]
       // user.other_id = crids[inx]
//        order.room_id = cids[inx]
      //  user.otherUserPic = cimgs[inx]
      //  user.otherUserName = cnames[inx]
       
    }
    
    @objc func cellCheckboxValueChanged(_ sender: M13Checkbox) {
        let inx = sender.tag
        switch sender.checkState {
        case .unchecked:
            cselected[inx] = false
            
        case .checked:
            cselected[inx] = true
            
        case .mixed:
            print("")
            
        }
    }
}
