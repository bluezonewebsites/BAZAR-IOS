//
//  PackagesVC.swift
//  Bazar
//
//  Created by iOSayed on 03/09/2023.
//

import UIKit
import MOLH

class PackagesVC: UIViewController {
    
    static func instantiate() -> PackagesVC {
        
        let controller = UIStoryboard(name: "Packages", bundle: nil).instantiateViewController(withIdentifier: "PackagesVC") as! PackagesVC
        
        return controller
    }
    
    //MARK: IBOulets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var silverButton: UIButton!
    @IBOutlet weak var goldButton: UIButton!
    @IBOutlet weak var diamondButton: UIButton!
    @IBOutlet weak var bestSellerFlag: UIView!
    
    
    @IBOutlet weak var threeMonthViewContainer: UIView!
    @IBOutlet weak var sixMonthViewContainer: UIView!
    @IBOutlet weak var twelveMonthViewContainer: UIView!
    @IBOutlet weak var threeMonthRoundedView: UIView!
    @IBOutlet weak var sixMonthRoundedView: UIView!
    @IBOutlet weak var twelveMonthRoundedView: UIView!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var sixLabel: UILabel!
    @IBOutlet weak var twelveLabel: UILabel!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: PROPERTIES
    
    private var silverList:PackageObject?
    private var goldList:PackageObject?
    private var diamondList:PackageObject?
    private var isGold = false
    private var isDiamond = false
    private var invoiceURL = ""
    private var planId = 1
    private var monthCount = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchAllPlans()
        startFlashAnimation()
        
        //        // Set the rowHeight to automaticDimension
        //            tableView.rowHeight = UITableView.automaticDimension
        //            tableView.estimatedRowHeight = 60 // Provide an estimated row height
        
        //        tableViewHeightConstraint.constant = 200
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }
    
    private func configureView(){
        //        bestSellerFlag.shake()
        setupButton(for: silverButton, isTapped: true)
        setupButton(for: goldButton, isTapped: false)
        setupButton(for: diamondButton, isTapped: false)
        handlePackegesPlanSelected(for: threeMonthViewContainer, label: threeLabel, rondedView: threeMonthRoundedView)
        tableView.register(UINib(nibName: "PackagesFeatureCell", bundle: nil), forCellReuseIdentifier: "PackagesFeatureCell")
    }
    
    
    private func setupButton(for button: UIButton, isTapped:Bool){
        if isTapped {
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(named: "#0093F5")
        }else {
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
        }
        
    }
    
    
    private func handlePackegesPlanSelected(for view:UIView,label:UILabel , rondedView:UIView){
        view.layer.borderWidth = 0.8
        view.layer.borderColor = UIColor(named: "#0093F5")?.cgColor
        label.textColor = UIColor(named: "#0093F5")
        rondedView.backgroundColor = UIColor(named: "#0093F5")
        
    }
    
    private func handlePackegesPlanNotSelected(for view:UIView,label:UILabel,rondedView:UIView){
        view.layer.borderWidth = 0.8
        view.layer.borderColor = UIColor.black.cgColor
        label.textColor = .black
        rondedView.backgroundColor = .black
    }
    
    func toggleFlashView() {
        UIView.transition(with: bestSellerFlag, duration: 1, options: .transitionCrossDissolve, animations: {
            self.bestSellerFlag.isHidden = !self.bestSellerFlag.isHidden
        }, completion: nil)
    }
    
    func startFlashAnimation() {
        // Use a Timer to repeatedly toggle the flashView's visibility.
        let timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { [weak self] timer in
            self?.toggleFlashView()
        }
        
        // Add the timer to the main run loop to start the animation immediately.
        RunLoop.main.add(timer, forMode: .common)
    }
    
    
    func fetchAllPlans(){
        PackagesController.shared.fetchAllPlans(completion: { plan, check, message in
            if check  == 0 {
                self.silverList = plan[0]
                self.goldList = plan[1]
                self.diamondList = plan[2]
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                self.tableViewHeightConstraint.constant = self.tableView.contentSize.height
                if MOLHLanguage.currentAppleLanguage() == "en" {
                    self.goldButton.setTitle(plan[1].nameEn ?? "", for: .normal)
                    self.silverButton.setTitle(plan[0].nameEn ?? "", for: .normal)
                    self.diamondButton.setTitle(plan[2].nameEn ?? "", for: .normal)
                }else{
                    self.goldButton.setTitle(plan[1].nameAr ?? "", for: .normal)
                    self.silverButton.setTitle(plan[0].nameAr ?? "", for: .normal)
                    self.diamondButton.setTitle(plan[2].nameAr ?? "", for: .normal)
                }
            }else{
                StaticFunctions.createErrorAlert(msg: message)
            }
        }, countryId: 0)
    }
    
    
    private func goToSuccessPlanfullSubscribe(){
        let vc = SuccessPlanSucbscribeVC.instantiate()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: false)
    }
    
  
    @IBAction func didTapBackButton(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSilverButton(_ sender: UIButton) {
        planId = silverList?.id ?? 0
        isGold = false
        isDiamond = false
        setupButton(for: silverButton, isTapped: true)
        setupButton(for: goldButton, isTapped: false)
        setupButton(for: diamondButton, isTapped: false)
        self.tableView.reloadData()
    }
    
    @IBAction func didTapGoldButton(_ sender: UIButton) {
        planId = goldList?.id ?? 0
        isGold = true
        isDiamond = false
        setupButton(for: silverButton, isTapped: false)
        setupButton(for: goldButton, isTapped: true)
        setupButton(for: diamondButton, isTapped: false)
        self.tableView.reloadData()
    }
    
    @IBAction func didTapDiamondButton(_ sender: UIButton) {
        planId = diamondList?.id ?? 0
        isGold = false
        isDiamond = true
        setupButton(for: silverButton, isTapped: false)
        setupButton(for: goldButton, isTapped: false)
        setupButton(for: diamondButton, isTapped: true)
        self.tableView.reloadData()
    }
    
    @IBAction func didTapThreeMonthButton(_ sender: UIButton) {
        monthCount = 3
        handlePackegesPlanSelected(for: threeMonthViewContainer, label: threeLabel, rondedView: threeMonthRoundedView)
        handlePackegesPlanNotSelected(for: sixMonthViewContainer, label: sixLabel, rondedView: sixMonthRoundedView)
        handlePackegesPlanNotSelected(for: twelveMonthViewContainer, label: twelveLabel, rondedView: twelveMonthRoundedView)
    }
    
    @IBAction func didTapSixMonthButton(_ sender: UIButton) {
        monthCount = 6
        handlePackegesPlanSelected(for: sixMonthViewContainer, label: sixLabel, rondedView: sixMonthRoundedView)
        handlePackegesPlanNotSelected(for: threeMonthViewContainer, label: threeLabel, rondedView: threeMonthRoundedView)
        handlePackegesPlanNotSelected(for: twelveMonthViewContainer, label: twelveLabel, rondedView: twelveMonthRoundedView)
    }
    
    @IBAction func didTapTwelveutton(_ sender: UIButton) {
        monthCount = 12
        handlePackegesPlanSelected(for: twelveMonthViewContainer, label: twelveLabel, rondedView: twelveMonthRoundedView)
        handlePackegesPlanNotSelected(for: threeMonthViewContainer, label: threeLabel, rondedView: threeMonthRoundedView)
        handlePackegesPlanNotSelected(for: sixMonthViewContainer, label: sixLabel, rondedView: sixMonthRoundedView)
    }
    
    
    @IBAction func didTapBuyNowButton(_ sender: UIButton) {
        
        PayingController.shared.payingPlan(completion: { payment, check, message in
            if check == 0{
                let vc = UIStoryboard(name: ADVS_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "PayingVC") as! PayingVC
                vc.planDelegate  = self
                vc.isFeaturedAd = false
                vc.urlString = payment?.data.invoiceURL ?? ""
                self.invoiceURL = "\(payment?.data.invoiceID ?? 0)"
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                StaticFunctions.createErrorAlert(msg: message)
            }
        }, countryId: AppDelegate.currentUser.countryId ?? 5, planId:planId,month: monthCount)
    }
    
    
    
}

extension PackagesVC : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isGold {
            return goldList?.features?.count ?? 0
        }else if isDiamond {
            return diamondList?.features?.count ?? 0
        }else{
            return silverList?.features?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PackagesFeatureCell", for: indexPath) as? PackagesFeatureCell else {return UITableViewCell()}
        
        if isGold {
            if let features = goldList?.features, indexPath.row < features.count {
                cell.setData(from: features[indexPath.row], index: indexPath.row)
            }
            //            cell.setData(from: silverFeature[indexPath.row], index: indexPath.row)
        }else if isDiamond {
            if let features = diamondList?.features, indexPath.row < features.count {
                cell.setData(from: features[indexPath.row], index: indexPath.row)
            }
            //            cell.setData(from: silverFeature[indexPath.row], index: indexPath.row)
        }else{
            if let features = silverList?.features, indexPath.row < features.count {
                cell.setData(from: features[indexPath.row], index: indexPath.row)
            }
            //            cell.setData(from: silverFeature[indexPath.row], index: indexPath.row)
        }
        return cell
    }
}
extension PackagesVC:PayingPlanDelegate{
    func passPaymentId(with paymentId: String) {
        PayingController.shared.callBackPlanSubscribe(completion: { payment, check, message in
            if check == 0{
                print(message)
            }else{
                print(message)
                StaticFunctions.createErrorAlert(msg: message)
            }
        }, invoiceId: invoiceURL, paymentId: paymentId)
    }
    func didPayingSuccess() {
        goToSuccessPlanfullSubscribe()
    }
}
