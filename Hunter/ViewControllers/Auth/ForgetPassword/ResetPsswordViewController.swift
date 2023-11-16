//
//  ResetPsswordViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 16/04/2023.
//

import UIKit
import TransitionButton

class ResetPsswordViewController: UIViewController {
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var saveBtn: TransitionButton!
    @IBOutlet weak var newPasswordErrorLbl: UILabel!
    
    @IBOutlet weak var passwordEErrorLbl: UILabel!
    var isPasswordHidden = true
    var isConfirmPasswordHidden = true

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    @objc func textDidChange(_ notification: Notification){
        enableButton()
        
    }
    @IBAction func hideShowPasswordAction(_ sender: UIButton) {
        isPasswordHidden = !isPasswordHidden
        isPasswordHidden
        ? sender.setImage( UIImage(systemName: "eye"), for: .normal) : sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        
        passwordTf.isSecureTextEntry = isPasswordHidden
    }
    @IBAction func hideShoowConfirmPasswordAction(_ sender: UIButton) {
        isConfirmPasswordHidden = !isConfirmPasswordHidden
        isConfirmPasswordHidden
        ? sender.setImage( UIImage(systemName: "eye"), for: .normal) : sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        
        confirmPasswordTF.isSecureTextEntry = isPasswordHidden
    }
    
    @IBAction func reseetAction(_ sender: Any) {
        login()
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
extension ResetPsswordViewController : UITextFieldDelegate{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        
        let (valid , message) = ValidTextField(textField: textField)
        if (message ?? "") == NSLocalizedString("password dosen't match", comment: ""){
            StaticFunctions.seteErrorLblStatus(errorLbl: newPasswordErrorLbl, status: valid, msg: message ?? "")
        }
        
        if textField == passwordTf{
            StaticFunctions.seteErrorLblStatus(errorLbl: passwordEErrorLbl, status: valid, msg: message ?? "")
        }
     
        else if textField == confirmPasswordTF{
            StaticFunctions.seteErrorLblStatus(errorLbl: newPasswordErrorLbl, status: valid, msg: message ?? "")
        }
        
        
        
        return true
    }
    
    func ResetPsswordViewController(_ textField: UITextField) -> Bool {
        
      if textField == passwordTf{
            confirmPasswordTF.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
}
extension ResetPsswordViewController{
   
    func ValidTextField(textField : UITextField)->(Bool, String?) {
        
        
         if textField == passwordTf{
            if passwordTf.text!.count < 6{
                return (false ,NSLocalizedString("password should be greater than 6 digits", comment: ""))
                
            }
             else {
                 if confirmPasswordTF.text != passwordTf.text{
                     return (false ,NSLocalizedString("password dosen't match", comment: ""))
                 }
                 return (true ,nil )
                 
             }
        }
        else   if textField == confirmPasswordTF{
            if confirmPasswordTF.text!.count < 6{
                return (false ,NSLocalizedString("Confirm password should be greater than 6 digits", comment: ""))
                
            }
            else {
                if confirmPasswordTF.text != passwordTf.text{
                    return (false ,NSLocalizedString("password dosen't match", comment: ""))
                }
                return (true ,nil )
                
            }
            
          
        }
        
        return (true ,nil )
    }
    func enableButton(){
        var formIsValid = true
        for textField in textFields {
            // Validate Text Field
            let (valid,_) = ValidTextField(textField: textField)
            
            
            guard valid else {
                formIsValid = false
                break
            }
        }
        
        StaticFunctions.enableBtn(btn: saveBtn, status: formIsValid)
    }
    
    
     func login() {
       
         StaticFunctions.enableBtnWithoutAlpha(btn: saveBtn, status: false)
         if Reachability.isConnectedToNetwork(){
             self.saveBtn.startAnimation()

             AuthCoontroller.shared.resetPassword(completion: {
                 check, msg in
                 self.saveBtn.stopAnimation(animationStyle: .normal, revertAfterDelay: 0, completion: nil)
                 StaticFunctions.enableBtnWithoutAlpha(btn: self.saveBtn, status: true)
                 
                 if check == 0{
                 
                     StaticFunctions.createSuccessAlert(msg: msg)
                     self.navigationController?.popToRootViewController(animated: true)
                 }else{
                     StaticFunctions.createErrorAlert(msg: msg)
                     
                 }
                 
             }, password: passwordTf.text!, userId: AppDelegate.currentUser.id ?? 0)

         }
         else{
             StaticFunctions.enableBtnWithoutAlpha(btn: saveBtn, status: true)

             StaticFunctions.createErrorAlert(msg: NO_INTERNET_CONNECTION)
         }
    }
    
    
    
}

