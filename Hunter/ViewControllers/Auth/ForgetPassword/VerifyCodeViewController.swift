//
//  VerifyCodeViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 16/04/2023.
//

import UIKit
import OTPFieldView
import TransitionButton
class VerifyCodeViewController: UIViewController {

  

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

        @IBAction func verifyAction(_ sender: Any) {
            checkCode()
        }
        @IBAction func resendAction(_ sender: Any) {
            resendCode()
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
    extension VerifyCodeViewController :OTPFieldViewDelegate{
        
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
                    
                        StaticFunctions.createSuccessAlert(msg: msg)
                        self.basicNavigation(storyName: Auth_STORYBOARD, segueId: RESET_PASSWORD_VCID)

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
                timeLeft = 120
                setupCounter()
                resendCodeBtn.isEnabled = false
                resendCodeBtn.alpha = 0.5
                
                AuthCoontroller.shared.resendCodeRegister(completion: {
                    check, msg in
                    
                    if check == 0{
                    
                        StaticFunctions.createSuccessAlert(msg: msg)

                    }else{
                        StaticFunctions.createErrorAlert(msg: msg)
                        
                    }
                    
                },userId: AppDelegate.unVerifiedUserUser.id ?? 0)
                
            }
            else{
                
                StaticFunctions.createErrorAlert(msg: NO_INTERNET_CONNECTION)
            }
        }
        
    }
