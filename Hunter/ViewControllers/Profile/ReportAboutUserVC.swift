//
//  ReportAboutUserVC.swift
//  Bazar
//
//  Created by iOSayed on 02/05/2023.
//

import UIKit

class ReportAboutUserVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var reportList = ["prohibited on Bazar".localize,
                      "Offensive or inappropriate".localize,"Identical or imitation product".localize,"Located in the wrong section".localize,"Looks like a scam".localize, "The publisher is a fake or stolen account".localize]
    
    var uid = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
      print(uid)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
   
}
extension ReportAboutUserVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReportTableViewCell
        cell.seetData(reason: reportList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProfileController.shared.flageProfile(completion: {
            check, msg in
            if check == 0 {
                StaticFunctions.createSuccessAlert(msg: msg)
                self.dismiss(animated: false)
            }else{
                StaticFunctions.createErrorAlert(msg: msg)
            }
        }, uid: uid,reason: reportList[indexPath.row])
    }
}
