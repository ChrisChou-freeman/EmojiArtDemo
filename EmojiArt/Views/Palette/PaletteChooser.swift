//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/4/19.
//

import SwiftUI

struct PaletteChooser: View {
    @EnvironmentObject var pallette: PaletteHandler
    var EmojiFontSize: CGFloat
    @State private var chosenPaletteIndex = 0
    var emojiFont: Font{
        .system(size: EmojiFontSize)
    }
    var body: some View {
        HStack{
            paletteControButton
            paletteView(for: pallette.palette(at: chosenPaletteIndex))
        }
        .clipped()
        .padding()
    }
    
    func paletteView(for palette: Palette) -> some View{
        HStack{
            Text(palette.name)
            ScrollingEmojisView(emojis: palette.emojis)
                .font(emojiFont)
        }
        .id(palette.id)
        .transition(rollTransition)
    }
    
    @ViewBuilder
    var contextMenu: some View{
        AnimatedActionButton(title: "New", sysemImage: "plus"){
            pallette.insertPalette(named: "New", emojis: "", at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "Delete", sysemImage: "minus.circle"){
            chosenPaletteIndex = pallette.removePalette(at: chosenPaletteIndex)
        }
    }
    
    var gotoMenu: some View{
        Menu{
            ForEach(pallette.pallettes) { palette in
                AnimatedActionButton(title: palette.name) {
                    if let index = pallette.pallettes.index(matching: palette){
                        chosenPaletteIndex = index
                    }
                }
            }
        }label: {
            Label("Go To", systemImage: "text.insert")
        }
    }
    
    var paletteControButton: some View{
        Button{
            withAnimation{
                chosenPaletteIndex = (chosenPaletteIndex + 1) % pallette.pallettes.count
            }
        }label: {
            Image(systemName: "paintpalette")
        }
        .font(emojiFont)
        .contextMenu{contextMenu}
    }
    
    var rollTransition: AnyTransition{
        AnyTransition.asymmetric(
            insertion: .offset(x: 0, y: EmojiFontSize),
            removal: .offset(x: 0, y: -EmojiFontSize)
        )
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

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(EmojiFontSize: 40)
    }
}
