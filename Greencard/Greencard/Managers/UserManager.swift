//
//  UserManager.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 10.03.2024.
//

import Foundation
import RevenueCat

class UserManager {
    
    static let shared = UserManager()
    
    @UserDefaultWrapper(key: "ud_user", defaultValue: User.nonPremiumUser)
    var user: User
    
    var isPremium: Bool {
        return user.isPremium
    }
    
    func start(completion: (() -> Void)? = nil) {
        Purchases.shared.getCustomerInfo { [weak self] (customerInfo, error) in
            guard
                let self,
                let entitlement = customerInfo?.entitlements.all[ConstantManager.entitlementKey],
                entitlement.isActive,
                let latestExpirationDate = entitlement.expirationDate,
                latestExpirationDate > Date()
            else {
                self?.user = User.nonPremiumUser
                completion?()
                return
            }
            
            let isWeekly = entitlement.productIdentifier == ConstantManager.weeklyIdentifier
            self.user = User(isPremium: true, premiumExpirationDate: latestExpirationDate, isWeekly: isWeekly)
            completion?()
        }
    }
    
    func update(user: User) {
        self.user = user
    }
}

struct User: Codable {
    var isPremium: Bool
    var premiumExpirationDate: Date
    var isWeekly: Bool
}

extension User {
    var expirationDate: Date? {
        if premiumExpirationDate > Date() {
            return premiumExpirationDate
        } else {
            return nil
        }
    }
    
    static var nonPremiumUser: User {
        return User(isPremium: false, premiumExpirationDate: Date(), isWeekly: false)
    }
}

extension Date {
    func toString(format: String = "MMM d, yyyy") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
