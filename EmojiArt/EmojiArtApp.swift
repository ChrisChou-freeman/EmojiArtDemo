//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/3/31.
//

import SwiftUI

// need to do
// 1. select item and move item
// 2. select item and zoom item
// 3. select item and delete item

@main
struct EmojiArtApp: App {
    let document  = DocumentHandler()
    
    var body: some Scene {
        WindowGroup {
            DocView(document: document)
        }
    }
}
