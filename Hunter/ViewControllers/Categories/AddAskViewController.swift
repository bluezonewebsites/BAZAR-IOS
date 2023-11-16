//
//  AddAskViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 27/05/2023.
//

import UIKit
import TransitionButton

class AddAskViewController: UIViewController {
    @IBOutlet weak var commentTF: UITextView!
    @IBOutlet var textFields: [UITextView]!
    @IBOutlet weak var sendBtn: TransitionButton!
    var id = 0
    
    @IBOutlet weak var imageView: UIImageView!
    var isImageAdded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func textDidChange(_ notification: Notification){
        enableButton()
        
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: false)

    }
    @IBAction func sendAction(_ sender: Any) {
        comment()

    }
    @IBAction func imageBtnAction(_ sender: Any) {
        let vc = UIStoryboard(name: CATEGORRY_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier:ASK_IMAGE_PICKER_VCID ) as! AskImagePickerViewController
        vc.chooseImageBtclosure = {
            image in
            self.imageView.image = image
            self.isImageAdded = true
        }
        self.present(vc, animated: false, completion: nil)
        
    }
    //ASK_IMAGE_PICKER_VCID
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddAskViewController : UITextViewDelegate{
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        let (valid , message) = ValidTextView(textField: textView)
        
        
        return true
        
    }
    
    
}
extension AddAskViewController{
    
    
    func ValidTextView(textField : UITextView)->(Bool, String?) {
        if textField == commentTF{
            if commentTF.text!.count == 0{
                return (false ,NSLocalizedString("enter your comment", comment: ""))
                
            }
            else {
                return (true ,nil )
                
            }
        }
        
        
        return (true ,nil )
    }
    func enableButton(){
        var formIsValid = true
        
        for textField in textFields {
            // Validate Text Field
            let (valid,_) = ValidTextView(textField: textField)
            
            
            guard valid else {
                formIsValid = false
                break
            }
        }
        
        StaticFunctions.enableBtn(btn: sendBtn, status: formIsValid)
    }
    
    func comment(){
        StaticFunctions.enableBtnWithoutAlpha(btn: sendBtn, status: false)
        if Reachability.isConnectedToNetwork(){
            self.sendBtn.startAnimation()
            
            CategoryController.shared.addComment(completion: {
                check, msg in
                self.sendBtn.stopAnimation(animationStyle: .normal, revertAfterDelay: 0, completion: nil)
                StaticFunctions.enableBtnWithoutAlpha(btn: self.sendBtn, status: true)
                
                if check == 0{
                    StaticFunctions.createSuccessAlert(msg: msg)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"updateData"), object: nil)
                    self.dismiss(animated: false)

                    
                }else{
                    StaticFunctions.createErrorAlert(msg: msg)
                    
                }
                
            },  id:  id, comment: commentTF.text!, image: isImageAdded ? imageView.image : nil)
            
        }
        else{
            StaticFunctions.enableBtnWithoutAlpha(btn: sendBtn, status: true)
            
            StaticFunctions.createErrorAlert(msg: NO_INTERNET_CONNECTION)
        }
    }
    
    
    
    
}
