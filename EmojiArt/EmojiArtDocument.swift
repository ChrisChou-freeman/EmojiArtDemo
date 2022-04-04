//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/4/1.
//

import Foundation

import SwiftUI

class EmojiArtDocument: ObservableObject {
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            if self.background != oldValue.background{
                fetchBackgroundImageDataIfNeccessary()
            }
        }
    }
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    var emojis: [EmojiArtModel.Emoji] {self.emojiArt.emojis}
    var background: EmojiArtModel.Background {self.emojiArt.background}
    
    init(){
        self.emojiArt = EmojiArtModel()
    }
    
    private func fetchBackgroundImageDataIfNeccessary(){
        self.backgroundImage = nil
        switch self.emojiArt.background {
        case .url(let url):
            self.backgroundImageFetchStatus = .fetching
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = try? Data(contentsOf: url)
                DispatchQueue.main.async { [weak self] in
                    // handle muitiple image drag to background
                    if self?.emojiArt.background == EmojiArtModel.Background.url(url){
                        self?.backgroundImageFetchStatus = .idle
                        if imageData != nil {
                            self?.backgroundImage = UIImage(data: imageData!)
                        }
                    }
                }
            }
        case .imageData(let data):
            self.backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
        
    }
    
    func setBackground(_ background: EmojiArtModel.Background) {
        self.emojiArt.background = background
        print("background set to \(background)")
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
    
    enum BackgroundImageFetchStatus {
        case idle
        case fetching
    }
}
