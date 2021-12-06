//
//  FriendManager.swift
//  IAP_localStoreKit
//
//  Created by Johan Guenaoui on 05/12/2021.
//

import Foundation

class FriendsManager: ObservableObject {
    @Published var friends = [FriendCharacter]()
    
    
    init() {
        loadFriends()
    }
    
    
    private func loadFriends() {
        guard let url = Bundle.main.url(forResource: "Friends", withExtension: "json"), let data = try? Data(contentsOf: url) else {
            return
        }
        
        let decoder = JSONDecoder()
        guard let loadedFriends = try? decoder.decode([FriendCharacter].self, from: data) else { return }
        friends = loadedFriends
    }
}
