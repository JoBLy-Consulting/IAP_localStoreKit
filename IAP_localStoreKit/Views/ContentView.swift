//
//  ContentView.swift
//  IAP_localStoreKit
//
//  Created by Johan Guenaoui on 05/12/2021.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @ObservedObject var _friendsManager = FriendsManager()
    @State private var product: SKProduct?
    @State var alertVisible: Bool = false
    @State var transactionFailed:Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(_friendsManager.friends) { (friend) in
                    Button(action: {
                        if friend.isPurchased {
                            print("Vous avez déjà acquis ce personnage")
                        }else {
                            if let friendSelected = _friendsManager.getProduct(with: friend.productID) {
                                self.product = friendSelected
                                self.alertVisible.toggle()
                            }
                        }
                        }, label: {
                            CharacterView(_friend: friend)
                    })
                }
            }
            .navigationBarTitle("Buy a friend !")
            .alert(isPresented: $alertVisible, content:{
                Alert(title: Text(product!.localizedTitle), message: Text(product!.localizedDescription), primaryButton: .default(Text("Acheter \(IAPManager.shared.getFormattedCost(for: self.product!)!)"), action: {
                    self._friendsManager.buyCharacter(product: self.product) { success in
                        transactionFailed = !success
                    }
                }), secondaryButton:.cancel())
            })
            .alert(isPresented: $transactionFailed) {
                Alert(title: Text("Votre achat n'a pas pu aboutir"))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
