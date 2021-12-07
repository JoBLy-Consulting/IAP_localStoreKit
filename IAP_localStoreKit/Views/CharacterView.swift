//
//  CharacterView.swift
//  IAP_localStoreKit
//
//  Created by Johan Guenaoui on 05/12/2021.
//

import SwiftUI

struct CharacterView: View {
    @ObservedObject var _friend: FriendCharacter
    
    var body: some View {
        HStack {
            Image(_friend.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            Spacer()
            
            Text(_friend.name)
                .font(.headline)
            
            Spacer()
            if !_friend.isPurchased {
                Image(systemName: "lock.fill")
                .padding(.trailing, 10)
            }
            
        }
        .padding(8)
    }
}
