//
//  ContentView.swift
//  IAP_localStoreKit
//
//  Created by Johan Guenaoui on 05/12/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var _friendsManager = FriendsManager()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(_friendsManager.friends) { (friend) in
                    Button(action: {
                        
                            print("You want to buy ?")
                        }, label: {
                            CharacterView(_friend: friend)
                    })
                }
            }
            .navigationBarTitle("Buy a friend !")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
