//
//  ReportViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 11/05/2023.
//

import UIKit

class ReportViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var reportList = ["prohibited on Bazar".localize,
                      "Offensive or inappropriate".localize,"Identical or imitation product".localize,"Located in the wrong section".localize,"Looks like a scam".localize, "The publisher is a fake or stolen account".localize]
    
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
   
}
extension ReportViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReportTableViewCell
        cell.seetData(reason: reportList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProductController.shared.flageAd(completion: {
            check, msg in
            if check == 0 {
                StaticFunctions.createSuccessAlert(msg: msg)
                self.dismiss(animated: false)
            }else{
                StaticFunctions.createErrorAlert(msg: msg)
            }
        }, id: id, reason: reportList[indexPath.row])
    }
}
