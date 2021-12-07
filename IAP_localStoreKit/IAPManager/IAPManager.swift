//
//  IAPManager.swift
//  IAP_localStoreKit
//
//  Created by Johan Guenaoui on 06/12/2021.
//

import Foundation
import StoreKit

class IAPManager: NSObject {
    enum IAPErrors: Error {
        case noProductIDsFound
        case noProductsFound
        case  paymentFailed
    }
    
    static let shared = IAPManager()
    
    var onReceiveProductsHandler: ((Result<[SKProduct], IAPErrors>) -> Void)?
    var onBuyProductsHandler: ((Result<Bool, Error>) -> Void)?
    
    private override init() {
        super.init()
    }
    
    private func getProductsID() -> [String]? {
        guard let path = Bundle.main.url(forResource: "IAP_ProductsID", withExtension: "plist") else {return nil}
        do {
            let data = try Data(contentsOf: path)
            let productsID = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String] ?? []
            
            return productsID
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getProducts(withhandler productReceiveHandler: @escaping(_ result: Result<[SKProduct], IAPErrors>) -> Void) {
        onReceiveProductsHandler = productReceiveHandler
        
        guard let productID = getProductsID() else {
            productReceiveHandler(.failure(.noProductIDsFound))
            return
        }
        
        let request = SKProductsRequest(productIdentifiers: Set(productID))
        
        request.delegate = self
        
        request.start()
    }
    
    func getFormattedCost(for product:SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
    
    func startObserver() {
        SKPaymentQueue.default().add(self)
    }
    
    func stopObserver() {
        SKPaymentQueue.default().remove(self)
    }
    
    func canMakePayments() -> Bool {
        SKPaymentQueue.canMakePayments()
    }
    
    func buy(product: SKProduct, withHandler handler: @escaping ((_ result: Result<Bool, Error>)->Void)) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        
        onBuyProductsHandler = handler
    }
}

extension IAPManager:SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        
        if products.count > 0 {
            onReceiveProductsHandler?(.success(products))
        } else {
            onReceiveProductsHandler?(.failure(.noProductsFound))
        }
    }
}

extension IAPManager:SKPaymentTransactionObserver {
    func  paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {transaction in
            switch transaction.transactionState {
            case .purchased:
                onBuyProductsHandler?(.success(true))
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                onBuyProductsHandler?(.failure(IAPErrors.paymentFailed))
                SKPaymentQueue.default().finishTransaction(transaction)
            default: break
            }
        }
    }
}
