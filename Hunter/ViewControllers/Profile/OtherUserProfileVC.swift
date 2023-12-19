    //
    //  OtherUserProfileVC.swift
    //  Bazar
    //
    //  Created by iOSayed on 01/05/2023.
    //
import UIKit
import Alamofire
import MOLH
import TransitionButton
import FirebaseAuth
import FirebaseDynamicLinks

    class OtherUserProfileVC: UIViewController {

        
        static func instantiate()-> OtherUserProfileVC{
            let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
            return profileVC
        }
        //MARK: IBOutlets
        
        @IBOutlet weak var scrollView: UIScrollView!
        @IBOutlet weak var blockAndReportStackView: UIStackView!
        @IBOutlet weak var followView: UIView!
        @IBOutlet weak var CoverImageView: UIImageView!
        @IBOutlet weak var userImageView: UIImageView!
        @IBOutlet weak var userVerifiedImageView: UIImageView!
        @IBOutlet weak var userNameLabel: UILabel!
        @IBOutlet weak var fullNameUserLabel: UILabel!
        @IBOutlet weak var UserLocationLabel: UILabel!
        @IBOutlet weak var userBioLabel: UILabel!
        @IBOutlet weak var notificationImageView: UIImageView!
        @IBOutlet weak var advsCountLabel: UILabel!
        @IBOutlet weak var followersCountLabel: UILabel!
        @IBOutlet weak var followingsCountLabel: UILabel!
        @IBOutlet weak var pages: UIView!
        @IBOutlet weak var addRateButton: UIButton!
        @IBOutlet weak var followButton: UIButton!
        
        @IBOutlet weak var chatButton: TransitionButton!
        
        var OtherUserId = 0
        var otherUserCountryId:Int?
        var tabs = [tab]()
        var viewPager:ViewPagerController!
        var options:ViewPagerOptions!
        var cids = ["ads","ratings"]
        var user = User()
        var userId = "0"
        override func viewDidLoad() {
            super.viewDidLoad()
            NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
            navigationController?.navigationBar.isHidden = true
            print(OtherUserId)
            getProfile()
            setupProfileUI()
            initTabs()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
    //        navigationController?.navigationBar.backgroundColor = .clear
               navigationController?.navigationBar.isHidden = true
               tabBarController?.tabBar.isHidden = true
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
            navigationController?.navigationBar.isHidden = false
            tabBarController?.tabBar.isHidden = false
        }
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            navigationController?.navigationBar.isHidden = false
            tabBarController?.tabBar.isHidden = false
        }
        //MARK: Methods
        
        fileprivate func setupProfileUI(){
            
            addRateButton.isHidden = true
//            if user.id == OtherUserId {
//                blockAndReportStackView.isHidden = true
//                followView.isHidden = true
//            }else{
//                blockAndReportStackView.isHidden = false
//                followView.isHidden = false
//            }
        }
        
        func initTabs(){
            tabs.append(tab(i: "advertisements".localize))
            tabs.append(tab(i: "Rates".localize))
            
            self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
            
            let frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height )
            options = ViewPagerOptions(viewPagerWithFrame: frame)
            options.tabType = ViewPagerTabType.basic
            //options.tabViewImageSize = CGSize(width: 20, height: 20)
//            options.tabViewTextFont = UIFont(name: "Almarai-Bold", size: 15)!
            options.tabViewPaddingLeft = 10
            options.tabViewPaddingRight = 10
            
            options.tabViewTextDefaultColor = UIColor(hexString: "#9AA6AE")
            options.tabViewTextHighlightColor = UIColor(named: "#0093F5")!
            options.viewPagerTransitionStyle = .scroll
            options.isTabHighlightAvailable = true
            options.tabViewBackgroundDefaultColor = UIColor.white
            options.tabViewBackgroundHighlightColor = UIColor.white
            
            options.isTabIndicatorAvailable = true
            options.tabIndicatorViewBackgroundColor = UIColor(named: "#0093F5")!
            options.tabIndicatorViewHeight = 2.3
            
            options.fitAllTabsInView = true
            options.textCorner = 0
            options.tabViewHeight = 50
            
            viewPager = ViewPagerController()
            viewPager.options = options
            viewPager.dataSource = self
            viewPager.delegate = self
            options.viewPagerFrame = self.view.bounds
            
            self.addChild(viewPager)
            pages.addSubview(viewPager.view)
            viewPager.didMove(toParent: self)
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("UserIDNotification"), object: nil)
        }
        
        
        private func shareProfile(){
            guard let link = URL(string: "https://www.bazar-kw.com/profile/?profile_id=" + "\(OtherUserId)") else { return }
                    let dynamicLinksDomainURIPrefix = "https://bazaaarprofile.page.link"
                    guard let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix) else { return }
                            linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "https://bazaaarprofile.page.link")
            // Set social meta tag parameters
            let socialTags = DynamicLinkSocialMetaTagParameters()
            socialTags.imageURL = URL(string: Constants.IMAGE_URL+(user.pic.safeValue ))
            socialTags.title = user.name.safeValue
            socialTags.descriptionText = user.bio.safeValue
            linkBuilder.socialMetaTagParameters = socialTags
            
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.url = URL(string: "https://www.bazar-kw.com/profile/?profile_id=" + "\(OtherUserId)")
            actionCodeSettings.dynamicLinkDomain = "https://bazaaarprofile.page.link"
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
                    
                    guard let longDynamicLink = linkBuilder.url else { return }
                    print(longDynamicLink)
                    linkBuilder.shorten() { url, warnings, error in
                        guard let url = url, error == nil else {
                            
                            return }
                        print("The short URL is: \(url)")
                        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView = self.view
                       
                        self.present(activityViewController, animated: true, completion: nil)
                    }
        }

        @IBAction func BackBtnAction(_ sender: UIButton) {
            navigationController?.popViewController(animated: true)
        }
        
        @IBAction func shareBtnAction(_ sender: UIButton) {
//            shareContent(text: "share Profile of ")
            shareProfile()
        }
        
        @IBAction func reportAboutUserBtnAction(_ sender: UIButton) {
            let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "ReportAboutUserVC") as! ReportAboutUserVC
            vc.uid = "\(OtherUserId)"
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: false)
        }
        
        @IBAction func blockUserBtnAction(_ sender: UIButton) {
            
            let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "BlockUserVC") as! BlockUserVC
            vc.otherUserId = OtherUserId
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: false)
        }
        
        @IBAction func followBtnAction(_ sender: UIButton) {

//         guard let url = URL(string: Constants.DOMAIN+"make_follow") else {return}
//         let params : [String: Any]  = ["to_id":OtherUserId]
//         print(params)
//         AF.request(url, method: .post, parameters: params,headers: Constants.headerProd).responseDecodable(of:SuccessModel.self){res in
//    //         BG.hide(self)
//             print(Constants.headerProd)
//             switch res.result {
//             case .success(let data):
//                 if let message = data.message {
//                     StaticFunctions.createSuccessAlert(msg: message)
//                     self.getProfile()
//                 }
//             case .failure(let error):
//                 print(error)
//             }
//         }
            ProfileController.shared.followUser(completion: { check, message in
                if check == 0 {
                    self.getProfile()
                }else {
                    StaticFunctions.createErrorAlert(msg: message)
                }
            }, OtherUserId: OtherUserId)
        }
        
        @IBAction func activeNotificationBtnAction(_ sender: UIButton) {
            let params : [String: Any]  = ["uid":  OtherUserId,
                                           "anther_user_id":AppDelegate.currentUser.id ?? 0]
            guard let url = URL(string: Constants.DOMAIN+"active_fuser_notification") else {return}
            print(params)
            AF.request(url, method: .post, parameters: params)
                .responseDecodable(of:SuccessModel.self){ [weak self ]res in
                    guard let self else {return }
                    switch res.result {
                       
                    case .success(let data):
                        if let message = data.message {
                            DispatchQueue.global().async {
                                self.getProfile()
                            }
                            StaticFunctions.createSuccessAlert(msg: message)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
        }
        @IBAction func advsBtnAction(_ sender: UIButton) {
    //        if let vc = UIStoryboard(name: MENU_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: MYADS_VCID) as? MyAdsVC {
    //            vc.modalPresentationStyle = .fullScreen
    //            vc.userId = OtherUserId
    //            presentDetail(vc)
    //        }
        }
        
        @IBAction func FollowersBtnAction(_ sender: UIButton) {
//            let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "tabFollowVC") as! tabsFollowVC
//            Constants.followIndex = 1
//            Constants.followOtherUserId = OtherUserId
//            vc.modalPresentationStyle = .fullScreen
//            navigationController?.pushViewController(vc, animated: true)
            let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "FollowersAndFollowingsVC") as! FollowersAndFollowingsVC
            Constants.followOtherUserId = AppDelegate.currentUser.id ?? 0
            Constants.followIndex = 0
//            vc.userId = AppDelegate.currentUser.id ?? 0
            vc.userId = OtherUserId
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        }
        
        @IBAction func followingsBtnAction(_ sender: UIButton) {
//            let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "tabFollowVC") as! tabsFollowVC
//            Constants.followIndex = 0
//            Constants.followOtherUserId = OtherUserId
//            vc.modalPresentationStyle = .fullScreen
//            navigationController?.pushViewController(vc, animated: true)
            let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "FollowersAndFollowingsVC") as! FollowersAndFollowingsVC
            Constants.followOtherUserId = AppDelegate.currentUser.id ?? 0
            Constants.followIndex = 0
            vc.userId = OtherUserId
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
        @IBAction func didTapAddRateButton(_ sender: UIButton) {
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "AddRateForUsersVC") as! AddRateForUsersVC
            vc.otherUserId = OtherUserId
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        }
        
        
        @IBAction func chatBtnAction(_ sender: UIButton) {
            chatButton.startAnimation()
            if StaticFunctions.isLogin() {
                    let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                    Constants.userOtherId = "\(OtherUserId)"
                    print(OtherUserId)
                    vc.modalPresentationStyle = .fullScreen
                    
                    createRoom("\(OtherUserId)"){[weak self] success in
                        self?.chatButton.stopAnimation()
                        guard let self = self else {return}
                        if success {
                            //                self.present(vc, animated: true)
                            vc.navigationController?.navigationBar.isHidden = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            
                            StaticFunctions.createErrorAlert(msg: "Can't Create Room".localize)
                        }
                    }
                
            }else {
                self.chatButton.stopAnimation()
                StaticFunctions.createErrorAlert(msg: "Please Login First".localize)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    self.basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
                }
                
            }
        }
    }
        
        

    extension OtherUserProfileVC {
        private func getProfile(){
            ProfileController.shared.getOtherProfile(completion: {[weak self] userProfile, msg in
                guard let self = self else {return}
                if let userProfile = userProfile {
                    print("======= profile Data ======== ")
                    print(userProfile)
                    self.otherUserCountryId = userProfile.countryId ?? 5
                    self.userId = userProfile.uid ?? "0"
                    Constants.otherUserName = userProfile.name ?? ""
                    print(userProfile.name ?? "")
                    Constants.otherUserPic = userProfile.pic ?? ""
                    Constants.otherUserIsStore = userProfile.isStore ?? false
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "passUserID"), object: nil, userInfo: ["userID": self.userId])
                    self.bindProfileData(from: userProfile)
                   // self.getProductsByUser()
                }
            }, userId: OtherUserId)
        }
        
        private func bindProfileData(from profileModel:User){
//            if let cover =  profileModel.cover {
//                if cover.contains(".png") || cover.contains(".jpg"){
//                    print(cover)
//                    CoverImageView.setImageWithLoading(url:profileModel.cover ?? "" )
//                }
//            }
            if let userPic =  profileModel.pic {
                print(userPic)
                if userPic.contains(".png") || userPic.contains(".jpg") {
                    
                    userImageView.setImageWithLoading(url:profileModel.pic ?? "" ,placeholder: "logo_photo")
                }else {
                    userImageView.image = UIImage(named: "logo_photo")
                }
                
            }
            
//            fullNameUserLabel.text = "\(profileModel.name ?? "") \(profileModel.lastName ?? "")"
//            if profileModel.verified != 0 {
//                userVerifiedImageView.isHidden = false
//            }else{
//                userVerifiedImageView.isHidden = true
//            }
            
            advsCountLabel.text = "\(profileModel.numberOfProds ?? 0)"
            followersCountLabel.text = "\(profileModel.followers ?? 0)"
            followingsCountLabel.text = "\(profileModel.following ?? 0)"
            userNameLabel.text = profileModel.name
           
            if let bio = profileModel.bio {
                userBioLabel.text = bio
            }
            if MOLHLanguage.currentAppleLanguage() == "en" {
                UserLocationLabel.text = "\(profileModel.countriesNameEn ?? "") - \(profileModel.citiesNameEn ?? "")"
            }else {
                UserLocationLabel.text = "\(profileModel.countriesNameAr ?? "") - \(profileModel.citiesNameAr ?? "")"
            }
            
//            if profileModel.activeNotification == 1 {
//                StaticFunctions.setImageFromAssets(notificationImageView, "bell_fill")
//
//                }else{
//                    StaticFunctions.setImageFromAssets(notificationImageView, "bell_main")
//                }
            
            if profileModel.isFollow == 1 {
                self.followButton.setTitle("unfollow".localize, for: .normal)
            }else{
                self.followButton.setTitle("follow".localize, for: .normal)
            }
            
//            if AppDelegate.currentUser.id == OtherUserId {
//    //            self.enable([self.btn_follow,self.btn_not], enabled: false)
//    //            self.setTxtColor(self.btn_follow,"#000000")
//    //            self.contactv.constant = 0
//                self.chatButton.isHidden = true
//                self.followView.isHidden = true
//                self.blockAndReportStackView.isHidden = true
//            }
            
        }
        
        
        func createRoom(_ recieverId:String, completion:@escaping (Bool)->()){
            let params : [String: Any]  = ["rid":recieverId]
            print(params , "Headers  \(Constants.headerProd)" )
            guard let url = URL(string: Constants.DOMAIN+"create_room")else{return}
            AF.request(url, method: .post, parameters: params, headers: Constants.headerProd).responseDecodable(of:RoomSuccessModel.self) { res in
                print(res)
                switch res.result {
                    
                case .success(let data):
                    if let receiverId = data.data?.id {
                       
                        print(data)
                        receiver.room_id = "\(receiverId)"
                        print(receiver.room_id)
                        completion(true)
                        
                    }
                case .failure(let error):
                    print(error)
                    completion(false)
                }
            }
            
        }
    }

    extension OtherUserProfileVC: ViewPagerControllerDataSource {
        
        func numberOfPages() -> Int {
            return tabs.count
        }
        
        func viewControllerAtPosition(position:Int) -> UIViewController {
            if position == 1{
    //            let RateVC =  profileRatesVC()
                let RateVC = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "profileRatesVC") as! profileRatesVC
                RateVC.ratedUserId = OtherUserId
        
                return RateVC
//                getViewController("profileRatesVC",PROFILE_STORYBOARD)
            }else{
                let OtherUserProductVC = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "OtherUserProductVC") as! OtherUserProductVC
                OtherUserProductVC.otherUserID = "\(OtherUserId)"
                OtherUserProductVC.otherUserCountryId = otherUserCountryId ?? 6
                return OtherUserProductVC
 //                getViewController("OtherUserProductVC",PROFILE_STORYBOARD)
            }
        }
        
        func tabsForPages() -> [tab] {
            return tabs
        }
        
        func startViewPagerAtIndex() -> Int {
            return 0
        }
    }
    extension OtherUserProfileVC: ViewPagerControllerDelegate {
        
        func willMoveToControllerAtIndex(index:Int) {
            print("index=\(index)")
        }
        
        func didMoveToControllerAtIndex(index: Int) {
            if index == 1 {
                addRateButton.isHidden = false
            }else{
                addRateButton.isHidden = true
            }
        }
    }
    //extension OtherUserProfileVC:UIScrollViewDelegate {
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let contentOffsetY = scrollView.contentOffset.y
    //
    //        // Check if the scroll direction is upwards
    //        if contentOffsetY > 0 {
    //            navigationController?.setNavigationBarHidden(true, animated: false)
    //        } else {
    //            navigationController?.setNavigationBarHidden(false, animated: false)
    //        }
    //    }
    //}

extension OtherUserProfileVC : AddRateForUsersVCDelegate{
    func reloadData() {
        
    }
}
