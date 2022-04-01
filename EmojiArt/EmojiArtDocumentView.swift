//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/3/31.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    let testEmojis = "🐵🐒🦍🦧🐶🐕🦮🐕‍🦺🐩🐺🦊🦝🐱🐈🐈‍⬛🦁🐯🐆🐴🐎"
    let defaultEmojiFontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0){
            self.documentBody
            self.palette
        }
    }
    
    var documentBody: some View {
        GeometryReader{ geometry in
            ZStack{
                Color.yellow
                ForEach(self.document.emojis) { emoji in
                    Text(emoji.text)
                        .font(.system(size: self.fontSize(for: emoji)))
                        .position(self.position(for: emoji, in: geometry))
                }
            }
            .onDrop(of: [.plainText], isTargeted: nil){ providers, location in
                drop(providers: providers, at: location, in: geometry)
            }
        }
    }
    
    var palette: some View {
        ScrollingEmojisView(emojis: self.testEmojis)
            .font(.system(size: self.defaultEmojiFontSize))
    }
    
    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint{
        self.convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }
    
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint{
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x),
            y: center.y + CGFloat(location.y)
        )
    }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: location.x - center.x,
            y: location.y - center.y
        )
        return (Int(location.x), Int(location.y))
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        return providers.loadObjects(ofType: String.self){ string in
            if let emoji = string.first, emoji.isEmoji{
                self.document.addEmoji(
                    String(emoji),
                    at: self.convertToEmojiCoordinates(location, geometry: geometry),
                    size: self.defaultEmojiFontSize
                )
            }
        }
    }
    
}

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
