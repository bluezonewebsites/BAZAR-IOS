//
//  MyAsksVC.swift
//  Bazar
//
//  Created by iOSayed on 25/06/2023.
//

import UIKit

class MyAsksVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var asks = [Ask]()
    var page = 1
    var isTheLast = false
    var cityId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        let customNavBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0))
        navigationController?.navigationBar.tintColor = .white
            customNavBar.backgroundColor = UIColor(named: "#0093F5")
        // Set your desired background color
            view.addSubview(customNavBar)
        
        getData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData(_:)), name: NSNotification.Name(rawValue: "updateData"), object: nil)

        // Do any additional setup after loading the view.
    }
    @objc func updateData(_ notification: NSNotification) {
        asks.removeAll()
        self.page = 1
        self.isTheLast = false
        getData()
        
    }
    @IBAction func addAsk(_ sender: Any) {
        let vc = UIStoryboard(name: CATEGORRY_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier:ASK_ADD_VCID ) as! AddAskViewController
        vc.id = cityId
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
extension MyAsksVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AskTableViewCell
        cell.setData(ask: asks[indexPath.row])
        cell.showUserBtclosure = {
            let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: OTHER_USER_PROFILE_VCID) as! OtherUserProfileVC
            vc.OtherUserId = self.asks[indexPath.row].userId ?? 0
            vc.navigationController?.navigationBar.isHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.deleteBtclosure = {
            CategoryController.shared.deleteAsk(completion: {
                check, msg in
                if check == 0{
                    StaticFunctions.createSuccessAlert(msg: msg)
                    self.asks.removeAll()
                    self.page = 1
                    self.isTheLast = false
                    self.getData()
                    
                }else{
                    StaticFunctions.createErrorAlert(msg: msg)

                }
            }, id: self.asks[indexPath.row].id ?? 0)
        }
        cell.zoomBtclosure = {
            if let quesPicture = self.asks[indexPath.row].pic{
                
                let zoomCtrl = VKImageZoom()
                zoomCtrl.image_url = URL.init(string: "\(Constants.IMAGE_URL)\(quesPicture)")
                print("zoomCtrl.image_url ====> ",zoomCtrl.image_url , "\(Constants.IMAGE_URL)\(quesPicture)")
                self.present(zoomCtrl, animated: true, completion: nil)
                
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: CATEGORRY_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COMMENT_REPLY_VCID) as! AskRepliesViewController
        vc.data.question = self.asks[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (asks.count-1) && !isTheLast{
            page+=1
            getData()

        }
    }
    

}

extension MyAsksVC{
    func getData(){
        CategoryController.shared.getUserAsks(completion: {
            asks, check, msg in
            if check == 0{
                if self.page == 1 {
                    self.asks.removeAll()
                    self.asks = asks
                    
                }else{
                    self.asks.append(contentsOf: asks)
                }
                if asks.isEmpty{
                    self.page = self.page == 1 ? 1 : self.page - 1
                    self.isTheLast = true
                }
                self.tableView.reloadData()
            }else{
                StaticFunctions.createErrorAlert(msg: msg)
                self.page = self.page == 1 ? 1 : self.page - 1
            }
        }, id: AppDelegate.currentUser.id ?? 0, page: self.page)
    }
}

extension MyAsksVC:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y

        // Check if the scroll direction is upwards
        if contentOffsetY > 0 {
            navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
}
