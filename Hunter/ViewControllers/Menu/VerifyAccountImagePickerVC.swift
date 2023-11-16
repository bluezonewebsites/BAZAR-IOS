//
//  dsds.swift
//  Bazar
//
//  Created by iOSayed on 14/06/2023.
//

import UIKit

class VerifyAccountImagePickerVC: UIViewController {
    var chooseImageBtclosure : ((UIImage) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func takePhotoAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    @IBAction func photoLibraryAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        
    }
  

}
extension VerifyAccountImagePickerVC : UIImagePickerControllerDelegate,
                                         UINavigationControllerDelegate {
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         // Local variable inserted by Swift 4.2 migrator.
         let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
         
         if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
             self.dismiss(animated: false, completion: {
                 self.chooseImageBtclosure!(image)
             })
             
             
         }
         else if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
             self.dismiss(animated: false, completion: {
                 self.chooseImageBtclosure!(image)
             })
             
             
         } else{
             StaticFunctions.createErrorAlert(msg: "some thing went wrong")
         }
         
         
         dismiss(animated:true, completion: nil)
         
     }
 }
