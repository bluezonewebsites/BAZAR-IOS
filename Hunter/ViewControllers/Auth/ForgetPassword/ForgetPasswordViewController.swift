//
//  ForgetPasswordViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 16/04/2023.
//

import UIKit
import TransitionButton
class ForgetPasswordViewController: UIViewController {
    @IBOutlet var textFields: [UITextField]!

    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var phooneErrorLbl: UILabel!
    
    @IBOutlet weak var continueBtn: TransitionButton!
    @IBOutlet weak var phooneCodeLbl: UILabel!
    @IBOutlet weak var phoneTF: UITextField!
    var countryCode = "965"
    var forgetBtclosure : (() -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeCountryAction(_ sender: Any) {
            var coountryVC = CounriesViewController()

            coountryVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: COUNTRY_VCIID) as!  CounriesViewController
            coountryVC.countryBtclosure = {
                (country) in
                self.countryCode = country.code ?? ""
                self.phooneCodeLbl.text = country.code
                self.countryImageView.setImageWithLoading(url: country.image ??
                "")

                self.enableButton()
            }
            self.present(coountryVC, animated: true, completion: nil)
        
    }
    @objc func textDidChange(_ notification: Notification){
        enableButton()
        
    }
   
     @IBAction func continueAction(_ sender: Any) {
         forget()
     }
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: false)
    }
    /* // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ForgetPasswordViewController : UITextFieldDelegate{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        let (valid , message) = ValidTextField(textField: textField)
        
 
         if textField == phoneTF{
            StaticFunctions.seteErrorLblStatus(errorLbl: phooneErrorLbl, status: valid, msg: message ?? "")
        }
       
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
    
            textField.resignFirstResponder()
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == phoneTF ){
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        return true
    }
    
}
extension ForgetPasswordViewController{
   
    func ValidTextField(textField : UITextField)->(Bool, String?) {
        if textField == phoneTF {
           if (phoneTF.text!.count != 0 ){
                if StaticFunctions.checkValidPhonNumber(Phone: countryCode + phoneTF.text!) {
                   return (true ,nil )
                   
                }
                else {
                    return (false ,NSLocalizedString("enter valid phone number".lowercased(),comment:"") )                               }
           }
            else {
                return (false ,NSLocalizedString("enter valid phone number".lowercased(),comment:"") )                               }
           
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
      
        
        StaticFunctions.enableBtn(btn: continueBtn, status: formIsValid)
    }
    
    
    func forget() {
        
        
        StaticFunctions.enableBtnWithoutAlpha(btn: continueBtn, status: false)
        if Reachability.isConnectedToNetwork(){
            self.continueBtn.startAnimation()
            
            AuthCoontroller.shared.checkUser(completion: {
                userId, check, msg in
                self.continueBtn.stopAnimation(animationStyle: .normal, revertAfterDelay: 0, completion: nil)
                StaticFunctions.enableBtnWithoutAlpha(btn: self.continueBtn, status: true)
                
                if check == 0{
                    AppDelegate.currentUser.id = userId
                    StaticFunctions.createSuccessAlert(msg: msg)
                    self.dismiss(animated: false, completion: {
                        self.forgetBtclosure!()
                    })
                }else{
                    StaticFunctions.createErrorAlert(msg: msg)
                    
                }
                
            }, mobile: phoneTF.text!)
            
        }
        else{
            StaticFunctions.enableBtnWithoutAlpha(btn: continueBtn, status: true)
            
            StaticFunctions.createErrorAlert(msg: NO_INTERNET_CONNECTION)
            //         }
        }
        
    }
    
}

