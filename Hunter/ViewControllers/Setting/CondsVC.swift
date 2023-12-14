//
//  as.swift
//  Bazar
//
//  Created by iOSayed on 03/06/2023.
//

import UIKit
import Alamofire
import MOLH

class CondsVC: ViewController {
    @IBOutlet weak var hdr: UIView!

    @IBOutlet weak var cscroll: UIScrollView!
    
    @IBOutlet weak var lblData: UILabel!
    
    @IBOutlet weak var shight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    func convertHTMLStringToAttributedString(htmlString: String) -> NSAttributedString? {
        guard let data = htmlString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        return try? NSAttributedString(data: data, options: options, documentAttributes: nil)
    }

    
    
    func fetchData() {
        guard let url = URL(string:Constants.DOMAIN+"terms_conditions") else {return}
        
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
        DispatchQueue.main.async {[weak self] in
            guard let self else {return}
            if let attributedString = convertHTMLStringToAttributedString(htmlString: text) {
                lblData.attributedText = attributedString
                lblData.numberOfLines = 0
                lblData.lineBreakMode = .byWordWrapping
                lblData.font = .systemFont(ofSize: 18)
                lblData.sizeToFit()
                let contentSizeHeight = self.lblData.frame.size.height + 100
                self.shight.constant = contentSizeHeight            }

//            self.lblData.text = text
//            self.lblData.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 1.5)
//            self.shight.constant = self.heightForLabel(self.lblData.text!, self.cscroll.frame.width - 40,self.lblData!.font) + 100
        }
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismissDetail()
    }
    
}

extension CondsVC{
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
