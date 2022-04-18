//
//  MainView.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/3/31.
//
import SwiftUI


struct DocView: View {
    @ObservedObject var document: DocumentHandler
    let testEmojis = "🐵🐒🦍🦧🐶🐕🦮🐕‍🦺🐩🐺🦊🦝🐱🐈🐈‍⬛🦁🐯🐆🐴🐎"
    let defaultEmojiFontSize: CGFloat = 40
    @State var steadyStatePanOffset = CGSize.zero
    @GestureState var gesturePanOffset = CGSize.zero
    @State var steadyStateZoomScale: CGFloat = 1
    @GestureState var gestureZoomScale: CGFloat = 1
    // for select element
    @State var selectedElements: [Int] = []
    @GestureState var selectedOffset: CGSize = CGSize.zero
    @GestureState var selectedZoom: CGFloat = 1
    
    var body: some View {
        VStack(spacing: 0) {
            self.documentBody
            self.palette
        }
    }
    
    var palette: some View {
        ScrollingEmojisView(emojis: self.testEmojis)
            .font(.system(size: self.defaultEmojiFontSize))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DocView(document: DocumentHandler())
    }
}
