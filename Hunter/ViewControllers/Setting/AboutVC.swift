//
//  AboutVC.swift
//  Bazar
//
//  Created by iOSayed on 03/06/2023.
//


import UIKit
import Alamofire
import MOLH
class AboutVC: ViewController {
    
    @IBOutlet weak var vUnderScroll: UIView!
    
    @IBOutlet weak var cscroll: UIScrollView!
    
    @IBOutlet weak var lblData: UILabel!
    
    @IBOutlet weak var shight: NSLayoutConstraint!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
      //  let params : [String: Any]  = ["method":"help"]
        
//        AF.request(url, method: .post, encoding:URLEncoding.httpBody , headers: Constants.headerProd)
//            .responseDecodable(of:AboutSuccessModel.self) { response in
//                switch response.result {
//                case .success(let data):
//                    if MOLHLanguage.currentAppleLanguage() == "en" {
//                        var condsText = data.data?.descriptionEn
//                        // Remove multiple consecutive whitespace characters
//                        print(data.data?[0].conds_en)
//                        condsText = condsText?.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
//                        condsText = condsText?.replacingOccurrences(of: "\r\n\r\n", with: "\n")
//                        print(condsText)
//                        self.lblData.text = condsText
//                    }else {
//                        var condsText = data.data?[0].conds.replacingOccurrences(of: "\t", with: " ") // Replace tabs with spaces
//                        condsText = condsText?.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
//                           condsText = condsText?.replacingOccurrences(of: "\r\n", with: "\n")
//                        print(condsText)
//                           self.lblData.text = condsText
//
//                    }
//                    if MOLHLanguage.currentAppleLanguage() == "en" {
//                        self.lblData.text = self.condsTextEn
//                    }else{
//                        
//                        self.lblData.text = self.condsTextAR
//                    }
//                    self.lblData.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 1.5)
//                    self.shight.constant = self.heightForLabel(self.lblData.text!, self.cscroll.frame.width - 40,self.lblData!.font) + 100
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//
//               }
        }

    func fetchData() {
        guard let url = URL(string:Constants.DOMAIN+"about") else {return}
        
        AF.request(url, method: .post).responseDecodable(of: AboutSuccessModel.self) { response in
            switch response.result {
            case .success(let apiResponse):
                if MOLHLanguage.isArabic(){
                    self.updateLabel(apiResponse.data?.descriptionAr ?? "") // or description_ar based on your requirement
                }else{
                    self.updateLabel(apiResponse.data?.descriptionEn ?? "") // or description_ar based on your requirement

                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func updateLabel(_ text: String) {
        DispatchQueue.main.async {
            self.lblData.text = text
            self.lblData.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 1.5)
            self.shight.constant = self.heightForLabel(self.lblData.text!, self.cscroll.frame.width - 40,self.lblData!.font) + 100
        }
    }

    
    @IBAction func didTapbackButton(){
        dismissDetail()
    }
    
}
extension AboutVC{
    func heightForLabel(_ text:String,_ width:CGFloat
                        ,_ font:UIFont) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        
        let attributedString = NSMutableAttributedString(string: text)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        paragraphStyle.lineHeightMultiple = 1.5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        
        label.sizeToFit()
        return label.frame.height
    }
}

