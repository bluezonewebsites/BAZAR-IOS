//
//  kk.swift
//  Bazar
//
//  Created by iOSayed on 25/06/2023.
//

import UIKit
import OTPFieldView
import TransitionButton
import Alamofire
class VerifyCodeVC: UIViewController {

        @IBOutlet weak var resendCodeBtn: UIButton!
        @IBOutlet weak var counterLbl: UILabel!
        @IBOutlet weak var verifyBtn: TransitionButton!
        @IBOutlet weak var codeTF: OTPFieldView!
        @IBOutlet weak var emailLbl: UILabel!
        @IBOutlet weak var phoneLbl: UILabel!
        var code = ""
        var timer = Timer()
        var timeLeft: TimeInterval = 120
        var endTime: Date?
    
    var regionId = 0
    var countryId = 0
    var cityId = 0
    var userPhoneNumber = ""
    
        override func viewDidLoad() {
            super.viewDidLoad()
            emailLbl.text = AppDelegate.currentUser.email
            phoneLbl.text = AppDelegate.currentUser.phone

            setupOtpView()
            setupCounter()
            // Do any additional setup after loading the view.
        }
        func setupOtpView(){
            self.codeTF.fieldsCount = 4
            self.codeTF.fieldBorderWidth = 2
            self.codeTF.cornerRadius = 10
            self.codeTF.defaultBorderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.codeTF.filledBorderColor = UIColor(named: "#0093F5") ?? #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
            
            self.codeTF.cursorColor = UIColor(named: "#0093F5") ?? #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
            
            self.codeTF.defaultBackgroundColor = UIColor.clear
            self.codeTF.displayType = .roundedCorner
            self.codeTF.fieldSize = 48
            self.codeTF.separatorSpace = 8
            self.codeTF.shouldAllowIntermediateEditing = true
            self.codeTF.delegate = self
            //        self.pinCodeTF.shadowColor = #colorLiteral(red: 0.5534071326, green: 0.6402478814, blue: 0.7064570189, alpha: 1)
            //        self.pinCodeTF.shadowOpacity = 0.13
            self.codeTF.initializeUI()
        }
        func setupCounter (){
            
            counterLbl.text = timeLeft.time
            
            endTime = Date().addingTimeInterval(timeLeft)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            
        }
        @objc func updateTime() {
            if timeLeft > 0 {
                resendCodeBtn.isEnabled = false
                resendCodeBtn.alpha = 0.5
                timeLeft = endTime?.timeIntervalSinceNow ?? 0
                counterLbl.text = timeLeft.time
                
            } else {
                resendCodeBtn.isEnabled = true
                resendCodeBtn.alpha = 1
                
                timer.invalidate()
                
            }
        }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
        @IBAction func verifyAction(_ sender: Any) {
            checkCode()
        }
        @IBAction func resendAction(_ sender: Any) {
            resendCode()
        }
       

    }
    extension VerifyCodeVC :OTPFieldViewDelegate{
        
        func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
            print("Has entered all OTP? \(hasEntered)")
            StaticFunctions.enableBtn(btn: verifyBtn, status: true)
            
            if hasEntered{
                StaticFunctions.enableBtn(btn: verifyBtn, status: true)
            }else{
                StaticFunctions.enableBtn(btn: verifyBtn, status: false)
            }
           
            return hasEntered
        }
        
        func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
            return true
        }

        func enteredOTP(otp otpString: String) {
            print("OTPString: \(otpString)")
            self.code = otpString
        }
        func checkCode() {
            
            StaticFunctions.enableBtnWithoutAlpha(btn: verifyBtn, status: false)
            if Reachability.isConnectedToNetwork(){
                self.verifyBtn.startAnimation()
                
                AuthCoontroller.shared.verifyRegister(completion: {
                    check, msg in
                    self.verifyBtn.stopAnimation(animationStyle: .normal, revertAfterDelay: 0, completion: nil)
                    StaticFunctions.enableBtnWithoutAlpha(btn: self.verifyBtn, status: true)
                    
                    if check == 0{
                            // Success
                        self.changePhone()
                       

                    }else{
                        StaticFunctions.createErrorAlert(msg: msg)
                        
                    }
                    
                }, code: self.code, userId: AppDelegate.currentUser.id ?? 0)
                
            }
            else{
                StaticFunctions.enableBtnWithoutAlpha(btn: verifyBtn, status: true)
                
                StaticFunctions.createErrorAlert(msg: NO_INTERNET_CONNECTION)
            }
        }
        
        func resendCode(){
            if Reachability.isConnectedToNetwork(){
                
                AuthCoontroller.shared.resendCodeRegister(completion: {
                    check, msg in
                    
                    if check == 0{
                    
                        StaticFunctions.createSuccessAlert(msg: msg)

                    }else{
                        StaticFunctions.createErrorAlert(msg: msg)
                        
                    }
                    
                },userId: AppDelegate.currentUser.id ?? 0)
                
            }
            else{
                
                StaticFunctions.createErrorAlert(msg: NO_INTERNET_CONNECTION)
            }
        }
        
        func changePhone(){
            let params : [String: Any]  = ["mobile": userPhoneNumber,
                                           "country_id":countryId,
                                           "city_id":cityId,
                                           "region_id":regionId]
            
            print(" Parameters of Edit Mobile ", params)
            guard let url = URL(string: Constants.DOMAIN+"change_mobile")else{return}
            AF.request(url, method: .post, parameters: params, encoding:URLEncoding.httpBody , headers: Constants.headerProd).responseDecodable(of:SuccessModelChangeMoblie.self){ res in
                switch res.result {
                    
                case .success(let data ):
                    if let success = data.success , let message = data.message {
                        if success{
                            StaticFunctions.createSuccessAlert(msg: message)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                self.basicPresentation(storyName: MAIN_STORYBOARD, segueId: "TabBarVC")

                            }
                        }else{
                            StaticFunctions.createErrorAlert(msg:message)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
        }
}

