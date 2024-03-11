//
//  PremiumView.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 10.03.2024.
//

import UIKit
import RevenueCat

final class PremiumView: BaseView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weeklyView: UIView!
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var monthlyIcon: UIImageView!
    @IBOutlet weak var monthlyLabel: UILabel!
    @IBOutlet weak var monthlyPriceLabel: UILabel!
    @IBOutlet weak var weeklyIcon: UIImageView!
    @IBOutlet weak var weeklyLabel: UILabel!
    @IBOutlet weak var weeklyPriceLabel: UILabel!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var subtitle1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var subtitle2: UILabel!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var subtitle3: UILabel!
    @IBOutlet weak var title4: UILabel!
    @IBOutlet weak var subtitle4: UILabel!

    var monthlySelected: Bool = true
    
    override func applyLocalizations() {
        super.applyLocalizations()
        
        titleLabel.text = "Ready to unlock?"
        weeklyLabel.text = "Weekly"
        monthlyLabel.text = "Monthly"
        title1.text = "Unlimited background removal"
        subtitle1.text = "Remove backgrounds seamlessly without restrictions."
        title2.text = "Effortless resizing"
        subtitle2.text = "Effortlessly resize photos to meet green card requirements."
        title3.text = "Color adjustment mastery"
        subtitle3.text = "Attain professional color balance for green card application photos."
        title4.text = "Cancel anytime"
        subtitle4.text = "Feel free to cancel anytime. We appreciate your support!"
        weeklyPriceLabel.text = "$1.22"
        monthlyPriceLabel.text = "$1.22"
    }
    
    override func applyStyling() {
        super.applyStyling()
        
        titleLabel.textColor = .textColor
        titleLabel.font = .subHeading
        
        weeklyLabel.font = .bodyM
        monthlyLabel.font = .bodyM
        
        weeklyPriceLabel.font = .semibold16
        monthlyPriceLabel.font = .semibold16
        
        title1.font = .bodyM
        title2.font = .bodyM
        title3.font = .bodyM
        title4.font = .bodyM
        
        title1.textColor = .textColor
        title2.textColor = .textColor
        title3.textColor = .textColor
        title4.textColor = .textColor
        
        subtitle1.font = .info
        subtitle2.font = .info
        subtitle3.font = .info
        subtitle4.font = .info
        
        subtitle1.textColor = .textColor
        subtitle2.textColor = .textColor
        subtitle3.textColor = .textColor
        subtitle4.textColor = .textColor
        
        monthlyView.cornerRadius = 8
        weeklyView.cornerRadius = 8
    }
    
    override func setupAfterInit() {
        super.setupAfterInit()
        
        updatePriceButtons()
        setupGesture()
    }
    
    private func setupGesture() {
        let monthly = UITapGestureRecognizer(target: self, action: #selector(didTapMonthly))
        let weekly = UITapGestureRecognizer(target: self, action: #selector(didTapWeekly))
        monthlyView.addGestureRecognizer(monthly)
        weeklyView.addGestureRecognizer(weekly)
    }
    
    @objc private func didTapMonthly() {
        if monthlySelected { return }
        monthlySelected = true
        updatePriceButtons()
    }
    
    @objc private func didTapWeekly() {
        if !monthlySelected { return }
        monthlySelected = false
        updatePriceButtons()
    }
    
    func updatePackages(packages: [Package]) {
        guard let monthly = IAPManager.shared.availablePackages.first(where: { $0.storeProduct.productIdentifier == ConstantManager.monthlyIdentifier}), let weekly = IAPManager.shared.availablePackages.first(where: { $0.storeProduct.productIdentifier == ConstantManager.weeklyIdentifier }) else {
            return
        }
        
        monthlyPriceLabel.text = monthly.localizedPriceString
        weeklyPriceLabel.text = weekly.localizedPriceString
    }
    
    private func updatePriceButtons() {
        let selectedIcon = UIImage(resource: .iconSelected)
        let unselectedIcon = UIImage(resource: .iconUnselected)
        
        monthlyIcon.image = monthlySelected ? selectedIcon : unselectedIcon
        weeklyIcon.image = monthlySelected ? unselectedIcon : selectedIcon
        
        monthlyView.backgroundColor = monthlySelected ? .optionColor : .softGrayColor
        weeklyView.backgroundColor = monthlySelected ? .softGrayColor : .optionColor
        
        monthlyLabel.textColor = monthlySelected ? .white : .textColor
        weeklyLabel.textColor = monthlySelected ? .textColor : .white
        
        monthlyPriceLabel.textColor = monthlySelected ? .white : .textColor
        weeklyPriceLabel.textColor = monthlySelected ? .textColor : .white
    }
}
