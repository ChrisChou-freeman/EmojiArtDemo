//
//  MainView.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/3/31.
//
import SwiftUI


struct MainView: View {
    @ObservedObject var document: EmojiArtHandler
    let testEmojis = "🐵🐒🦍🦧🐶🐕🦮🐕‍🦺🐩🐺🦊🦝🐱🐈🐈‍⬛🦁🐯🐆🐴🐎"
    let defaultEmojiFontSize: CGFloat = 40
    @State var steadyStatePanOffset = CGSize.zero
    @GestureState var gesturePanOffset = CGSize.zero
    @State var steadyStateZoomScale: CGFloat = 1
    @GestureState var gestureZoomScale: CGFloat = 1
    @State var selectedElement: String = ""
    
    var body: some View {
        VStack(spacing: 0){
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
        MainView(document: EmojiArtHandler())
    }
}
