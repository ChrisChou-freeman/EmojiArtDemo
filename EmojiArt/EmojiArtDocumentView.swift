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
                Color.white.overlay(
                    OptionalImage(uiImage: self.document.backgroundImage)
                        .scaleEffect(self.zoomScale)
                        .position(self.convertFromEmojiCoordinates((0, 0), in: geometry))
                )
                .gesture(doubleTapToZoom(in: geometry.size))
                if self.document.backgroundImageFetchStatus == .fetching{
                    ProgressView()
                        .scaleEffect(2.0)
                }else{
                    ForEach(self.document.emojis) { emoji in
                        Text(emoji.text)
                            .font(.system(size: self.fontSize(for: emoji)))
                            .scaleEffect(self.zoomScale)
                            .position(self.position(for: emoji, in: geometry))
                    }
                }
            }
            .onDrop(of: [.plainText, .url, .image], isTargeted: nil){ providers, location in
                self.drop(providers: providers, at: location, in: geometry)
            }
        }
    }
    
    var palette: some View {
        ScrollingEmojisView(emojis: self.testEmojis)
            .font(.system(size: self.defaultEmojiFontSize))
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            self.document.setBackground(.url(url.imageURL))
        }
        if !found{
            found = providers.loadObjects(ofType: UIImage.self){ image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    document.setBackground(.imageData(data))
                }
            }
        }
        if !found{
            found = providers.loadObjects(ofType: String.self){ string in
                if let emoji = string.first, emoji.isEmoji{
                    self.document.addEmoji(
                        String(emoji),
                        at: self.convertToEmojiCoordinates(location, geometry: geometry),
                        size: self.defaultEmojiFontSize / self.zoomScale
                    )
                }
            }
        }
        return found
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
            x: center.x + CGFloat(location.x) * self.zoomScale,
            y: center.y + CGFloat(location.y) * self.zoomScale
        )
    }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: (location.x - center.x) / self.zoomScale,
            y: (location.y - center.y) / self.zoomScale
        )
        return (Int(location.x), Int(location.y))
    }
    
    @State private var zoomScale: CGFloat = 1
    private func zoomToFit(_ image: UIImage?, in size: CGSize){
        if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0 {
            let hzoom = size.width / image.size.width
            let vzoom  = size.height / image.size.height
            zoomScale = min(hzoom, vzoom)
        }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation{
                    self.zoomToFit(self.document.backgroundImage, in: size)
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
