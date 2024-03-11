//
//  SideMenuViewController.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 9.03.2024.
//

import UIKit
import StoreKit
import SafariServices
import MessageUI
import RevenueCat

final class SideMenuViewController: BaseViewController {
    
    var items: [SettingsItem] = SettingsItem.allCases
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func setupAfterInit() {
        super.setupAfterInit()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: SettingsTableViewCell.self)
        tableView.contentInsetAdjustmentBehavior = .never
        
    }
    
    private func openPremium(onPurchased: (() -> Void)?) {
        DispatchQueue.main.async {
            let vc = UINavigationController(rootViewController: PremiumViewController(onPurchased: onPurchased))
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    //MARK: - IBActions
    private func didTapShare() {
                ForceUpdateManager.getAppId { appId in
                    guard let appId = appId else { return }
                    let url = "https://itunes.apple.com/app/\(appId)"
                    DispatchQueue.main.async {
                        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
                        self.present(vc, animated: true)
                    }
                }
    }
    
    private func didTapRateUs() {
        SKStoreReviewController.requestReview()
    }
    
    private func didTapPrivacyPolicy() {
        if let url = URL(string: "https://www.ninetailslab.com/portfolio/greencard-ai/privacy-policy") {
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
    
    private func didTapTermsAndConditions() {
        if let url = URL(string: "https://www.ninetailslab.com/portfolio/greencard-ai/terms") {
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
    
    func didTapHelp() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.editButtonItem.title = "Edit"
            mail.mailComposeDelegate = self
            mail.setSubject("I need help on Greencard AI")
            mail.setMessageBody(getHelpMessageBody(),
                                isHTML: false)
            mail.setToRecipients(["infoappnine@gmail.com"])
            self.present(mail, animated: true)
        }
    }
    
    private func didTapGiveSuggestion() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.editButtonItem.title = "Edit"
            mail.mailComposeDelegate = self
            mail.setSubject("I have suggestion on Greencard AI")
            mail.setToRecipients(["infoappnine@gmail.com"])
            self.present(mail, animated: true)
        }
    }
    
    private func updatePremiumInfo() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func showSubsAlert() {
        fetchInfo { [weak self] title, message in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(ok)
                self?.present(alert, animated: true)
                
            }
        }
        
    }
    
    private func fetchInfo(_ completion: ((String,String) -> Void)?) {
        Purchases.shared.getCustomerInfo { [weak self] customerInfo, error in
            guard
                let entitlement = customerInfo?.entitlements.all[ConstantManager.entitlementKey],
                entitlement.isActive,
                let latestExpirationDate = entitlement.expirationDate,
                latestExpirationDate > Date()
            else {
                self?.navigationController?.popViewController(animated: true)
                return
            }
            
            let title = entitlement.productIdentifier == ConstantManager.weeklyIdentifier ? "Weekly Plan" : "Monthly Plan"
            
            let date = latestExpirationDate.toString() ?? "none"
            let message = "Avaliable to \(date)"
            completion?(title, message)
        }
    }
}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SettingsTableViewCell.self)
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch items[indexPath.row] {
        case .premium:
            if UserManager.shared.isPremium {
                self.showSubsAlert()
            } else {
                self.openPremium {
                    self.updatePremiumInfo()
                }
            }
        case .restorePurchases:
            IAPManager.shared.restore {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        case .rate:
            didTapRateUs()
        case .share:
            didTapShare()
        case .privacy:
            didTapPrivacyPolicy()
        case .terms:
            didTapTermsAndConditions()
        case .help:
            didTapHelp()
        case .feedback:
            didTapGiveSuggestion()
        case .version:
            break
        }
    }
}


//MARK: - MFMailComposeViewController Delegate
extension SideMenuViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension SideMenuViewController {
    func getHelpMessageBody() -> String {
        """
        Device: \(Helper.getDeviceModel() )
        Version: \(Helper.getDeviceVersion() )
        UUID: \(Helper.getDeviceId() )
        Language: \(Locale.current.languageCode ?? "None")
        """
    }
}
