//
//  ScrollingEmojisView.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/4/16.
//

import SwiftUI

struct ScrollingEmojisView: View{
    let emojis: String
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(self.emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag{ NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}

struct ScrollingEmojisView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollingEmojisView(emojis: "🐵🐒🦍🦧🐶🐕🦮🐕‍🦺🐩🐺🦊🦝🐱🐈🐈‍⬛🦁🐯🐆🐴🐎")
    }
}
