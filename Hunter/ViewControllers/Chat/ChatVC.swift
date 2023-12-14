//
//  ChatVC.swift
//  Bazar
//
//  Created by iOSayed on 29/05/2023.


import UIKit
import Alamofire
//import NextGrowingTextView
import LSDialogViewController
import Zoomy
import NVActivityIndicatorView
import ContactsUI
import MobileCoreServices
import UniformTypeIdentifiers
import AVFoundation
import Foundation
import iRecordView
import PhotosUI


@available(iOS 14.0, *)
class ChatVC: ViewController,UITableViewDataSource,UITableViewDelegate,
             UIImagePickerControllerDelegate,
             UINavigationControllerDelegate,
             UIColorPickerViewControllerDelegate,
             CNContactPickerDelegate,
             UIDocumentPickerDelegate, RecordViewDelegate, AVAudioRecorderDelegate  ,UITextFieldDelegate{
    
    let plusIcon = UIImage(named: "plusImage")
    let sendIcon = UIImage(named: "sendd")
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // This method is called whenever the text field's content changes
        // Update the button's icon based on the text field's content

        if let currentText = textField.text, let range = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            sendMessageButton.setImage(updatedText.isEmpty ? plusIcon : sendIcon, for: .normal)
        } else {
            sendMessageButton.setImage(plusIcon, for: .normal)
        }

        return true
    }

    
    
    //Timer
    var timer: Timer!
    func setTimerTask(selector:Selector){
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: selector, userInfo: nil, repeats: true)
        
    }
    
    func stopTimer(){
        func stopcheck(){
            if timer != nil {
                timer.invalidate()
                timer = nil
            }
            print("stopped")
        }
    }
    
    func onStart() {
        print("onStart")
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func onCancel() {
        audioRecorder = nil
        timer?.invalidate()
        timer = nil
        self.dismiss(animated: true)
        print("onCancel")
    }
    
    func onFinished(duration: CGFloat) {
        print("onFinished \(duration)")
        finishRecording(success: true)
        
    }
    func onAnimationEnd() {
       //when Trash Animation is Finished
       print("onAnimationEnd")
       }
    
    //RECORD
    
    weak var delegate:RecordVoiceVCDelegate?
    var audioDuration = 0
    var counter = 0
  //  var timer:Timer?
    
    @IBOutlet weak var tableViewContainerView: UIView!
    @IBOutlet weak var containerViewSendView: UIView!
    @IBOutlet weak var sendView: UIView!
    var recordingSession: AVAudioSession? = AVAudioSession()
    var audioRecorder: AVAudioRecorder? = AVAudioRecorder()
  //  var audioPlayer:AVAudioPlayer!
    var audioPlayer:AVPlayer!
    var audioUrl:URL?
    
    var player: AVAudioPlayer?
    
    var recordButton = RecordButton()
    
    @IBOutlet weak var lst: UITableView!
  //  var data = ChatMessage(msgs: [Message](), receiver: nil, room: nil)
    var data = [Result]()
    
    @IBOutlet weak var bottomSendViewConstraint: NSLayoutConstraint!
    @IBOutlet var stackViewCollection: [UIStackView]!
    
    @IBOutlet weak var sendMessageButton: UIButton!
    
    @IBOutlet weak var confirmMessageLabel: UILabel!
    
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txt_msg: UITextField!
    
    @IBOutlet weak var bottomConstraintsForTextFeild: NSLayoutConstraint!
    @IBOutlet weak var otherUserImage: UIImageView!
    
    @IBOutlet weak var otherUserName: UILabel!
    
    @IBOutlet weak var chatHeaderView: UIView!
    
    
    @IBOutlet weak var overlay: UIView!
    
    
    // Chat Dialog
    
    @IBOutlet weak var confirmDialogConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dialogChatBottomConstraint: NSLayoutConstraint!
    
    //report on chat
    
    @IBOutlet weak var reportTextFeild: UITextField!
    
    
    @IBOutlet weak var reportOnChatBottomConstraint: NSLayoutConstraint!
    
    var audioIsPlaying = false
    var isDelete = false
    //MARK:  Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navigationBar = navigationController?.navigationBar {
                    navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Change the color to your desired color
                }
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        handelRecordPermission()
        Constants.orderLoc_represnted = false
        lbl_title.text = "Messages".localize
        confirmMessageLabel.text = ""
        self.txt_msg.delegate = self
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismisKeyboard))
             //  view.addGestureRecognizer(tapGesture)
//        txt_msg.addTarget(self, action: #selector(handleSendButton), for: .editingChanged)
        
        setUpChatHeaderView()
        closeChatOptionsMenu()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        
        
        //lst msgs
        lst.backgroundColor = UIColor.clear.withAlphaComponent(0)
        lst.registerCell(cell: MsgCell.self)
        lst.registerCell(cell: MsgColorCell.self)
        lst.registerCell(cell: MsgMapCell.self)
        lst.registerCell(cell: MsgMediaCell.self)
        lst.registerCell(cell: MsgContactCell.self)
        lst.registerCell(cell: MsgFileCell.self)
        lst.registerCell(cell: MsgRecordCell.self)
        lst.registerCell(cell: MsgCellForReceiver.self)
        lst.registerCell(cell: MsgContactSenderCell.self)
        lst.registerCell(cell: MsgMediaCellReciver.self)
        lst.registerCell(cell: MsgMapRecieverCell.self)
        lst.registerCell(cell: MsgRecordRecieverCell.self)
//        lst.register(UINib(nibName: "MsgCellForSender", bundle: nil), forCellReuseIdentifier: "MsgCellForSender")
        lst.rowHeight = UITableView.automaticDimension
        lst.estimatedRowHeight = 50
        
        lst.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
     
        lst.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        //record
        isAuth()

        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openOtherProfileUser))
        otherUserImage.isUserInteractionEnabled = true
        otherUserImage.addGestureRecognizer(gesture)
        
        get()
        
        setupRecordButton()
    }
    
    @objc func dismisKeyboard() {
            view.endEditing(true)
        }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = (view.frame.height - keyboardFrame.minY) - 35

        UIView.animate(withDuration: 0.3) {
            if keyboardHeight > 0 {
                self.sendView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
                self.tableViewContainerView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            } else {
                self.sendView.transform = .identity
                self.tableViewContainerView.transform = .identity
            }
        }
    }
    
   

    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func setupRecordButton(){
       
        recordButton.translatesAutoresizingMaskIntoConstraints = false

        let recordView = RecordView()
        recordView.translatesAutoresizingMaskIntoConstraints = false
        sendView.addSubview(recordButton)
        sendView.addSubview(recordView)

        recordButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        recordButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        recordButton.leadingAnchor.constraint(equalTo: sendView.leadingAnchor, constant: -2).isActive = true
        recordButton.bottomAnchor.constraint(equalTo: sendView.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true


        recordView.trailingAnchor.constraint(equalTo: recordButton.leadingAnchor, constant: -4).isActive = true
        recordView.leadingAnchor.constraint(equalTo: sendView.leadingAnchor, constant: 10).isActive = true
        recordView.bottomAnchor.constraint(equalTo: recordButton.bottomAnchor).isActive = true
//
        //IMPORTANT
        recordButton.recordView = recordView
        recordView.delegate = self
    }
    
    
    @objc func handleSendButton(){
        
        if !txt_msg.text!.isEmpty {
            sendMessageButton.setImage(UIImage(named: "sendd"), for: .normal)
        }
        else {
    
            StaticFunctions.createErrorAlert(msg: "Please type any text to send".localize)
//            sendMessageButton.setImage(UIImage(named:"plusImage"), for: .normal)
        }
    }
    
    @objc func openOtherProfileUser (){
//        user.other_id = user.other_id
//        goNav("otherProfilev","Profile")
        if Constants.otherUserIsStore ?? false {
            let storeProfile = StoreProfileVC.instantiate()
            storeProfile.otherUserId = Int(Constants.userOtherId) ?? 0
            navigationController?.pushViewController(storeProfile, animated: true)
        }else {
            let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: OTHER_USER_PROFILE_VCID) as! OtherUserProfileVC
            vc.OtherUserId = Int(Constants.userOtherId) ?? 0
    //        present(vc, animated: true)
    //        presentDetail(vc)
            navigationController?.pushViewController(vc, animated: true)
        }
      
    }
    
    
    @IBAction func hideOverLayClicked(_ sender: UIButton) {
        closeChatOptionsMenu()
        hideDialog()
        hideConfirmOptions()
        hidereportOnChat()
    }
    
    fileprivate func closeChatOptionsMenu(){
        
        stackViewCollection.forEach { stackView in
            UIView.animate(withDuration: 0.7) {
                stackView.isHidden = true
                stackView.alpha = 0
                self.hideV(v: [self.overlay])
            }
        }
       
    }
    
    fileprivate func setUpChatHeaderView(){
        otherUserImage.setImageWithLoading(url: Constants.otherUserPic,placeholder: "logo_photo")
        otherUserName.text = Constants.otherUserName
        otherUserImage.layer.cornerRadius = otherUserImage.frame.width / 2
        chatHeaderView.layer.shadowColor = UIColor.gray.cgColor
        chatHeaderView.layer.shadowOpacity = 0.7
        chatHeaderView.layer.shadowOffset = .zero
        chatHeaderView.layer.shadowRadius = 10
        otherUserImage.layer.cornerRadius = 25
        otherUserImage.clipsToBounds = true
        otherUserImage.layer.masksToBounds = true
        chatHeaderView.clipsToBounds = true
    }
    
    //MARK: Options Menu
    
    func showConfirmOptions(){
        showV(v: [overlay])
        confirmDialogConstraint.constant = 70
        animate_event()
    }
    func hideConfirmOptions(){
        hideV(v: [overlay])
        confirmDialogConstraint.constant = -470
        animate_event()
    }
    
    @IBAction func ConfirmBlockDeleteChat(_ sender: UIButton) {
        if isDelete {
            let params : [String: Any]  = ["uid":AppDelegate.currentUser.id ?? 0 ,
                                           "room_id":Constants.room_id]
            print("delete room id Params ", params)
            guard let url = URL(string: Constants.DOMAIN+"destroy_room")else{return}
            AF.request(url, method: .post, parameters: params).responseDecodable(of:SuccessModel.self){res in
                switch res.result {
                case .success(let data):
                    if let  message = data.message {
                        if message.contains("تم حذف  ينجاح"){
                            StaticFunctions.createSuccessAlert(msg: "لقد قمت بحذف المحادثة بنجاح ")
                            self.hideConfirmOptions()
                            self.navigationController?.popViewController(animated: true)
                        }else {
                            StaticFunctions.createErrorAlert(msg: message)
                        }
                    }
                   
                case .failure(let error):
                    print(error)
                }
            }


        }else {
            let params : [String: Any]  = ["uid":AppDelegate.currentUser.id ?? 0,
                                           "room_id":Constants.room_id]
            guard let url = URL(string: Constants.DOMAIN+"block_room")else{return}
            print("block room id Params ", params)
            AF.request(url, method: .post, parameters: params).responseDecodable(of:SuccessModel.self){res in
                switch res.result {
                case .success(let data):
                    if let success = data.success, let  message = data.message {
                        if success{
                            StaticFunctions.createSuccessAlert(msg: message)
//                            self.msg(message,"msg")
                            self.hideConfirmOptions()
                            self.navigationController?.popViewController(animated: true)
                        }else {
                            StaticFunctions.createErrorAlert(msg: message)
                          //  self.msg(message,"msg")
                            self.hideConfirmOptions()
                        }
                    }
                   
                case .failure(let error):
                    print(error)
                }
            }

        }
       
    }
    @IBAction func closeDialogClicked(_ sender: UIButton) {
        print("Close Dialoge")
        closeChatOptionsMenu()
    }
    
    
    @IBAction func deleteChatClicked(_ sender: UIButton) {
        print("deleteChatClicked")
        isDelete = true
        self.confirmMessageLabel.text =  "Are you sure you want to Delete this Chat?".localize
        closeChatOptionsMenu()
        showConfirmOptions()

    }
    
    
    @IBAction func reportAboutChatClicked(_ sender: UIButton) {
        print("reportAboutChatClicked")
        closeChatOptionsMenu()
        showreportOnChat()
        
    }
    
    
    @IBAction func blockChatClicked(_ sender: UIButton) {
        isDelete = false
        self.confirmMessageLabel.text = "Are you sure you want to block?".localize
        closeChatOptionsMenu()
        showConfirmOptions()
    }
    
    // MARK: Dialog Attachment
    
    func showDialog(){
        showV(v: [overlay])
        dialogChatBottomConstraint.constant = 70
        animate_event()
    }
    func hideDialog(){
        hideV(v: [overlay])
        dialogChatBottomConstraint.constant = -470
        animate_event()
    }
    
    @IBAction func sendPhotoClicked(_ sender: UIButton) {
        openGallery()
        hideDialog()
        print("sendPhotoClicked")
    }
    
    @IBAction func sendVideoClicked(_ sender: UIButton) {
        openVideoGallery()
        hideDialog()
        print("sendVideoClicked")
    }
    
    @IBAction func sendLocationClicked(_ sender: UIButton) {
        go_map()
        hideDialog()
        print("sendLocationClicked")

        
    }
    
    @IBAction func sendContactClicked(_ sender: Any) {
        pickContact()
        hideDialog()
        print("sendContactClicked")
    }
    
    @IBAction func cancelDialog(_ sender: UIButton) {
        print("cancelDialog")
        hideDialog()
    }
    
    func get(){
        
        let params : [String: Any]  = ["room_id":receiver.room_id]
        guard let url = URL(string: Constants.DOMAIN+"chat_by_room")else{return}
        print(params)
        AF.request(url, method: .post, parameters: params,headers: Constants.headerProd)
            .responseDecodable(of: ChatMessage.self) { e in
                print(e)
                self.hideV(v: [self.overlay])
                switch e.result {
                case let .success(data):
                    if let receiverId = data.data?.receiver?.id {
                        receiver.id = "\(receiverId)"
                        print("receiver id",receiverId)
                    }
                    
                    if let result = data.data?.result{
                        self.data = result
                        for i in self.data{
                            if let roomId = i.roomID {
                                Constants.room_id = "\(roomId)"
                               
            //  receiver.id = self.data.receiver!.id
                              //  receiver.id = "\(receiverId)"
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.lst.reloadData()
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
    }
    
    
    //report on Chat
    func showreportOnChat(){
        showV(v: [overlay])
        reportOnChatBottomConstraint.constant = 70
        animate_event()
    }
    func hidereportOnChat(){
        hideV(v: [overlay])
        reportOnChatBottomConstraint.constant = -470
        animate_event()
    }
    
    @IBAction func reportOnChat(_ sender: UIButton) {
        if !reportTextFeild.text!.isEmpty {
            guard let url = URL(string: Constants.DOMAIN+"report_room") , let reason = reportTextFeild.text else{return}
            let params : [String: Any]  = [
                                           "room_id":Constants.room_id, "reason":reason]
            print("report chat Params ", params)
            AF.request(url, method: .post, parameters: params,headers: Constants.headerProd).responseDecodable(of:SuccessModel.self){res in
                switch res.result{
                    
                case .success(let data):
                    if let success = data.success , let message = data.message{
                       if success {
//                           self.msg("تم ارسال إبلاغك عن المحادثة للإدارة","msg")
                           StaticFunctions.createSuccessAlert(msg: "we received your report".localize)
                       }else{
                           StaticFunctions.createErrorAlert(msg: message)
//                           self.msg(message)
                       }
                    }


                case .failure(let error):
                    print(error)
                }
                
            }
//                .responseString { (e) in
//                    if let res = e.value {
//                        print(res)
//                        if(res.contains("true")){
//                            self.msg("تم ارسال إبلاغك عن المحادثة للإدارة","ok")
//                            self.hidereportOnChat()
//                        } else {
//                            self.msg("توجد مشكلة")
//                        }
//                    }
//                }
        }else {
            StaticFunctions.createErrorAlert(msg: "reason for reporting this chat".localize)
//                self.msg("من فضلك أدخل سبب الابلاغ عن المحادثة")
        }
    }
    
    @IBAction func cancelReporrtOnchat(_ sender: UIButton) {
        hidereportOnChat()
    }
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inx = indexPath.row
        var cell = MsgGlobalCell()
        let msgType = data[inx].mtype
        if msgType == "TEXT" {
            if data[inx].rid ?? 0 == AppDelegate.currentUser.id ?? 0 {
                
                cell = tableView.dequeue(inx: indexPath) as MsgCell
            }else{
                cell = tableView.dequeue(inx: indexPath) as MsgCellForReceiver

            }
        }else if msgType == "COLOR" {
            cell = tableView.dequeue(inx: indexPath) as MsgColorCell
        }else if msgType == "LOCATION" {
           
            if data[inx].rid ?? 0 == AppDelegate.currentUser.id ?? 0 {
                cell = tableView.dequeue(inx: indexPath) as MsgMapCell
            }else{
                cell = tableView.dequeue(inx: indexPath) as MsgMapRecieverCell
            }
        }else if msgType == "IMAGE" || msgType == "VIDEO" {
           
            if data[inx].rid ?? 0 == AppDelegate.currentUser.id ?? 0 {
                cell = tableView.dequeue(inx: indexPath) as MsgMediaCell
            }else{
                cell = tableView.dequeue(inx: indexPath) as MsgMediaCellReciver
               
            }
            
        }else if msgType == "DOCUMENT" || msgType == "MUSIC" {
            cell = tableView.dequeue(inx: indexPath) as MsgFileCell
        }else if msgType == "AUDIO" {
         
            if data[inx].rid ?? 0 == AppDelegate.currentUser.id ?? 0 {
               
                cell = tableView.dequeue(inx: indexPath) as MsgRecordCell
                
                if  let cell = cell as? MsgRecordCell {
            cell.btn_play.tag = inx
                
                cell.btn_play.addTarget(self, action: #selector(go_play_record), for: .touchUpInside)
                }
            }else{
                cell = tableView.dequeue(inx: indexPath) as MsgRecordRecieverCell
                
                if  let cell = cell as? MsgRecordRecieverCell {
            cell.btn_play.tag = inx
                
                cell.btn_play.addTarget(self, action: #selector(go_play_record), for: .touchUpInside)
                }
            }
        }else if msgType == "CONTACT" {
            
            if data[inx].rid ?? 0 == AppDelegate.currentUser.id ?? 0 {
                cell = tableView.dequeue(inx: indexPath) as MsgContactCell
                
                let cell = cell as! MsgContactCell
                cell.btn_save.tag = inx
                cell.btn_save.addTarget(self, action: #selector(go_save_contact), for: .touchUpInside)
                cell.btn_call.tag = inx
                cell.btn_call.addTarget(self, action: #selector(go_call_contact), for: .touchUpInside)
            }else{
                cell = tableView.dequeue(inx: indexPath) as MsgContactSenderCell
                let cell = cell as! MsgContactSenderCell
                cell.btn_save.tag = inx
                cell.btn_save.addTarget(self, action: #selector(go_save_contact), for: .touchUpInside)
                cell.btn_call.tag = inx
                cell.btn_call.addTarget(self, action: #selector(go_call_contact), for: .touchUpInside)
                
            }
//            let cell = cell as! MsgContactCell
//            cell.btn_save.tag = inx
//            cell.btn_save.addTarget(self, action: #selector(go_save_contact), for: .touchUpInside)
//            cell.btn_call.tag = inx
//            cell.btn_call.addTarget(self, action: #selector(go_call_contact), for: .touchUpInside)
        }else{
            cell = tableView.dequeue(inx: indexPath) as MsgCell
        }
        cell.configure(data: data[inx])
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
    
    @objc func go_save_contact(_ sender:UIButton){
        
    }
    
    
    @objc func go_call_contact(_ sender:UIButton){
        if  let phone = data[sender.tag].msg?.components(separatedBy: "%%")[1] {
            goPhone(phone)
        }
    }
    
    @objc func go_play_record(_ sender:UIButton){
//        if let cell = lst.dequeueReusableCell(withIdentifier: "MsgRecordCell") as? MsgRecordCell {
//            cell.img.image = UIImage(named: "Pause")
//            delay(Double(audioDuration)) {
//                //cell.img.image = UIImage(named: "play_green_icon")
//            }
//        }
        if let url = data[sender.tag].image {
            print(data[sender.tag].image )
            playAudioFromURL("\(Constants.IMAGE_URL)\(url)")
            print(url)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inx = indexPath.row
        let msgType = data[inx].mtype
        guard let msgContent = data[inx].image , let msg = data[inx].msg  else{return}
        if msgType == "VIDEO" {
            play_video(url: "\(Constants.IMAGE_URL)\(msgContent)")
        }else if msgType == "IMAGE" {
            let zoomCtrl = VKImageZoom()
            zoomCtrl.image_url = URL.init(string: "\(Constants.IMAGE_URL)\(msgContent)")
            print("zoomCtrl.image_url ====> ",zoomCtrl.image_url , "\(Constants.IMAGE_URL)\(msgContent)")
            self.present(zoomCtrl, animated: true, completion: nil)
        }else if msgType == "LOCATION" {
            let locData = msg.components(separatedBy: "%%")
                goGMap(lat: Double(locData[0])!, lng: Double(locData[1])!)
           
        }else if msgType == "DOCUMENT" || msgType == "MUSIC" {
            gosite(url:"\(Constants.DOMAIN))\(msgContent)".replacingOccurrences(of: "http", with: "https"))
        }
    }
    
    
    
    @IBAction func chatOptionsClicked(_ sender: UIButton) {
        
        print("Show Side Menu")
        if data.count != 0 {
            showV(v: [overlay])
            animate_event()
            stackViewCollection.forEach { stackView in
                UIView.animate(withDuration: 0.7) {
                    stackView.isHidden = !stackView.isHidden
                    stackView.alpha = stackView.alpha == 0 ? 1 : 0
                    stackView.layoutIfNeeded()
                }
            }
        }else {
            StaticFunctions.createErrorAlert(msg: "لا يوجد شيء للإبلاغ عنه")
            
        }
       
    }
    
    
    @IBAction func go_back(_ sender: Any) {
//        dimissMe()
//        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func go_settings(_ sender: Any) {
        
    }
    
    @IBAction func send_msg(_ sender: Any) {
        if(!txt_msg.text!.isEmpty){
            sendMessage(txt_msg.text!, images: [Data()], msgType: "TEXT", filePath: URL(fileURLWithPath: ""))
        }else {
            self.sendMessageButton.setImage(UIImage(named: "plusImage"), for: .normal)
            self.dismisKeyboard()
            showDialog()
        }

    }
    
    @IBAction func attach_file(_ sender: Any) {
//        showDialog()
    }
    
    func open_attach_dialog() {
//       let attchC = attachC(nibName: "attachC", bundle: nil)
//        attchC.delegate = self
//        presentDialogViewController(attchC, animationPattern: .slideBottomTop)
        //showDialog()
        go_record()
    }
    
  
    
    func closeDialog(){
        dismissDialogViewController(.fadeInOut)
    }
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       //  textField.resignFirstResponder()
        if !textField.text!.isEmpty{
            //send_message(txt_msg.text!,"TEXT")
            sendMessage(txt_msg.text!, images: [Data()],msgType: "TEXT", filePath: URL(fileURLWithPath: ""))
        }
        return true
    }
    

    
    fileprivate func sendMessage(_ msg:String,images:[Data], msgType:String , filePath:URL) {
       // BG.load(self)
        
        guard let url = URL(string: Constants.DOMAIN+"send_message") else {return}
        
          var params : [String: Any]  = ["room_id":receiver.room_id,
                                         "reciver_id":receiver.id,
                                         "msg":msg,
                                         "mtype":msgType]
        
        print("Parameters of Edit profile",params)
        
        AF.upload(multipartFormData: {multipartFormData in
                if msgType.contains("IMAGE"){
                    //let imageData = image.jpegData(compressionQuality: 0.2)!
                   // params["mtype[]"] = msgType
                    for (index, image) in images.enumerated() {
                                
                                    multipartFormData.append(image, withName: "images[\(index)]",fileName: "image\(index).jpg", mimeType: "image/jpg")
                            }
//                    for image in images {
//                        let index = UUID().uuidString
//                        multipartFormData.append(image, withName: "images[]",fileName: "file\(index).jpg", mimeType: "image/jpg")
//                    }
                   
                }else if msgType.contains("VIDEO"){
                    //params["mtype[]"] = msgType
                    multipartFormData.append(images[0], withName: "images[]",fileName: "video.mp4", mimeType: "video/mp4")
                }else if msgType.contains("LOCATION"){
                    
                    multipartFormData.append(filePath, withName: "images[]")
                   // params["mtype[]"] = msgType
                }else if msgType.contains("AUDIO"){
                    guard let audioFile: Data = try? Data (contentsOf: filePath) else {return}
                    let fileName = filePath.lastPathComponent
                    multipartFormData.append(audioFile, withName: "images[]", fileName: fileName, mimeType: "audio/m4a")
                   // params["mtype[]"] = msgType
                }
            
             print(params)
            for (key,value) in params {
                multipartFormData.append((value as AnyObject).description.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:"\(url)",headers: Constants.headerProd )
        .responseDecodable(of:MessageSuccessfulModel.self){ response in
          //  BG.hide(self)
            print(response.value)
            switch response.result {
            case .success(let data):
                print(data)
                if let message = data.message{
                    if message.contains("تم إرجاع البيانات بنجاح") {
                        self.txt_msg.text = ""
                        self.sendMessageButton.setImage(self.plusIcon, for: .normal)
                        self.get()
                        
                    }else {
//                        self.msg(message)
                        StaticFunctions.createErrorAlert(msg: message)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }

    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            
            let imageData:Data = image.jpegData(compressionQuality: 0.2)!
            let img = UIImage(data: imageData)
          //  uploadMedia(img!)
            //sendMessage("image", image: imageData, msgType: "IMAGE", filePath: URL(fileURLWithPath: ""))
        }else{
            guard let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
                return
            }
            do {
                let data = try Data(contentsOf: videoUrl, options: .mappedIfSafe)
                print(videoUrl)
                var dataArray = [Data]()
                dataArray.append(data)
               // self.uploadMediaVideo(data)
                sendMessage("video", images: dataArray, msgType: "VIDEO", filePath: URL(fileURLWithPath: ""))
            } catch  {
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
    
    private func openGallery(){
        var config = PHPickerConfiguration()
        config.selectionLimit = 6
        if #available(iOS 15.0, *) {
            config.selection = .ordered
        } else {
            // Fallback on earlier versions
        }
        let PHPickerVC = PHPickerViewController(configuration: config)
        PHPickerVC.delegate = self
        present(PHPickerVC, animated: true)
        
    }
    
    func goGallary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func goCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openVideoGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.mediaTypes = ["public.movie"]
            imagePicker.videoMaximumDuration = 30
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func uploadMedia(_ img:UIImage){
//        BG.load(self)
        let imgData = img.jpegData(compressionQuality: 0.1)!
        let parameters = ["xxx": "xxx"]
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:"\(Constants.DOMAIN)upload.php")
            .responseString { (e) in
                if let res = e.value {
//                    BG.hide(self)
                    print("image upload: \(res)")
                    if(res == "fail"){
//                        self.msg("مشكلة في تحميل الصورة")
                    }else{
                      //  self.send_message(res,"IMAGE")
                    }
                }
            }
    }
    
    //=================================================//
    //====================== VIDEO ====================//
    //=================================================//
    func uploadMediaVideo(_ video:Data){
//        BG.load(self)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(video, withName: "image",fileName: "video.mp4", mimeType: "video/mp4")
        },to:"\(Constants.DOMAIN)upload.php")
            .responseString { (e) in
                if let res = e.value {
//                    BG.hide(self)
                    print(res)
                    if(res.contains("fail")){
//                        self.msg("مشكلة في تحميل الفيديو")
                        StaticFunctions.createErrorAlert(msg: "مشكلة في تحميل الفيديو")
                    }else{
                       // self.send_message(res,"VIDEO")
                    }
                }
            }
    }
    
    
    //=================================================//
    //================== Color Picker =================//
    //=================================================//
    
    func pickColor(){
        let picker = UIColorPickerViewController()
        picker.delegate = self
        picker.modalPresentationStyle = .popover
        picker.modalTransitionStyle = .flipHorizontal
        present(picker, animated: true, completion: nil)
    }
    
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
//        let color = viewController.selectedColor.toHexString()
//        print(color)
      //  send_message(color, "COLOR")
    }
    
    //=================================================//
    //==================== Contact ====================//
    //=================================================//
    
    func pickContact() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        present(contactPicker, animated: true)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        if let name = CNContactFormatter.string(from: contact, style: .fullName),let phone = contact.phoneNumbers.first!.value.value(forKey: "digits"){
          //  send_message("\(name)%%\(phone)", "CONTACT")
            sendMessage("\(name)%%\(phone)", images: [Data()], msgType: "CONTACT", filePath: URL(fileURLWithPath: ""))

        }
        //print(contact.givenName)
        //print(contact.middleName)
        
        //        let phoneNumberType = contact.phoneNumbers[0].label
        //        if (phoneNumberType?.contains("Mobile"))! {
        //            print(contact.phoneNumbers.first!.value.value(forKey: "mobile")!)
        //        }
    }
    
    //=================================================//
    //==================== DOCUMENT ===================//
    //=================================================//
    
    @available(iOS 14.0, *)
    func pickDocument(_ type:String) {
        var supportedTypes = [UTType.text, UTType.plainText, UTType.utf8PlainText,    UTType.utf16ExternalPlainText, UTType.utf16PlainText,    UTType.delimitedText, UTType.commaSeparatedText,    UTType.tabSeparatedText, UTType.utf8TabSeparatedText, UTType.rtf,    UTType.pdf,UTType.zip, UTType.appleArchive, UTType.spreadsheet, UTType.epub]
        if type == "audio"{
            supportedTypes = [UTType.audio,UTType.mpeg4Audio,UTType.appleProtectedMPEG4Audio]
        }
        
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.shouldShowFileExtensions = true
        documentPicker.title = "اختر الملف"
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        uploadFile(myURL,"DOCUMENT", mineType: "application/pdf")
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    
    func sendRecord(outputURl:URL, fileName:String,msg_type:String)  {
        let fileName = outputURl.lastPathComponent

          guard let audioFile: Data = try? Data (contentsOf: outputURl) else {return}
          AF.upload(multipartFormData: { (multipartFormData) in
          multipartFormData.append(audioFile, withName: msg_type, fileName: fileName, mimeType: "audio/m4a")
          }, to:"\(Constants.DOMAIN)upload.php").responseString { (response) in
          debugPrint(response)
              if let res = response.value {
//                  BG.hide(self)
                  print(res)
                  if(res.contains("fail")){
//                      self.msg("مشكلة في تحميل الملف")
                      StaticFunctions
                          .createErrorAlert(msg: "مشكلة في تحميل الملف")
                  }else{
                      //self.send_message(res,msg_type,outputURl.lastPathComponent)
                  }
              }
              }
    }
    
    
    func uploadFile(_ filePath:URL,_ msg_type:String, mineType: String){
//        BG.load(self)
        AF.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(filePath, withName: msg_type)
            multipartFormData.append(filePath, withName: msg_type , fileName: "file", mimeType: mineType)
        },
                  to: "\(Constants.DOMAIN)upload.php").responseString { (e) in
            if let res = e.value {
//                BG.hide(self)
                print(res)
                if(res.contains("fail")){
//                    self.msg("مشكلة في تحميل الملف")
                    StaticFunctions
                        .createErrorAlert(msg: "مشكلة في تحميل الملف")
                }else{
                   // self.send_message(res,msg_type,filePath.lastPathComponent)
                }
            }
        }
    }
    
    //=================================================//
    //====================== MAP ======================//
    //=================================================//
    func go_map(){
//        goNav("slocv","Chat")
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "slocv") as! SendLocC
        navigationController?.pushViewController(vc, animated: true)
        //GOTO Chat
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        self.navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
//        self.tabBarController?.tabBar.layer.isHidden = true
//        self.tabBarController?.tabBar.layer.zPosition = -1
        if Constants.orderLoc_represnted {
         //   self.send_message("\(order.lat)%%\(order.lng)%%\(order.loc)%%\(order.loc_img)", "LOCATION")
            if let filePath = Constants.orderFilePath {
                sendMessage("\(Constants.orderLat)%%\(Constants.orderLng)%%\(Constants.orderLoc)%%\(Constants.loc_img)", images: [Data()], msgType: "LOCATION", filePath: filePath)
            }
            

            Constants.orderLoc_represnted = false
        }
    }
    
    //=================================================//
    //==================== RECORD =====================//
    //=================================================//
    
    
//    var recorderView: RecorderViewController!
    func go_record(){
//        self.present(self.recorderView, animated: true, completion: nil)
//        self.recorderView.startRecording()
    }
  //  var audioPlayer : AVPlayer!
    
    private func playAudioFromURL(_ url:String) {
        guard let url = URL(string: url) else {
            return
        }
//        do {
//            player = try AVAudioPlayer(contentsOf:url)
//            player?.play()
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
        audioPlayer = AVPlayer(url: url as URL)
        let duration = Int(audioPlayer.currentItem!.asset.duration.seconds)
        print("Duration",duration)
        audioDuration = duration
        audioPlayer?.play()



    }
    

    
    
    func isAuth() -> Bool {
        var result:Bool = false
        
        AVAudioSession.sharedInstance().requestRecordPermission { (res) in
            result = res == true ? true : false
        }
        return result
    }
    
    @IBAction func play() {
        do {
//            try recorderView.recording.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    internal func didFinishRecording(_ recorderViewController: RecorderViewController) {
//        print(recorderView.recording.url)
//        let url = recorderView.recording.url
//
//        delay(0.4) {
//          //  self.uploadFile(self.recorderView.recording.url,"RECORD", mineType: "audio/m4a")
//            self.sendRecord(outputURl: url, fileName: "RECORD", msg_type: "audio/m4a")
//        }
        
//    }
    
}
protocol RecordVoiceVCDelegate:AnyObject {
    
    func getVoiceNote(with URL:URL?)
}

extension ChatVC {
    
    
    
    
    func playSound() {
        guard let path = Bundle.main.path(forResource: "beep", ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    private func handelRecordPermission(){
        recordingSession = AVAudioSession.sharedInstance()
        guard let availableInputs = recordingSession?.availableInputs,
              let builtInMicInput = availableInputs.first(where: { $0.portType == .builtInMic }) else {
            print("The device must have a built-in microphone.")
            return
        }
        do {
            try recordingSession?.setCategory(.playAndRecord,options: [.defaultToSpeaker,.allowBluetooth])
            try recordingSession?.setPreferredInput(builtInMicInput)
            try recordingSession?.setActive(true)
            recordingSession?.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordButton.isEnabled = true
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }
    func startRecording() {
        let audioFilename = getFileURL()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handelTimer), userInfo: nil, repeats: true)
            //            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 120) {
            //                self.finishRecording(success: true)
            //            }
            //recordBtn.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioUrl = audioRecorder?.url
        print("Aduio Url:",audioUrl)
        audioRecorder = nil
        timer?.invalidate()
        timer = nil
        if let url = audioUrl {
            sendMessage("record", images: [Data()], msgType: "AUDIO", filePath: url)
        }
        
        
    }
    
    @objc func handelTimer(){
        counter = counter + 1
        let time = secondsToHoursMinutesSeconds(seconds: counter)
        let timeString = makeTimeString(minutes: time.0, seconds: time.1)
        // counterLbl.text = timeString
    }
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int) {
        return (((seconds % 3600) / 60),((seconds % 3600) % 60))
    }
    
    func makeTimeString(minutes: Int, seconds : Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    @IBAction func sendbtnTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.getVoiceNote(with: self.audioUrl)
        }
    }
    
    
    
 
}

extension ChatVC : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
       
        // empty the images Array
        var  images = [Data]()
//        selectedMedia = [:]
        print(results)
        for (_,result) in results.enumerated() {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    print( "Fooo ",image)
                    let data = image.jpegData(compressionQuality: 0.01)
                    let newImage = UIImage(data: data!)
                    let index = UUID().uuidString
                    print(index)
                    images.append(data!)
//                    let index = self.images.count - 1
                    print(images.count)
                    self.sendMessage("image", images:images , msgType: "IMAGE", filePath: URL(fileURLWithPath: ""))
//                    guard let index = self.images.firstIndex(of: newImage!) else {return}
//                    self.selectedMedia.updateValue(data!, forKey: "IMAGE \(index)")
                }
            }
            
        }
        dismiss(animated: true,completion: nil)
    }
    
}

