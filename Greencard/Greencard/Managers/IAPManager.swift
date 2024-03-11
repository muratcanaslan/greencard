//
//  IAPManager.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 11.03.2024.
//

import Foundation
import RevenueCat

typealias Packages = (left: Package, right: Package)

struct LocalizedPackage {
    let price: String
}

final class IAPManager {

    static let shared = IAPManager()

    private(set) var offering: Offering?
    var availablePackages: [Package] = []

    private(set) var isFetching: Bool = false

    private init() { }

    func start() {
        fetchUserInfo()
    }

    func fetchUserInfo(completion: (() -> Void)? = nil) {
        Purchases.shared.getOfferings { offerings, error in
            if let offering = offerings?.current, error == nil {
                self.offering = offering
                self.availablePackages = offering.availablePackages
            } else {
                // TODO: - Error case
            }
            completion?()
        }
    }

    func restore(completion: (() -> Void)? = nil) {
        HUDManager.showAnimation()

        Purchases.shared.restorePurchases { customerInfo, error in
            
            HUDManager.hideAnimation()

            guard
                let entitlement = customerInfo?.entitlements.all[ConstantManager.entitlementKey],
                entitlement.isActive,
                let latestExpirationDate = entitlement.expirationDate,
                latestExpirationDate > Date()
            else {
                UserManager.shared.update(user: .nonPremiumUser)
                completion?()
                return
            }
            
            let isWeekly = entitlement.productIdentifier == ConstantManager.weeklyIdentifier
            let user = User(isPremium: true, premiumExpirationDate: latestExpirationDate, isWeekly: isWeekly)
            UserManager.shared.update(user: user)
            completion?()
        }
    }

    func purchase(package: Package, completion: (() -> Void)? = nil) {
        
        HUDManager.showAnimation()

        Purchases.shared.purchase(package: package) { transaction, customerInfo, error, userCancelled in
            
            HUDManager.hideAnimation()

            guard
                let entitlement = customerInfo?.entitlements.all[ConstantManager.entitlementKey],
                entitlement.isActive,
                let latestExpirationDate = entitlement.expirationDate,
                latestExpirationDate > Date()
            else {
                UserManager.shared.update(user: .nonPremiumUser)
                completion?()
                return
            }
            
            let isWeekly = entitlement.productIdentifier == ConstantManager.weeklyIdentifier
            let user = User(isPremium: true, premiumExpirationDate: latestExpirationDate, isWeekly: isWeekly)
            UserManager.shared.update(user: user)
            completion?()
        }
    }

}
