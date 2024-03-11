//
//  PremiumViewController.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 10.03.2024.
//

import UIKit
import SafariServices

final class PremiumViewController: BaseViewController {

    var onPurchased: (() -> Void)?
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var premiumView: PremiumView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var purchaseButton: UIButton!
    
    override func applyLocalizations() {
        super.applyLocalizations()
        
        navigationItem.title = "Premium"
        
        purchaseButton.setTitle("Purchase", for: .normal)
        termsButton.setTitle("Terms and conditions", for: .normal)
        privacyButton.setTitle("Privacy policy", for: .normal)
    }
    
    override func applyStyling() {
        super.applyStyling()
        
        purchaseButton.backgroundColor = .yellowColor
        purchaseButton.setTitleColor(.textColor, for: .normal)
        purchaseButton.titleLabel?.font = .button
        
        termsButton.titleLabel?.font = .info
        privacyButton.titleLabel?.font = .info
        
        termsButton.setTitleColor(.textColor.withAlphaComponent(0.5), for: .normal)
        privacyButton.setTitleColor(.textColor.withAlphaComponent(0.5), for: .normal)
        
        scrollView.contentInset = .init(top: 0, left: 0, bottom: 180, right: 0)
    }
    
    override func setupAfterInit() {
        super.setupAfterInit()
        
        setCloseItem()
        setRestoreItem()
        
        IAPManager.shared.fetchUserInfo { [weak self] in
            self?.premiumView.updatePackages(packages: IAPManager.shared.availablePackages)
        }
    }
    
    
    private func setCloseItem() {
        let close = UIBarButtonItem(image: UIImage(resource: .iconClose), style: .done, target: self, action: #selector(didTapClose))
        navigationItem.leftBarButtonItem = close
    }
    
    private func setRestoreItem() {
        let item = UIBarButtonItem(title: "Restore", style: .done, target: self, action: #selector(didTapRestore))
        item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.bodyM, NSAttributedString.Key.foregroundColor: UIColor.blueColor], for: .normal)
        navigationItem.rightBarButtonItem = item
    }
    
    init(onPurchased: (() -> Void)? = nil) {
        self.onPurchased = onPurchased
        super.init(nibName: "PremiumViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapClose() {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapPurchase(_ sender: UIButton) {
        let isMonthly = self.premiumView.monthlySelected
        
        if isMonthly {
            guard let monthly = IAPManager.shared.availablePackages.first(where: { $0.storeProduct.productIdentifier == ConstantManager.monthlyIdentifier}) else {
                return
            }
            IAPManager.shared.purchase(package: monthly) {
                self.dismiss(animated: true, completion: {
                    self.onPurchased?()
                })
            }
        } else {
            guard let weekly = IAPManager.shared.availablePackages.first(where: { $0.storeProduct.productIdentifier == ConstantManager.weeklyIdentifier }) else {
                return
            }
            
            IAPManager.shared.purchase(package: weekly) {
                self.dismiss(animated: true, completion: {
                    self.onPurchased?()
                })
            }
        }
    }
    @IBAction func didTapTerms(_ sender: UIButton) {
        if let url = URL(string: "https://www.ninetailslab.com/portfolio/greencard-ai/terms") {
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func didTapPrivacy(_ sender: UIButton) {
        if let url = URL(string: "https://www.ninetailslab.com/portfolio/greencard-ai/privacy-policy") {
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
    @objc private func didTapRestore() {
        IAPManager.shared.restore {
            self.dismiss(animated: true)
        }
    }
}
