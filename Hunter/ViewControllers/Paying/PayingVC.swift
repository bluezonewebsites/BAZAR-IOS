//
//  PayingVC.swift
//  Bazar
//
//  Created by iOSayed on 07/09/2023.
//

import UIKit
import WebKit
import MFSDK

protocol PayingDelegate:AnyObject{
    func didPayingSuccess()
    func passPaymentStatus(from PaymentStatus:String,invoiceId:String,invoiceURL:String,prodId:Int)
}

protocol PayingPlanDelegate:AnyObject{
    func didPayingSuccess()
    func passPaymentStatus(from PaymentStatus:String,invoiceId:String,invoiceURL:String,userId:Int,planCategoryId:Int)
}
class PayingVC: UIViewController {
    
    
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var payButton: UIButton!
    
    
    //MARK: Variables
    var paymentMethods: [MFPaymentMethod]?
    var selectedPaymentMethodIndex: Int?
    
    var paymentId = ""
    var urlString:String = ""
    var isSuccess = false
    var isFeaturedAd = false
    weak var delegate:PayingDelegate?
    weak var planDelegate:PayingPlanDelegate?
    var amountDue:String = ""
    private var invoiceId = ""
    var planCategoryId = 0
    var prodId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MFSettings.shared.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        initiatePayment()
        
        print(prodId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
    }
    
    // MARK: - Navigation
    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func didTapConfirmPayment(_ sender: UIButton) {
    }
    
    @IBAction func didTapPay(_ sender: UIButton) {
        if let paymentMethods = paymentMethods, !paymentMethods.isEmpty {
            if let selectedIndex = selectedPaymentMethodIndex {
                
                if paymentMethods[selectedIndex].paymentMethodCode == MFPaymentMethodCode.applePay.rawValue {
                    executeApplePayPayment(paymentMethodId: paymentMethods[selectedIndex].paymentMethodId)
                } else if paymentMethods[selectedIndex].isDirectPayment {
                    executeDirectPayment(paymentMethodId: paymentMethods[selectedIndex].paymentMethodId)
                } else {
                    executePayment(paymentMethodId: paymentMethods[selectedIndex].paymentMethodId)
                }
            }
        }
    }
    
   
    
//    private func getPaymetStatus(){
//        let paymentStatusRequest = MFPaymentStatusRequest(invoiceID: invoiceId)
////        let paymentStatusRequest = MFPaymentStatusRequest(id: "id", keyType: .invoiceId)
//        MFPaymentRequest.shared.getPaymentStatus(paymentStatus: paymentStatusRequest, apiLanguage: .english) { [weak self] (response) in
//            guard let self else {return}
//                switch response {
//                    case .success(let paymentStatusResponse):
//                    
//                  
//                    if paymentStatusResponse.invoiceStatus ?? "" == "Paid"{
//                        if isFeaturedAd {
//                        
//                            delegate?.passPaymentStatus(from: paymentStatusResponse.invoiceStatus ?? "", invoiceId: "\(paymentStatusResponse.invoiceID ?? 0)", invoiceURL: "", prodId:prodId)
//                        }else {
////                            planDelegate?.didPayingSuccess()
//                            planDelegate?.passPaymentStatus(from: paymentStatusResponse.invoiceStatus ?? "", invoiceId: "\(paymentStatusResponse.invoiceID ?? 0)", invoiceURL: "", userId: AppDelegate.currentUser.id ?? 0, planCategoryId:planCategoryId )
//                        }
//                    }else{
//                        StaticFunctions.createInfoAlert(msg: paymentStatusResponse.invoiceStatus ?? "")
//                        print(" Status is : ======>  \(paymentStatusResponse.invoiceStatus ?? "")")
//                    }
//                    case .failure(let failError):
//                        print("\(failError)")
//                }
//        }
//    }
    
    
    func sendPayment() {
        let request = getSendPaymentRequest()
        
        MFPaymentRequest.shared.sendPayment(request: request, apiLanguage: .arabic) { [weak self] (result) in
            guard let self else {return}
            switch result {
            case .success(let sendPaymentResponse):
                if let invoiceURL = sendPaymentResponse.invoiceURL {
                    print("Success")
                    print(invoiceURL)
                    print("result: send this link to your customers \(invoiceURL)")
                }
            case .failure(let failError):
                print("Error: \(failError)")
            }
            
        }
    }
    
    func getSendPaymentRequest() -> MFSendPaymentRequest {
        let invoiceValue = Decimal(string: amountDue ) ?? 0
        let request = MFSendPaymentRequest(invoiceValue: invoiceValue, notificationOption: .link, customerName: "Elsayed Ahmed")
        //request.userDefinedField = ""
        request.customerEmail = "elsayed1ahmed0@gmail.com"// must be email
        request.customerMobile = "01116064003"//Required
        request.customerCivilId = ""
        request.mobileCountryIsoCode = MFMobileCountryCodeISO.kuwait.rawValue
        request.customerReference = ""
        let address = MFCustomerAddress(block: "ddd", street: "sss", houseBuildingNo: "sss", address: "sss", addressInstructions: "sss")
        request.customerAddress = address
        request.displayCurrencyIso = .kuwait_KWD
        let date = Date().addingTimeInterval(1000)
        request.expiryDate = date
        return request
    }
}
extension PayingVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let paymentMethods = paymentMethods else {
            return 0
        }
        print(paymentMethods.count)
        return paymentMethods.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PaymentMethodCollectionViewCell
        if let paymentMethods = paymentMethods, !paymentMethods.isEmpty {
            let selectedIndex = selectedPaymentMethodIndex ?? -1
            cell.configure(paymentMethod: paymentMethods[indexPath.row], selected: selectedIndex == indexPath.row)
        }
        return cell
    }
    
}

extension PayingVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPaymentMethodIndex = indexPath.row
        payButton.isEnabled = true
        
        if let paymentMethods = paymentMethods {
            if paymentMethods[indexPath.row].isDirectPayment {
            } else {
            }
        }
        collectionView.reloadData()
    }
}


extension PayingVC{
    private func generateInitiatePaymentModel() -> MFInitiatePaymentRequest {
        // you can create initiate payment request with invoice value and currency
        // let invoiceValue = Double(amountTextField.text ?? "") ?? 0
        // let request = MFInitiatePaymentRequest(invoiceAmount: invoiceValue, currencyIso: .kuwait_KWD)
        // return request
        
        let request = MFInitiatePaymentRequest()
        return request
    }
    
    func executePayment(paymentMethodId: Int) {
        let request = getExecutePaymentRequest(paymentMethodId: paymentMethodId)
        
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .arabic) { [weak self] response, invoiceId  in
            guard let self else {return}
            switch response {
            case .success(let executePaymentResponse):
                
                if let invoiceStatus = executePaymentResponse.invoiceStatus {
                   
                    if invoiceStatus == "Paid"{
                        if isFeaturedAd {
                        
                            delegate?.passPaymentStatus(from: executePaymentResponse.invoiceStatus ?? "", invoiceId: "\(executePaymentResponse.invoiceID ?? 0)", invoiceURL: "----------", prodId:prodId)
                        }else {
    //                            planDelegate?.didPayingSuccess()
                            planDelegate?.passPaymentStatus(from: executePaymentResponse.invoiceStatus ?? "", invoiceId: "\(executePaymentResponse.invoiceID ?? 0)", invoiceURL: "----------", userId: AppDelegate.currentUser.id ?? 0, planCategoryId:planCategoryId )
                        }
                    }else{
                        StaticFunctions.createInfoAlert(msg: invoiceStatus)
                        print(" Status is : ======>  \(invoiceStatus)")
                    }
                }
            case .failure(let failError):
                print(failError)
            }
        }
    }

    func initiatePayment() {
        let request = generateInitiatePaymentModel()
        MFPaymentRequest.shared.initiatePayment(request: request, apiLanguage: .english, completion: { [weak self] (result) in
            switch result {
            case .success(let initiatePaymentResponse):
                self?.paymentMethods = initiatePaymentResponse.paymentMethods
                self?.collectionView.reloadData()
            case .failure(let failError):
                print(failError)
            }
        })
    }
    
    private func getExecutePaymentRequest(paymentMethodId: Int) -> MFExecutePaymentRequest {
        let invoiceValue = Decimal(string: amountDue) ?? 0
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue , paymentMethod: paymentMethodId)
        //request.userDefinedField = ""
        request.customerEmail = AppDelegate.currentUser.email.safeValue
        request.customerMobile = AppDelegate.currentUser.phone.safeValue
        request.customerCivilId = "\(AppDelegate.currentUser.id ?? 0)"
        request.customerName = AppDelegate.currentUser.name.safeValue
        let address = MFCustomerAddress(block: AppDelegate.currentUser.regionsNameEn.safeValue, street: AppDelegate.currentUser.citiesNameAr.safeValue, houseBuildingNo: "", address: AppDelegate.currentUser.countriesNameEn.safeValue, addressInstructions: "sss")
        request.customerAddress = address
        request.customerReference = "BAAZAR_USER_ID_\(AppDelegate.currentUser.id ?? 0)"
        request.language = .english
        request.mobileCountryCode = MFMobileCountryCodeISO.kuwait.rawValue
        request.displayCurrencyIso = .kuwait_KWD
        return request
    }
    
    func executeDirectPayment(paymentMethodId: Int) {
        let request = getExecutePaymentRequest(paymentMethodId: paymentMethodId)
//        let card = getCardInfo()
        
//        MFPaymentRequest.shared.executeDirectPayment(request: request, cardInfo: card, apiLanguage: .english) { [weak self] (response, invoiceId) in
//            
//            switch response {
//            case .success(let directPaymentResponse):
//                if let cardInfoResponse = directPaymentResponse.cardInfoResponse, let card = cardInfoResponse.cardInfo {
//                  //  self?.resultTextView.text = "Status: with card number: \(card.number ?? "")"
//                }
//                if let invoiceId = invoiceId {
////                    self?.errorCodeLabel.text = "Success with invoice id \(invoiceId)"
//                } else {
////                    self?.errorCodeLabel.text = "Success"
//                }
//            case .failure(let failError):
////                self?.resultTextView.text = "Error: \(failError.errorDescription)"
//                if let invoiceId = invoiceId {
////                    self?.errorCodeLabel.text = "Fail: \(failError.statusCode) with invoice id \(invoiceId)"
//                } else {
////                    self?.errorCodeLabel.text = "Fail: \(failError.statusCode)"
//                }
//            }
//        }
    }
    func executeApplePayPayment(paymentMethodId: Int) {
        let request = getExecutePaymentRequest(paymentMethodId: paymentMethodId)
        
        if #available(iOS 13.0, *) {
            MFPaymentRequest.shared.executeApplePayPayment(request: request, apiLanguage: .arabic) { [weak self] (response, invoiceId) in
                guard let self else {return}
                switch response {
                case .success(let executePaymentResponse):
                    if let invoiceStatus = executePaymentResponse.invoiceStatus {

                    }
                case .failure(let failError):

                    print(failError)
                }
            }
        }
    }

}

extension PayingVC:MFPaymentDelegate {
    func didInvoiceCreated(invoiceId: String) {
        print(invoiceId)
        self.invoiceId = invoiceId
        
    }
}


