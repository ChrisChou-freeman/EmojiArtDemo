//
//  UtilityExtensions.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/4/1.
//

import SwiftUI


extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Self.Index? {
        firstIndex(where: { $0.id == element.id })
    }
}

extension CGRect {
    var center: CGPoint{
        CGPoint(x: midX, y: midY)
    }
}

extension Character{
    var isEmoji: Bool {
        if let firstScalar = unicodeScalars.first, firstScalar.properties.isEmoji{
            return (firstScalar.value >= 0x238d || unicodeScalars.count > 1)
        }else{
            return false
        }
    }
}

extension CGSize {
    var center: CGPoint {
        CGPoint(x: self.width/2, y: self.height/2)
    }
    
    static func +(lhs: Self, rhs: Self) -> CGSize{
        CGSize(
            width: lhs.width + rhs.width,
            height: lhs.height + rhs.height
        )
    }
    
    static func -(lhs: Self, rhs: Self) -> CGSize{
        CGSize(
            width: lhs.width - rhs.width,
            height: lhs.height - rhs.height
        )
    }
    
    static func *(lhs: Self, rhs: CGFloat) -> CGSize{
        CGSize(
            width: lhs.width * rhs,
            height: lhs.height * rhs
        )
    }
    
    static func /(lhs: Self, rhs: CGFloat) -> CGSize{
        CGSize(
            width: lhs.width / rhs,
            height: lhs.height / rhs
        )
    }
}

extension Array where Element == NSItemProvider {
    func loadObjects<T>(
        ofType theType: T.Type,
        firstOnly: Bool = false,
        using load: @escaping (T) -> Void
    ) -> Bool where T: NSItemProviderReading{
        if let provider = first(where: { $0.canLoadObject(ofClass: theType) }) {
            provider.loadObject(ofClass: theType){ object, error in
                if let value = object as? T {
                    DispatchQueue.main.async {
                        load(value)
                    }
                }
            }
            return true
        }
        return false
    }
    
    func loadObjects<T>(
        ofType theType: T.Type,
        firstOnly: Bool = false,
        using load: @escaping (T) -> Void
    ) -> Bool where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
        if let provider = first(where: { $0.canLoadObject(ofClass: theType) }) {
            let _ = provider.loadObject(ofClass: theType){ object, error in
                if let value = object {
                    DispatchQueue.main.async {
                        load(value)
                    }
                }
            }
            return true
        }
        return false
    }
    
    func loadFirstObject<T>(
        ofType theType: T.Type,
        using load: @escaping (T) -> Void
    ) -> Bool where T: NSItemProviderReading {
        self.loadObjects(ofType: theType, firstOnly: true, using: load)
    }
    
    func loadFirstObject<T>(
        ofType theType: T.Type,
        using load: @escaping (T) -> Void
    ) -> Bool where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
        self.loadObjects(ofType: theType, firstOnly: true, using: load)
    }
}


extension URL {
    var imageURL: URL {
        for query in self.query?.components(separatedBy: "&") ?? [] {
            let queryComponents = query.components(separatedBy: "=")
            if queryComponents.count == 2 {
                if queryComponents[0] == "imgurl", let url = URL(string: queryComponents[1].removingPercentEncoding ?? "") {
                    return url
                }
            }
        }
        return baseURL ?? self
    }
}

struct OptionalImage: View{
    var uiImage: UIImage?
    var body: some View{
        if self.uiImage != nil{
            Image(uiImage: self.uiImage!)
        }
    }
}
