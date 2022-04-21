//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/3/31.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject var document  = DocumentHandler()
    @StateObject var paletteHandler = PaletteHandler(named: "Default")
    
    var body: some Scene {
        WindowGroup {
            DocView()
                .environmentObject(document)
                .environmentObject(paletteHandler)
        }
    }
}
