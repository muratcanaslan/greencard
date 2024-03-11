//
//  StoreKitManager.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 11.03.2024.
//

import StoreKit

class StoreKitManager: NSObject, SKProductsRequestDelegate {

    static let shared = StoreKitManager()

    var products: [SKProduct]?

    func start() {
        getProducts()
    }

    func getProducts() {
        let request = SKProductsRequest(
            productIdentifiers: [ConstantManager.weeklyIdentifier, ConstantManager.monthlyIdentifier]
        )
        request.delegate = self
        request.start()
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        debugPrint("Recevied products.")
        products = response.products
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }

    func requestDidFinish(_ request: SKRequest) {
        debugPrint("The request is finished.")
    }

    func purchase(productParam : SKProduct) -> Bool {
        guard let products = products, products.count > 0 else {
            return false
        }
        let payment = SKPayment(product: productParam)
        SKPaymentQueue.default().add(payment)
        return true
    }

    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

}

extension StoreKitManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.error != nil {
                debugPrint("error: \(transaction.error?.localizedDescription ?? "Unknown")")
            }
            switch transaction.transactionState {
            case .purchasing: break;
            case .purchased: break;
            case .restored: break;
            case .failed: break;
            case .deferred: break;
            @unknown default:
                debugPrint("Fatal Error");
            }
        }
    }
}
