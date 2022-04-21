//
//  window.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/4/20.
//

import SwiftUI

struct IdentifiableAlert: Identifiable {
    var id: String
    var alert: () -> Alert
}

extension View {
    @ViewBuilder
    func makeNavigationDismissable(_ dismiss: (()-> Void)? ) -> some View{
        if UIDevice.current.userInterfaceIdiom != .pad, let dismiss = dismiss{
            NavigationView{
                self
                    .navigationBarTitleDisplayMode(.inline)
                    .dismissable(dismiss)
            }
            .navigationViewStyle(.stack)
        }else {
            self
        }
    }
    
    @ViewBuilder
    func dismissable(_ dismiss: (()->Void)?) -> some View{
        if UIDevice.current.userInterfaceIdiom != .pad, let dismiss = dismiss{
            self.toolbar{
                ToolbarItem(placement: .cancellationAction){
                    Button("Close"){ dismiss() }
                }
            }
        }else {
            self
        }
    }
}
