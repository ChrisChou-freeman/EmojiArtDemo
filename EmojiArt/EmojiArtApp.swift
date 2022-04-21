//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/3/31.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject var paletteHandler = PaletteHandler(named: "Default")
    
    var body: some Scene {
        DocumentGroup(newDocument: { DocumentHandler() }) { config in
            DocView(document: config.document)
                .environmentObject(paletteHandler)
        }
    }
}
