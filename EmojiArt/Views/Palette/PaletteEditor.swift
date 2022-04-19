//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/4/19.
//

import SwiftUI

struct PaletteEditor: View {
    @State var pallete: Palette = PaletteHandler(named: "Text").palette(at: 0)
    var body: some View {
        Form {
            TextField("Name", text: $pallete.name)
        }
    }
}

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        PaletteEditor()
            .previewLayout(.fixed(width: 300, height: 350))
    }
}
