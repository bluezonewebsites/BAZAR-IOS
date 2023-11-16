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
    
    let condsTextAR = """
    الشروط والأحكام :
    مرحبا بكم في ( تطبيق بازار ) فضلا قراءة الشروط والأحكام بعناية قبل استخدام الموقع الإلكتروني أو التطبيق، تصفحك أو إضافة أي إعلان لدينا يعتبر إقرار منك بقراءة الشروط والأحكام والموافقة عليها.
    تمتلك شركة اشحن للتجارة العامة  تطبيق و موقع ( بازار ) و هي منصة توفر مساحة للإعلانات لمستخدميها (البائعين والمشترين)، ويقتصر دور ( تطبيق بازار ) على توفير مساحة لالتقاء البائع والمشتري بصورة ميسرة، ولا تتحمل ( تطبيق بازار ) أي مسئولية ولا توفر أي ضمان اتجاه المستخدمين بما يتعلق بعمليات البيع والشراء وجودة المنتجات، ولا يتم الرجوع عليها للمطالبة بالتعويض عن أي خسائر.

    تعليمات وقواعد نشر الإعلان:
    يتم إدراج الإعلانات بعد التسجيل برقم الهاتف المحمول والبريد الإلكتروني.
    يجب على المعلن تصنيف الإعلان ونشره تحت القسم الصحيح.
    يجب كتابة عنوان للإعلان ووصف المنتج والسعر وإضافة الصور بشكل صحيح ويجب أن تكون السلعة حقيقة وموجودة.
    يجب أن يكون المعلن هو صاحب السلعة أو الخدمة.
    الإعلانات تكون بصفة شخصية ويمنع نشر إعلانات بصفة تجارية أو نيابة عن الغير، ويمنع نشر الإعلانات الخاصة بالشركات أو المتاجر.
    يحظر نشر إعلانات تحتوي على ألفاظ أو صور مخالفة للآداب العامة أو غير قانونية كذلك يمنع أي إعلان يهدف للتشهير بالأشخاص او المؤسسات.
    يحظر نشر إعلانات بيع الأسلحة بجميع أنواعها سواء كانت مرخصة أو غير مرخصة.
    يكون كل إعلان لسلعة واحدة فقط، وبحال تعدد السلع فيتم إنشاء إعلان مستقل لكل سلعة.
    يمنع نشر الإعلانات الخاصة بالمحامين والتي تهدف لإعلان المحامي عن نفسه أو العمل على جلب الموكلين.
    يحظر نشر الإعلانات المخالفة للقوانين في دولة منشئ الإعلان، وكذلك يحظر نشر الإعلانات المخالفة للقوانين في دولة الكويت وخاصة للقانون رقم 63 لسنة 2015 بشأن مكافحة الجرائم الإلكترونية، والقانون رقم 38 لسنة 2002 بشأن تنظيم إعلان المواد المتعلقة بالصحة، ويحظر نشر إعلانات الأدوية والمنشطات الجنسية.
    يمنع نشر إعلانات التدخين بكافة أنواعها العادية أو الإلكترونية
    يحظر بيع النباتات والحيوانات المهددة بالانقراض الواردة في اتفاقية (سايتس)، التزاما بقرارات ولوائح الهيئة العامة للبيئة.
    يمنع نشر إعلانات العمالة المنزلية بكافة أنواعها وكذلك يمنع نشر إعلانات العمالة الوهمية أو تأجير العمالة للمنازل في الساعات كذلك يمنع نشر كافة أنواع الإتجار بالبشر .
    يمنع نشر أي إعلان  للقمار والمراهنات أو إعلانات السحر والشعوذة
    يمنع نشر أي إعلان للخمور أو المشروبات الروحية بكافة أنواعها - كما تحظر نشر أي اي اعلان للمخدرات والحشيش بكافة أنواعها.
    يحظر عرض وبيع أجهزة التنصت و وسائل التحريض على إساءة استعمال أجهزة الهاتف، وذلك بحسب القانون رقم 9 لسنة 2001 بشأن إساءة استعمال أجهزة الاتصالات الهاتفية وأجهزة التنصت.
    يحظر الإعلان عن سداد القروض والتكييش، وكذلك يحظر الإعلان عن الشقق المفروشة بالساعات أو الإيجار اليومي لغير الشركات المرخص لها بذلك، وتحظر جميع إعلانات جلب الاستثمار والدعوة للاستثمار والمشاركة التجارية ،
    تحتفظ إدارة ( تطبيق بازار) بحق حظر أي رقم هاتف يستخدم التطبيق في الإساءة أو الأضرار بالغير أو بحال استخدام التطبيق لأغراض غير قانونية.
    يراعي المستخدم احترام المتصفحين والمستخدمين الآخرين.
    يمكن للمستخدمين التواصل فيما بينهم من خلال المحادثات ( شات ) والرسائل الصوتية ويمكنهم أيضا التعليقات علي الإعلانات والرد علي التعليق
    ويمكن للمستخدمين الإبلاغ علي المحتوي الغير مناسب او الأشخاص الغير مناسبين بالإضافة الي إمكانية عمل حظر للمستخدمين الغير مناسبين وعدم رؤيتهم او رؤية ما اعلاناتهم او تعليقاتهم
    """
    let condsTextEn = """
    Terms and Conditions :
    Welcome to (Bazar Application). Please read the terms and conditions carefully before using the website or application. Your browsing or adding any of our advertisements is considered your acknowledgment of reading the terms and conditions and agreeing to them.
    Ashhan General Trading Company owns the () application and website, which is a platform that provides space for advertisements for its users (buyers and sellers). The role of (Bazar Application) is limited to providing a space for the seller and buyer to meet in an easy manner. (Bazar Application) does not bear any responsibility and does not provide any guarantee. The direction of users regarding buying and selling operations and the quality of products, and they are not subject to recourse to claim compensation for any losses.

    Instructions and rules for publishing the advertisement:
    Advertisements are inserted after registration with mobile number and email.
    The advertiser must classify the ad and publish it under the correct section.
    The title of the advertisement, product description, price, and pictures must be written correctly, and the item must be real and present.
    The advertiser must be the owner of the good or service.
    Advertisements must be in a personal capacity. It is prohibited to publish advertisements in a commercial capacity or on behalf of others. It is prohibited to publish advertisements for companies or stores.
    It is prohibited to publish advertisements that contain words or images that violate public morals or are illegal. It is also prohibited to publish any advertisement that aims to defame people or institutions.
    It is prohibited to publish advertisements for the sale of weapons of all types, whether licensed or unlicensed.
    Each advertisement is for one commodity only, and in the event of multiple commodities, a separate advertisement is created for each commodity.
    It is prohibited to publish advertisements for lawyers that aim to advertise the lawyer himself or work to attract clients.
    It is prohibited to publish advertisements that violate the laws in the country of the advertisement’s creator. It is also prohibited to publish advertisements that violate the laws in the State of Kuwait, especially Law No. 63 of 2015 regarding combating electronic crimes, and Law No. 38 of 2002 regarding regulating the advertisement of health-related materials. It is prohibited to publish advertisements for medicines and sexual stimulants.
    It is prohibited to publish smoking advertisements of all kinds, whether physical or electronic
    It is prohibited to sell endangered plants and animals mentioned in the CITES agreement, in compliance with the decisions and regulations of the Environment Public Authority.
    It is prohibited to publish advertisements for domestic workers of all kinds. It is also prohibited to publish advertisements for fake labor or for renting workers to homes during hours. It is also prohibited to publish all types of human trafficking.
    It is prohibited to publish any advertisements for gambling, betting, or advertisements for magic and sorcery
    It is prohibited to publish any advertisement for wines or spirits of all kinds - and it is also prohibited to publish any advertisement for drugs and hashish of all kinds.
    It is prohibited to offer and sell eavesdropping devices and means of inciting the misuse of telephone devices, in accordance with Law No. 9 of 2001 regarding the misuse of telephone communications devices and eavesdropping devices.
    It is prohibited to advertise the repayment of loans and air conditioning, and it is also prohibited to advertise furnished apartments for hours or daily rent to anyone other than companies licensed to do so, and all advertisements attracting investment and calling for investment and commercial participation are prohibited.
    (Bazar Application) management reserves the right to block any phone number that uses the application to abuse or harm others or if the application is used for illegal purposes.
    The user is respectful of other browsers and users.
    Users can communicate with each other through chat and voice messages, and they can also comment on advertisements and respond to comments
    Users can report inappropriate content or inappropriate people, in addition to the possibility of blocking inappropriate users and not seeing them or seeing their ads or comments.
    """
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        
        guard let url = URL(string:Constants.DOMAIN+"about") else {return}
        AF.request(url, method: .post, encoding:URLEncoding.httpBody , headers: Constants.headerProd)
            .responseDecodable(of:AboutSuccessModel.self) { response in
                switch response.result {
                case .success(let data):
//                    print(data.data?[0].about)
                    if MOLHLanguage.currentAppleLanguage() == "en" {
                     var condsText = data.data?[0].conds_en.replacingOccurrences(of: "\t", with: " ") // Replace tabs with spaces
                        // Remove multiple consecutive whitespace characters
                        condsText = condsText?.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
                        condsText = condsText?.replacingOccurrences(of: "\r\n", with: "\n")
                        print(condsText)
                        self.lblData.text = condsText
                    }else {
                        var condsText = data.data?[0].conds.replacingOccurrences(of: "\t", with: " ") // Replace tabs with spaces
                        condsText = condsText?.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)

                           condsText = condsText?.replacingOccurrences(of: "\r\n", with: "\n")
                           self.lblData.text = condsText

                    }
//                    if MOLHLanguage.currentAppleLanguage() == "en" {
//                        self.lblData.text = self.condsTextEn
//                    }else{
//
//                        self.lblData.text = self.condsTextAR
//                    }
                    
                    self.lblData.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 1.5)
                    self.shight.constant = self.heightForLabel(self.lblData.text!, self.cscroll.frame.width - 40,self.lblData!.font) + 100
                case .failure(let error):
                    print(error.localizedDescription)
                }

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
