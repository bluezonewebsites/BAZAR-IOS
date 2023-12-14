//
//  PaymentMethodCollectionViewCell.swift
//  NewBazar
//
//  Created by iOSayed on 04/12/2023.
//



import UIKit
import MFSDK

class PaymentMethodTableViewCell: UITableViewCell {
    //MARK: Variables
    
    //MARK: Outlets
    @IBOutlet weak var paymentMethodImageView: UIImageView!
    @IBOutlet weak var paymentMethodNameLabel: UILabel!
    
    //MARK Methods
    func configure(paymentMethod: MFPaymentMethod, selected: Bool) {
        paymentMethodImageView.image = nil
        paymentMethodImageView.layer.cornerRadius = 5
        if selected {
            if #available(iOS 13.0, *) {
                paymentMethodImageView.layer.borderColor = UIColor.label.cgColor
            } else {
                paymentMethodImageView.layer.borderColor = UIColor.black.cgColor
            }
            paymentMethodImageView.layer.borderWidth = 3
        } else {
            paymentMethodImageView.layer.borderWidth = 0
        }
        if let imageURL = URL(string: paymentMethod.imageUrl ?? "")  {
            paymentMethodImageView.sd_setImage(with:imageURL)
        }
        paymentMethodNameLabel.text = paymentMethod.paymentMethodEn ?? ""
    }
}

