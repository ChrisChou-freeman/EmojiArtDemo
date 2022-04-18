//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/4/1.
//

import Foundation
import SwiftUI


class DocumentHandler: ObservableObject {
    @Published private(set) var emojiArt: DocumentModel {
        didSet {
            if self.background != oldValue.background{
                fetchBackgroundImageDataIfNeccessary()
            }
        }
    }
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    var emojis: [DocumentModel.Emoji] {self.emojiArt.emojis}
    var background: DocumentModel.Background {self.emojiArt.background}
    
    init(){
        self.emojiArt = DocumentModel()
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
                    if self?.emojiArt.background == DocumentModel.Background.url(url){
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
    
    func setBackground(_ background: DocumentModel.Background) {
        self.emojiArt.background = background
        print("background set to \(background)")
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat){
        self.emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }
    
    func moveEmoji(_ emoji: DocumentModel.Emoji, by offset: CGSize){
        if let index = self.emojiArt.emojis.index(matching: emoji){
            self.emojiArt.emojis[index].x += Int(offset.width)
            self.emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func moveEmojiWithIDs(with emojiIDs: [Int], by offset: CGSize){
        for emojiID in emojiIDs{
            if let index = self.emojiArt.emojis.firstIndex(where: {$0.id == emojiID}){
                self.emojiArt.emojis[index].x += Int(offset.width)
                self.emojiArt.emojis[index].y += Int(offset.height)
            }
        }
    }
    
    func scaleEmoji(_ emoji: DocumentModel.Emoji, by scale: CGFloat){
        if let index = self.emojiArt.emojis.index(matching: emoji){
            self.emojiArt.emojis[index].size = Int((CGFloat(self.emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }
    
    func scalEmojiWithIDs(with emojiIDs: [Int], by scale: CGFloat){
        for emojiID in emojiIDs{
            if let index = self.emojiArt.emojis.firstIndex(where: {$0.id == emojiID}){
                self.emojiArt.emojis[index].size = Int((CGFloat(self.emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
            }
        }
    }
    
    enum BackgroundImageFetchStatus {
        case idle
        case fetching
    }
}
