//
//  MainView.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/3/31.
//
import SwiftUI


struct DocView: View {
    @EnvironmentObject var document: DocumentHandler
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
            HStack{
                PaletteChooser(EmojiFontSize: defaultEmojiFontSize)
                Spacer()
                self.deleteButton
            }
            .padding(.trailing, 30)
        }
    }
    
    var deleteButton: some View{
        Button{
            self.document.removeEmojiWithIDs(with: selectedElements)
            self.selectedElements.removeAll()
        }label: {
            Image(systemName: "delete.left.fill")
                .scaleEffect(2)
        }
    }
    
    enum FocusedArea: Hashable{
        case document
        case palette
    }
}


struct ContentView_Previews: PreviewProvider {
    static let document = DocumentHandler()
    static var previews: some View {
        DocView()
            .environmentObject(document)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
