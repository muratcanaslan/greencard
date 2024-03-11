//
//  SettingsTableViewCell.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 9.03.2024.
//

import UIKit

final class SettingsTableViewCell: BaseTableViewCell {

    @IBOutlet weak var settingsIcon: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!
    
    override func applyStyling() {
        super.applyStyling()
        
        settingsLabel.font = .bodyM
        settingsLabel.textColor = .textColor
    }
    
    func configure(with item: SettingsItem) {
        settingsIcon.image = item.icon
        settingsLabel.text = item.title
    }
}

enum SettingsItem: CaseIterable {
    case premium
    case restorePurchases
    case rate
    case share
    case privacy
    case terms
    case help
    case feedback
    case version
    
    var title: String {
        switch self {
        case .premium:
            return UserManager.shared.isPremium ? "Subscription" : "Premium"
        case .restorePurchases:
            return "Restore purchase"
        case .rate:
            return "Rate us"
        case .share:
            return "Share"
        case .privacy:
            return "Privacy policy"
        case .terms:
            return "Terms and conditions"
        case .help:
            return "Need help?"
        case .feedback:
            return "Feedback"
        case .version:
            return "Version (\(Helper.getBuildNumebr()))"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .premium:
            return UserManager.shared.isPremium ? UIImage(resource: .iconSubs) : UIImage(resource: .iconGreencard)
        case .restorePurchases:
            return UIImage(resource: .iconRestore)
        case .rate:
            return UIImage(resource: .iconRate)
        case .share:
            return UIImage(resource: .iconShare)
        case .privacy:
            return UIImage(resource: .iconPrivacy)
        case .terms:
            return UIImage(resource: .iconTerms)
        case .help:
            return UIImage(resource: .iconHelp)
        case .feedback:
            return UIImage(resource: .iconFeedback)
        case .version:
            return UIImage(resource: .iconVersion)
        }
    }
}
