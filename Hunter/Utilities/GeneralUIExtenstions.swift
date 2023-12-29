//
//  GeneralUIExtenstions.swift
//  WeasyVendor
//
//  Created by Amal Elgalant on 1/27/20.
//  Copyright © 2020 Amal Elgalant. All rights reserved.
//

import UIKit
import MOLH
// MARK: -UIView

@IBDesignable extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var topLeft: Bool {
        get { return layer.maskedCorners.contains(.layerMinXMinYCorner) }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMinXMinYCorner)
            } else {
                layer.maskedCorners.remove(.layerMinXMinYCorner)
            }
        }
    }

    @IBInspectable var topRight: Bool {
        get { return layer.maskedCorners.contains(.layerMaxXMinYCorner) }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMaxXMinYCorner)
            } else {
                layer.maskedCorners.remove(.layerMaxXMinYCorner)
            }
        }
    }

    @IBInspectable var bottomLeft: Bool {
        get { return layer.maskedCorners.contains(.layerMinXMaxYCorner) }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMinXMaxYCorner)
            } else {
                layer.maskedCorners.remove(.layerMinXMaxYCorner)
            }
        }
    }

    @IBInspectable var bottomRight: Bool {
        get { return layer.maskedCorners.contains(.layerMaxXMaxYCorner) }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMaxXMaxYCorner)
            } else {
                layer.maskedCorners.remove(.layerMaxXMaxYCorner)
            }
        }
    }
    
    
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension UIView {
    
    /// loads a full view from a xib file
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIView>() -> T {
            UINib(nibName: "\(T.self)", bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
        }
        return instantiateFromNib()
    }
    func flipX() {
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    
    func flipY() {
        transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
    }
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
    func generateThumbnailImage(url:URL) -> UIImage {
           let asset = AVAsset(url: url)
           let imageGenerator = AVAssetImageGenerator(asset: asset)
           imageGenerator.appliesPreferredTrackTransform = true

           do {
               let thumbnailCGImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
               let thumbnailImage = UIImage(cgImage: thumbnailCGImage)
               return  thumbnailImage
           } catch {
               print("Failed to generate thumbnail image: \(error)")
               return UIImage()
           }
       }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 1.0
        animation.repeatCount = 3
        animation.values = [15.0, -15.0, 15.0, -15.0, 10.0, -10.0, 5.0, -5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func apply_right_bubble() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func hideMe(){
        self.isHidden = true
    }
    
    func showMe(){
        self.isHidden = false
    }
    func shadow(_ height:Int = 3,_ opcity:Float = 0.5){
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: height);
        layer.shadowOpacity = opcity
        layer.shadowPath = shadowPath.cgPath
    }
}

@IBDesignable
class DesignableUITextField: UITextField {
    
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}
extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}
//extension UITextField{
//
//    @IBInspectable var fontAccessory: Bool{
//        get{
//            return self.fontAccessory
//        }
//        set (hasDone) {
//            if hasDone{
//                self.font = UIFont(name: NSLocalizedString("Cairo",comment:""), size: self.font!.pointSize)
//            }
//            else{
//                self.font = UIFont(name: NSLocalizedString("Cairo",comment:""), size: self.font!.pointSize)
//            }
//        }
//    }
//
//}
extension UILabel {
    var substituteFontName : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.description == "Regular" {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
    var substituteFontNameBold : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.range(of:"-Bd") != nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
}
extension UITextField {
    var substituteFontName : String {
        get { return self.font!.fontName }
        set { self.font = UIFont(name: newValue, size: 14) }
    }
    
    func setPlaceHolderColor(_ color:UIColor){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}

extension UIFont {
    class func appRegularFontWith( size:CGFloat ) -> UIFont{
        return  UIFont(name: "Cairo-Regular", size: size)!
    }
    class func appBoldFontWith( size:CGFloat ) -> UIFont{
        return  UIFont(name: "Cairo-Bold", size: size)!
    }
    class func appSemiBoldFontWith( size:CGFloat ) -> UIFont{
        return  UIFont(name: "Cairo-SemiBold", size: size)!
    }
}
extension UIButton {
    func loadingIndicator(_ show: Bool) {
        let tag = 808404
        if show {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
extension UIImage {
    
    func resizeByByte(maxByte: Int, completion: @escaping (Data) -> Void) {
        var compressQuality: CGFloat = 1
        var imageData = Data()
        var imageByte = self.jpegData(compressionQuality: 1)?.count
        
        while imageByte! > maxByte {
            imageData = self.jpegData(compressionQuality: compressQuality)!
            imageByte = self.jpegData(compressionQuality: compressQuality)?.count
            compressQuality -= 0.1
        }
        
        if maxByte > imageByte! {
            completion(imageData)
        } else {
            completion(self.jpegData(compressionQuality: 1)!)
        }
    }
    
    
}

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            guard let url = URL(string: url) else {
                  return
              }
            if application.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    application.open(url, options: [:], completionHandler: nil)
                }
                else {
                    application.openURL(url)
                }
                return
            }
        }
    }
}
extension UIScrollView {
//    func scrollToTop() {
//        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
//        setContentOffset(desiredOffset, animated: true)
//   }
    
    func showEmptyListMessage(_ message:String) {
           let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
        
        
        
           let messageLabel = UILabel(frame: rect)
           messageLabel.text = message
           messageLabel.textColor = .black
           messageLabel.numberOfLines = 0
           messageLabel.textAlignment = .center
           messageLabel.font = UIFont(name: "Roboto-Bold", size: 16)
           messageLabel.sizeToFit()

           if let `self` = self as? UITableView {
               self.backgroundView = messageLabel
               self.separatorStyle = .none
           } else if let `self` = self as? UICollectionView {
               self.backgroundView = messageLabel
           }
       }
}
extension String {
    
    ///
    /// Localize the current string to the selected language
    ///
    /// - returns: The localized string
    ///
    func localiz() -> String {
        var currentLanguage = MOLHLanguage.currentAppleLanguage()
       
        guard let bundle = Bundle.main.path(forResource:currentLanguage, ofType: "lproj") else {
            return NSLocalizedString(self, comment: "")
        }
        
        let langBundle = Bundle(path: bundle)
        return NSLocalizedString(self, tableName: nil, bundle: langBundle!, comment: "")
    }
    
    
    
    
    var formatAddress:[String:String]{
        var map = [String:String]()
        var subloc:String = ""
        let new_loc = self.replacingOccurrences(of: "،Unnamed Road", with: "").replacingOccurrences(of: ",Unnamed Road", with: "").replacingOccurrences(of: "Unnamed Road", with: "شارع غير معروف")
        
        if new_loc.contains(","){
            let n = new_loc.components(separatedBy: ",")
            map["main"] = n[0]
            for i in 1...n.count-1 {
                subloc.append("\(n[i]) - ")
            }
            map["sub"] = String((subloc.dropLast(2)))
        }else if new_loc.contains("،"){
            let n = new_loc.components(separatedBy: "،")
            map["main"] = n[0]
            for i in 1...n.count-1 {
                subloc.append("\(n[i]) - ")
            }
            map["sub"] = String((subloc.dropLast(2)))
            
        }else{
            map["main"] = new_loc
            map["sub"] = ""
        }
        return map
    }
    func replace(_ target: String,_ withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString)
    }
    
    var formattedDateSince: String {
        return diffDates(GetDateFromString(self)).replace("-","")
    }
    
    var formattedDate: String {
        return diffDates(GetDateFromString(self)).replace("-","")
    }
    
    func diffDates(_ dateRangeEnd:Date) -> String {
        let dateRangeStart = Date()
        return dateDiff(dateRangeStart, dateRangeEnd)
    }
    
    func dateDiff(_ dateRangeStart:Date , _ dateRangeEnd:Date) -> String {
        var result = ""
        let components = Calendar.current.dateComponents([.month,.day,.hour,.minute,.second], from: dateRangeStart, to: dateRangeEnd)
        // print("diffrent  time  ======> ",components)
        
        if let months = components.month , let days = components.day, let hours  = components.hour , let minutes = components.minute , let seconds = components.second {
            if( months != 0){
                print(months)
                result = "\(months) \("month".localize)"
                //  return "\(months) شهر"
            }else if(days != 0){
                print(days)
                if (days % 7) > 0 {
                    let weeks =  (days % 7)
                    result = "\(weeks) \("week".localize)"
                }else{
                    result = "\(days ) \("day".localize)"
                }
                //  return "\(days ) يوم"
                
            }else if(hours != 0){
                print(hours)
                result = "\(hours) \("hours".localize)"
                //return "\(hours) ساعة"
            }else if(minutes != 0){
                print(minutes)
                result = "\(minutes) \("minutes".localize)"
                //   return "\(minutes) دقيقة"
            }else{
                print(seconds)
                result = "\(seconds) \("seconds".localize)"
                // return "\(seconds) ثانية"
            }
        }
        return result
    }
    
//    func dateDiff(_ dateRangeStart:Date , _ dateRangeEnd:Date) -> String {
//        let components = Calendar.current.dateComponents([.month,.day,.hour,.minute,.second], from: dateRangeStart, to: dateRangeEnd)
//        if(components.month != 0){
//            return "\(components.month ?? 0) شهر"
//        }else if(components.day != 0){
//            return "\(components.day ?? 0) يوم"
//        }else if(components.hour != 0){
//            return "\(components.hour ?? 0) ساعة"
//        }else if(components.day != 0){
//            return "\(components.minute ?? 0) دقيقة"
//        }else{
//            return "\(components.second ?? 0) ثانية"
//        }
//    }
    
    func GetDateFromString(_ DateStr: String)-> Date
    {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        let DateArray = DateStr.components(separatedBy: " ")
        let part1 = DateArray[0].components(separatedBy: "-")
        let part2 = DateArray[1].components(separatedBy: ":")
        let components = NSDateComponents()
        components.year = Int(part1[0])!
        components.month = Int(part1[1])!
        components.day = Int(part1[2])!
        components.hour = Int(part2[0])!
        components.minute = Int(part2[1])!
        components.second = Int(part2[2].components(separatedBy: ".")[0])!
        components.timeZone = TimeZone(abbreviation: "UTC")
        let date = calendar?.date(from: components as DateComponents)
        
        return date!
    }
    
    var toUrl: URL {
        let encoded = addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        return URL(string: encoded!)!
    }
 
}



import UIKit
import MOLH
import SDWebImage
import AVFoundation

extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0;

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        badgeLayer?.removeFromSuperlayer()
        
        var badgeWidth = 8
        var numberOffset = 4
        
        if number > 9 {
            badgeWidth = 12
            numberOffset = 6
        }
        
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(7)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.fontSize = 11
        label.frame = CGRect(origin: CGPoint(x: location.x - CGFloat(numberOffset), y: offset.y), size: CGSize(width: badgeWidth, height: 16))
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}
class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            if textAlignment == .natural {
                self.textAlignment = .right
            }
            else if textAlignment == .left {
                self.textAlignment = .right
            }
            else if textAlignment == .right {
                self.textAlignment = .right
            }
            
        }
        else{
            if textAlignment == .natural {
                self.textAlignment = .left
            }
            else if textAlignment == .left {
                self.textAlignment = .left
            }
            else if textAlignment == .right {
                self.textAlignment = .left
            }
        }
    }
}
extension UILabel {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            if textAlignment == .natural {
                self.textAlignment = .right
            }
            else if textAlignment == .left {
                self.textAlignment = .right
            }
            else if textAlignment == .right {
                self.textAlignment = .right
            }
            
        }
        else{
            if textAlignment == .natural {
                self.textAlignment = .left
            }
            else if textAlignment == .left {
                self.textAlignment = .left
            }
            else if textAlignment == .right {
                self.textAlignment = .left
            }
        }
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 1, lineHeightMultiple: CGFloat = 1.5,alignment:NSTextAlignment = .natural) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = .byTruncatingTail
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
extension UIImageView{
    func setImageWithLoading(url: String,placeholder:String? = "placeHolderImage"){
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        print("\(Constants.IMAGE_URL)\(url)")
        let placeholderImage = (placeholder != nil) ? UIImage(named: placeholder!) : UIImage(named: "placeHolderImage")
        print("\(Constants.IMAGE_URL)\(url)")
        self.sd_setImage(with: URL(string: "\(Constants.IMAGE_URL)\(url)"),placeholderImage: placeholderImage)
    }
    
    
    func setImageWithLoadingFromMainDomain(url: String,placeholder:String? = "placeHolderImage"){
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        print("\(Constants.IMAGE_URL)\(url)")
        let placeholderImage = (placeholder != nil) ? UIImage(named: placeholder!) : UIImage(named: "placeHolderImage")
        print("\(Constants.IMAGE_URL)\(url)")
        self.sd_setImage(with: URL(string: "\(Constants.MAIN_DOMAIN)\(url)"),placeholderImage: placeholderImage)
    }
    
    func localImg(src:String){
        if(src == ""){
            self.image = nil
        }else{
            self.image = UIImage(named:src)
        }
    }
   
}
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        //        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

extension UITableView {
    
    func registerCell<Cell: UITableViewCell>(cell: Cell.Type){
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellReuseIdentifier: String(describing: Cell.self))
    }
    
    
    func dequeue<Cell: UITableViewCell>(inx:IndexPath) -> Cell{
        let identifier = String(describing: Cell.self)
        
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: inx) as? Cell else {
            fatalError("Error in cell")
        }
        
        return cell
    }
    
    //    func configure(top:CGFloat=0,bottom:CGFloat=0,left:CGFloat=0,
    //                   right:CGFloat=0,vspace:CGFloat=0,hspace:CGFloat=0,scroll:ScrollDirection = .vertical){
    //        let layout: uitable = UICollectionViewFlowLayout()
    //        layout.sectionInset = UIEdgeInsets(top: top, left:left, bottom: bottom, right: right)
    //        layout.scrollDirection = scroll
    //        layout.minimumInteritemSpacing = vspace
    //        layout.minimumLineSpacing = hspace
    //    }
    
    
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.1, animations: { self.reloadData()})
        {_ in completion() }
    }
    
    func getAllCells() -> [UITableViewCell] {
        
        var cells = [UITableViewCell]()
        // assuming tableView is your self.tableView defined somewhere
        
        for i in 0...self.numberOfSections-1
        {
            for j in 0...self.numberOfRows(inSection: i) - 1
            {
                if let cell = self.cellForRow(at: NSIndexPath(row: j, section: i) as IndexPath) {
                    
                    cells.append(cell)
                }
                
            }
        }
        return cells
    }
}
//extension UITextView: UITextViewDelegate {
//
//    /// Resize the placeholder when the UITextView bounds change
//    override open var bounds: CGRect {
//        didSet {
//            self.resizePlaceholder()
//        }
//    }
//
//    /// The UITextView placeholder text
//    public var placeholderExt: String? {
//        get {
//            var placeholderText: String?
//
//            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
//                placeholderText = placeholderLabel.text
//            }
//
//            return placeholderText
//        }
//        set {
//            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
//                placeholderLabel.text = newValue
//                placeholderLabel.sizeToFit()
//            } else {
//                self.addPlaceholder(newValue!)
//            }
//        }
//    }
//
//    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
//    ///
//    /// - Parameter textView: The UITextView that got updated
//    public func textViewDidChange(_ textView: UITextView) {
//        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
//            placeholderLabel.isHidden = !self.text.isEmpty
//        }
//    }
//
//    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
//    private func resizePlaceholder() {
//        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
//            placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
//
//            NSLayoutConstraint.deactivate(placeholderLabel.constraints) // Remove any existing constraints
//
//            let labelX = self.textContainer.lineFragmentPadding
//            let labelY = self.textContainerInset.top - 2
//            let labelWidth = self.frame.width - (labelX * 2)
//            placeholderLabel.textAlignment = .natural
//            placeholderLabel.numberOfLines = 0
//            // Add new constraints
//
//            var constraints = [NSLayoutConstraint]()
//            constraints = [
//               placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
//               placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
//               placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
//               placeholderLabel.heightAnchor.constraint(equalToConstant: placeholderLabel.frame.height)
//           ]
////            if MOLHLanguage.currentAppleLanguage() == "en"{
////                placeholderLabel.contentMode = .topLeft
////                constraints = [
////                   placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
////                   placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
////                   placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
////                   placeholderLabel.heightAnchor.constraint(equalToConstant: self.frame.height)
////               ]
////            }else{
////
////            }
//
//            NSLayoutConstraint.activate(constraints)
//        }
//    }
//
//    /// Adds a placeholder UILabel to this UITextView
//    private func addPlaceholder(_ placeholderText: String) {
//        let placeholderLabel = UILabel()
//        placeholderLabel.numberOfLines = 0
//
//        placeholderLabel.text = placeholderText
//        placeholderLabel.sizeToFit()
//
//        placeholderLabel.font = self.font
//        placeholderLabel.textColor = UIColor.lightGray
//        placeholderLabel.tag = 100
//
//        placeholderLabel.isHidden = !self.text.isEmpty
//
//        self.addSubview(placeholderLabel)
//        self.resizePlaceholder()
//        self.delegate = self
//    }
//
//}

extension UITextView {
    func addPlaceholder(_ placeholder: String , text textViewString:String) {
       
        let placeholderLabel = UILabel()
        placeholderLabel.removeFromSuperview()
        placeholderLabel.numberOfLines = 0
        placeholderLabel.text = placeholder
        placeholderLabel.textAlignment = .natural
        placeholderLabel.lineBreakMode = .byWordWrapping
        placeholderLabel.font = UIFont.systemFont(ofSize: 13)

        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 999
        placeholderLabel.isHidden = !self.text.isEmpty

        self.addSubview(placeholderLabel)
        self.resizePlaceholderLabel(placeholderLabel)

        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextView.textDidChangeNotification, object: nil)
        if let sessionData = UserDefaults.standard.dictionary(forKey: "postSessionData"){
            let description = sessionData["description"] as? String
            if let placeholderLabel = self.viewWithTag(999) as? UILabel {
                print(description)
                if description == "" {
                    placeholderLabel.isHidden = false
                }else {
                    placeholderLabel.isHidden = true
                }
            }
        }
        
     
    }

    private func resizePlaceholderLabel(_ placeholderLabel: UILabel) {
                    
                    
                    placeholderLabel.textAlignment = .natural
                    placeholderLabel.numberOfLines = 0
                    placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
               // Add new constraints
               NSLayoutConstraint.activate([
//                   placeholderLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//                   placeholderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                   placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                   placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                   placeholderLabel.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 0),
                   placeholderLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: 0)
//                   placeholderLabel.heightAnchor.constraint(equalToConstant: self.bounds.height)
               ])
    }

    @objc private func textChanged() {
        if let placeholderLabel = self.viewWithTag(999) as? UILabel {
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }
}

extension UICollectionView {
    func configure(top:CGFloat=0,bottom:CGFloat=0,left:CGFloat=0,
                   right:CGFloat=0,vspace:CGFloat=0,hspace:CGFloat=0,scroll:ScrollDirection = .vertical){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: top, left:left, bottom: bottom, right: right)
        layout.scrollDirection = scroll
        layout.minimumInteritemSpacing = vspace
        layout.minimumLineSpacing = hspace
        self.collectionViewLayout = layout
    }
}

extension Notification.Name {
    static let userIDNotification = Notification.Name("UserIDNotification")
    static let loadUserRate = Notification.Name("loadUserRate")
}

extension Optional where Wrapped == String {
    var safeValue: String {
        return self ?? ""
    }
    
}
extension Optional where Wrapped == Int {
    var safeValue: Int {
        return self ?? 100
    }
    
}


extension Notification.Name{
    static let countryDidChange = Notification.Name("countryDidChange")

}
