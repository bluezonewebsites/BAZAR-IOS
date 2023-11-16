//
//  PayingVC.swift
//  Bazar
//
//  Created by iOSayed on 07/09/2023.
//

import UIKit
import WebKit

protocol PayingDelegate:AnyObject{
    func didPayingSuccess()
    func passPaymentId(with paymentId:String)
}

protocol PayingPlanDelegate:AnyObject{
    func didPayingSuccess()
    func passPaymentId(with paymentId:String)
}
class PayingVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var paymentId = ""
    var urlString:String = ""
    var isSuccess = false
    var isFeaturedAd = false
    weak var delegate:PayingDelegate?
    weak var planDelegate:PayingPlanDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        webView.navigationDelegate = self
        // Load a URL
             if let url = URL(string: urlString) {
                 let request = URLRequest(url: url)
                 webView.load(request)
                 
             }
         
    }
    

    // MARK: - Navigation
    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func fetchInvoiceStatus(from url: URL) {
//        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch data: \(error)")
                return
            }
            
            if let data = data {
                do {
                    if let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                       let dataObj = jsonObj["Data"] as? [String: Any],
                       let invoiceStatus = dataObj["InvoiceStatus"] as? String {
                        
                        print(invoiceStatus)
                        // Now you have 'invoiceStatus' to check if user actually paid or not
                        DispatchQueue.main.async {
                            if invoiceStatus == "Paid" {
                                // Payment was successful, show SuccessfulVC
                                if self.isFeaturedAd {
                                    self.delegate?.didPayingSuccess()
                                    self.delegate?.passPaymentId(with: self.paymentId )
                                }else{
                                    self.planDelegate?.didPayingSuccess()
                                    self.planDelegate?.passPaymentId(with: self.paymentId)
                                }
                                
                                self.navigationController?.popViewController(animated: true)
                                
                            }else{
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                } catch {
                    print("Failed to parse JSON: \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    

}
extension PayingVC :WKNavigationDelegate {
    // MARK: - WKNavigationDelegate
       
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        print("Navigating to: \(navigationAction.request.url?.absoluteString ?? "Unknown URL")")
      // Check if the current URL is the "Cancel" URL
        
            // MARK: FeaturedAd Payment
            if let url =  navigationAction.request.url,
               url.absoluteString.contains("PaymentID")  {
                   // Parse the URL to get the paymentId
                   let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                   let paymentId = components?.queryItems?.first(where: { $0.name == "PaymentID" })?.value
    //            delegate?.passPaymentId(with: paymentId ?? "Unknown")
                self.paymentId = paymentId ?? "Unknown"
                   print("Payment ID: \(paymentId ?? "Unknown")")
                   // Cancel the navigation
                   decisionHandler(.allow)
                   return
               }
            
         

            
            if !isSuccess {
                if let url = navigationAction.request.url,
                   url.absoluteString.contains("callback") {
                  
                    fetchInvoiceStatus(from: url)
                    
                  // Cancel the navigation
                  decisionHandler(.cancel)
                  return
                }
            }
          
          // Allow the navigation
          decisionHandler(.allow)
    }
}
