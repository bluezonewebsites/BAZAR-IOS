//
//  ssas.swift
//  Bazar
//
//  Created by iOSayed on 14/06/2023.
//

//
//  homeC.swift
//  Bazar
//
//  Created by khaled on 7/16/21.
//  Copyright © 2021 roll. All rights reserved.
//

import UIKit
import Alamofire

class profileRatesVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var lst: UITableView!
    var data = RateData()
    var ratedUserId = 0
    
    var rateId = [String]()
    var otherUserId = [String]()
    var userId = [String]()
    var rateMessage = [String]()
    var rateStar = [String]()
    var rateDate = [String]()
    var otherUserName = [String]()
    var userPicture = [String]()
    
    
    lazy var emptyStateView: EmptyStateView = {
        let emptyView = EmptyStateView()
        return emptyView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUserRates(_:)), name: NSNotification.Name("getRate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserIDNotification(_:)), name: .userIDNotification, object: nil)
                
        //lst.backgroundColor = UIColor.clear.withAlphaComponent(0)
//        lst.registerCell(cell: RateOtherUserCell.self)
        lst.register(UINib(nibName: "RateOtherUserCell", bundle: nil), forCellReuseIdentifier: "RateOtherUserCell")
        lst.rowHeight = UITableView.automaticDimension
        lst.estimatedRowHeight = 50
        lst.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 400, right: 0)
        
//        addObserver("loadRatings", #selector(getRate))
        getRate()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        addObserver("loadUserRate", #selector(getRate))
//        NotificationCenter.default.post(Notification(name: .loadUserRate))

        
        
    }
    
    @objc func handleUserIDNotification(_ notification: Notification) {
        if let userID = notification.userInfo?["userID"] as? String {
            // Use the userID here
            print(userID)
          //  self.ratedUserId = userID
        }
    }
    
    func updateBacgroundTableView(){
        if data.data?.isEmpty ?? false {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
    }
    
    func clearAll()  {
         rateId.removeAll()
         otherUserId.removeAll()
         userId.removeAll()
         rateMessage.removeAll()
         rateStar.removeAll()
         rateDate.removeAll()
         otherUserName.removeAll()
         userPicture.removeAll()
    }
    
    @objc func reloadUserRates(_ notification: Notification){
        getRate()
    }
    
    @objc func getRate(){
        data.data?.removeAll()
        clearAll()
        let params : [String: Any]  = ["uid":ratedUserId]
        print(params)
        guard let url = URL(string: Constants.DOMAIN+"get_rate_user")else{return}
        AF.request(url, method: .post, parameters: params).responseDecodable(of:RateSuccessModel.self){[weak self ]res in
            print(res.value)
            guard let self else {return}
            switch res.result {
                
            case .success(let data):
                if let rateData = data.data {
                    self.data = rateData
                    DispatchQueue.main.async {
                        self.lst.reloadData()
                        self.updateBacgroundTableView()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = data.data?.count else {return Int()}
        return count
        //  return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inx = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "RateOtherUserCell", for: indexPath) as! RateOtherUserCell
        if let data = data.data?[inx] {
            cell.configure(data: data )
        }
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        remObserver()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inx = indexPath.row
       // user.other_id = data[inx].user.id
        if let userId = data.data?[inx].userRatedID {
            if AppDelegate.currentUser.id ?? 0 == userId {
                let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PROFILE_VCID) as! ProfileVC
                vc.navigationController?.navigationBar.isHidden = true
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: OTHER_USER_PROFILE_VCID) as! OtherUserProfileVC
                vc.OtherUserId = userId
                vc.navigationController?.navigationBar.isHidden = true
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}
