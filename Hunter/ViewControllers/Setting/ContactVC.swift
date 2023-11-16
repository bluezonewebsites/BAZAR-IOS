//
//  sdsdsa.swift
//  Bazar
//
//  Created by iOSayed on 01/06/2023.
//


import UIKit
import Alamofire
import DropDown


class ContactVC: ViewController {
    
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_phone: UITextField!
    @IBOutlet weak var txt_descr: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        txt_name.text = AppDelegate.currentUser.name ?? ""
        txt_email.text = AppDelegate.currentUser.email ?? ""
        txt_phone.text = AppDelegate.currentUser.phone ?? ""

        get()
    }
    
    func get(){
        let params : [String: Any]  = ["method":"help"]
        AF.request(Constants.DOMAIN+"contact_us", method: .post, parameters: params, encoding:URLEncoding.httpBody , headers: Constants.headerProd)
            .responseJSON { (e) in
                if let result = e.value {
                    let res = result as! NSDictionary
                }
        }
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismissDetail()
    }
    
    @IBAction func go_next() {
        if(!txt_name.text!.isEmpty && !txt_phone.text!.isEmpty && !txt_email.text!.isEmpty){
            
            let params : [String: Any]  = ["name":txt_name.text!
                ,"phone":txt_phone.text!,"email":txt_email.text!
                ,"descr":txt_descr.text!]
            guard let url = URL(string: Constants.DOMAIN+"contact_us") else {return}
            AF.request(url, method: .post, parameters: params, encoding:URLEncoding.httpBody , headers: Constants.headerProd)
                .responseDecodable(of:Success.self) { (e) in
                    switch e.result {
                    case .success(let data):
                        print(data.success)
                        if data.success {
                            StaticFunctions.createErrorAlert(msg:"تم ارسال رسالتك للإدارة، سوف يتم التواصل معك قريبا")
                            self.dismiss(animated: true)
                        }else {
                            StaticFunctions.createErrorAlert(msg:"تأكد من ادخال البيانات بشكل صحيح")

                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
            }
        }else{
            StaticFunctions.createErrorAlert(msg:"كافة الحقول مطلوبة")
        }
    }
    
  
}
