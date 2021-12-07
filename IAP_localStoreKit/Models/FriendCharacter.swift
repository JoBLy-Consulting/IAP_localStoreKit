//
//  FriendCharacter.swift
//  IAP_localStoreKit
//
//  Created by Johan Guenaoui on 05/12/2021.
//

import Foundation

class FriendCharacter: Codable, Identifiable,ObservableObject {
    var id: Int?
    var image = ""
    var name = ""
    var productID: String?
    @Published var isPurchased = false
    
    
    init() { }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        image = try container.decode(String.self, forKey: .image)
        name = try container.decode(String.self, forKey: .name)
        productID = try container.decode(String.self, forKey: .productID)
        getPurchasedState()
    }
    
    private func getPurchasedState() {
        guard let idSelected = id else {return}
        isPurchased = UserDefaults.standard.bool(forKey: "\(idSelected)")
    }
    
    func markAsPurchased() {
        guard let idSelected = id else {return}
        UserDefaults.standard.set(true, forKey: "\(idSelected)")
        isPurchased = true
    }
    
    enum CodingKeys: CodingKey {
        case id, image, name, productID
    }
    
}
