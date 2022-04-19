//
//  Button.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/4/19.
//

import SwiftUI

struct AnimatedActionButton: View{
    var title: String?
    var sysemImage: String?
    let action: () -> Void
    
    var body: some View{
        Button{
            withAnimation{
                action()
            }
        } label: {
            if title != nil && sysemImage != nil{
                Label(title!, systemImage: sysemImage!)
            }else if title != nil{
                Text(title!)
            }else if sysemImage != nil {
                Image(systemName: sysemImage!)
            }
        }
    }
}
