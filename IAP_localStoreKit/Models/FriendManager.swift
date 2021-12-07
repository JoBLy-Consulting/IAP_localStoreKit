//
//  FriendManager.swift
//  IAP_localStoreKit
//
//  Created by Johan Guenaoui on 05/12/2021.
//

import Foundation
import StoreKit

class FriendsManager: ObservableObject {
    @Published var friends = [FriendCharacter]()
    @Published var products = [SKProduct]()
    
    
    init() {
        loadFriends()
        loadProducts()
    }
    
    
    private func loadFriends() {
        guard let url = Bundle.main.url(forResource: "Friends", withExtension: "json"), let data = try? Data(contentsOf: url) else {
            return
        }
        
        let decoder = JSONDecoder()
        guard let loadedFriends = try? decoder.decode([FriendCharacter].self, from: data) else { return }
        friends = loadedFriends
    }
    
    private func loadProducts() {
        IAPManager.shared.getProducts { productsResult in
            DispatchQueue.main.async {
                switch productsResult {
                case .success(let fetchProduct):
                    self.products = fetchProduct
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getProduct(with identifier: String?) -> SKProduct? {
        guard let id = identifier else {return nil}
        return products.filter({ $0.productIdentifier == id}).first
    }
    
    func buyCharacter(product: SKProduct?, completion: @escaping(_ success:Bool) -> Void) {
        guard let product = product else {return}
        IAPManager.shared.buy(product: product) { result in
            switch result {
            case .success(let successResponse):
                if successResponse {
                    self.friends.filter({$0.productID == product.productIdentifier}).first?.markAsPurchased()
                    completion(true)
                }
            case .failure(_): completion(false)
            }
        }
    }
}
