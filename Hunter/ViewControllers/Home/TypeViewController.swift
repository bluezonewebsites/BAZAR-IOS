//
//  TypeViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 29/04/2023.
//

import UIKit

class TypeViewController: BottomPopupViewController {
    var typeBtclosure : (( Int?,String) -> Void)? = nil

    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var donationButton: UIButton!
    @IBOutlet weak var buyingButton: UIButton!
    @IBOutlet weak var rentButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    
    var selectedType = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    
    override func getPopupHeight() -> CGFloat {
        return 600
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return 25
    }
    
    override func getPopupPresentDuration() -> Double {
        0.3
    }
    
    override func getPopupDismissDuration() -> Double {
        0.3
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        true
    }
    
    override func getDimmingViewAlpha() -> CGFloat {
        0.7
    }
    
    private func setupView(){
        
        switch selectedType {
        case 0 :
            setupSelectedButton(for: sellButton)
        case 1 :
            setupSelectedButton(for: rentButton)
        case 2 :
            setupSelectedButton(for: buyingButton)
        case 3 :
            setupSelectedButton(for: donationButton)
        default:
            setupSelectedButton(for: allButton)
        }
        
        
    }
    
    private func setupSelectedButton(for button:UIButton){
        button.backgroundColor  = UIColor(named: "#0093F5")
    }
    
    private func setupUnSelectedButton(for button:UIButton){
        button.backgroundColor  = .white
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func allAction(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.typeBtclosure!(nil, "All".localize)

        })

    }
    @IBAction func rentAction(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.typeBtclosure!(1,"Rent".localize)

        })
        
    }
    
    @IBAction func didTapBuying(_ sender: UIButton) {
        self.dismiss(animated: false, completion: {
            self.typeBtclosure!(2, "Buying".localize)

        })
    }
    
    @IBAction func didTapDonation(_ sender: UIButton) {
        self.dismiss(animated: false, completion: {
            self.typeBtclosure!(3, "Donation".localize)

        })
    }
    
    
    @IBAction func sellAction(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.typeBtclosure!(0, "Sell".localize)

        })
    }

}
