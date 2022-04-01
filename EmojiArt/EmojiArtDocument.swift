//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/4/1.
//

import Foundation

import SwiftUI

class EmojiArtDocument: ObservableObject {
    @Published private(set) var emojiArt: EmojiArtModel
    
    init(){
        self.emojiArt = EmojiArtModel()
        self.emojiArt.addEmoji("😀", at: (-200, -100), size: 80)
        self.emojiArt.addEmoji("🙃", at: (50, 100), size: 40)
    }
    
    var emojis: [EmojiArtModel.Emoji] {self.emojiArt.emojis}
    var background: EmojiArtModel.Background {self.emojiArt.background}
    
    func setBackground(_ background: EmojiArtModel.Background) {
        self.emojiArt.background = background
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat){
        self.emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize){
        if let index = self.emojiArt.emojis.index(matching: emoji){
            self.emojiArt.emojis[index].x += Int(offset.width)
            self.emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat){
        if let index = self.emojiArt.emojis.index(matching: emoji){
            self.emojiArt.emojis[index].size = Int((CGFloat(self.emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }
}
