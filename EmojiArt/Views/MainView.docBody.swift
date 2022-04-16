//
//  MainView.docBody.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/4/16.
//

import SwiftUI


extension MainView{
    
    private var panOffset: CGSize {
        (self.steadyStatePanOffset + self.gesturePanOffset) * self.zoomScale
    }
    var zoomScale: CGFloat {
        self.steadyStateZoomScale * self.gestureZoomScale
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
                        let element = Text(emoji.text)
                        Group{
                            if emoji.text == self.selectedElement {
                                element.border(.black)
                            }else{
                                element
                            }
                        }
                        .font(.system(size: self.fontSize(for: emoji)))
                        .scaleEffect(self.zoomScale)
                        .position(self.position(for: emoji, in: geometry))
                        .onTapGesture {
                            self.selectedElement = emoji.text
                        }
                    }
                    
                }
            }
            .clipped()
            .onDrop(of: [.plainText, .url, .image], isTargeted: nil){ providers, location in
                self.drop(providers: providers, at: location, in: geometry)
            }
            .gesture(self.panGesture().simultaneously(with: self.zoomGesture()))
        }
    }
    
    func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
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
    
    func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation{
                    self.zoomToFit(self.document.backgroundImage, in: size)
                }
            }
    }
    
    func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating(self.$gestureZoomScale){ latestGestureScale, gestureZoomScale, transaction in
                gestureZoomScale = latestGestureScale
            }
            .onEnded{ gestureScaleAtEnd in
                self.steadyStateZoomScale *= gestureScaleAtEnd
            }
    }
    
    func panGesture() -> some Gesture {
        DragGesture()
            .updating(self.$gesturePanOffset) { latestDragGestureValue ,gesturePanOffset, _ in
                gesturePanOffset  = latestDragGestureValue.translation / self.zoomScale
            }
            .onEnded { finalDragGestureValue in
                self.steadyStatePanOffset  = self.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
            }
    }
    
    func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint{
        self.convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }
    
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint{
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x) * self.zoomScale + panOffset.width,
            y: center.y + CGFloat(location.y) * self.zoomScale + panOffset.height
        )
    }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: (location.x - self.panOffset.width - center.x) / self.zoomScale,
            y: (location.y - self.panOffset.height - center.y) / self.zoomScale
        )
        return (Int(location.x), Int(location.y))
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize){
        if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0 {
            let hzoom = size.width / image.size.width
            let vzoom  = size.height / image.size.height
            self.steadyStatePanOffset = .zero
            self.steadyStateZoomScale = min(hzoom, vzoom)
        }
    }
}
