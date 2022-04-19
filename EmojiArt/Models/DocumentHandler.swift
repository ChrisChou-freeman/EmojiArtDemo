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
            scheduleAutoSave()
            if self.background != oldValue.background{
                fetchBackgroundImageDataIfNeccessary()
            }
        }
    }
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    var emojis: [DocumentModel.Emoji] {self.emojiArt.emojis}
    var background: DocumentModel.Background {self.emojiArt.background}
    private var autosaveTimer: Timer?
    
    init(){
        if let url = SaveManager.url, let document = try? DocumentModel(url: url){
            self.emojiArt = document
            fetchBackgroundImageDataIfNeccessary()
        }else{
            self.emojiArt = DocumentModel()
        }
    }
    
    private func scheduleAutoSave(){
        autosaveTimer?.invalidate()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: SaveManager.coalescingInterval, repeats: false){ _ in
            self.autoSave()
        }
    }
    
    private func autoSave(){
        if let url = SaveManager.url{
            save(to: url)
        }
    }
    
    private func save(to url: URL){
        let thisfunction = "\(String(describing: self)).\(#function)"
        do{
            let data = try emojiArt.json()
            print("\(thisfunction) json = \(String(data: data, encoding: .utf8) ?? "nil")")
            try data.write(to: url)
            print("\(thisfunction) success!")
        }catch let encodingError where encodingError is EncodingError{
            print("\(thisfunction) couldn't encode json: \(encodingError.localizedDescription)")
        }catch{
            print("\(thisfunction) error = \(error)")
        }
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
    
    func removeEmojiWithIDs(with emojiIDs: [Int]){
        for emojiID in emojiIDs{
            if let removeIndex = self.emojiArt.emojis.firstIndex(where: {$0.id == emojiID}){
                self.emojiArt.emojis.remove(at: removeIndex)
            }
        }
    }
    
    private struct SaveManager{
        static let fileName = "AutoSaved.emojiart"
        static var url: URL? {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDirectory?.appendingPathComponent(fileName)
        }
        static let coalescingInterval = 5.0
    }
    
    enum BackgroundImageFetchStatus {
        case idle
        case fetching
    }
}
