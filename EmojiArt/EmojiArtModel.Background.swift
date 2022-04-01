//
//  EmojiArtModel.Background.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/4/1.
//

import Foundation


extension EmojiArtModel{
    enum Background{
        case blank
        case url(URL)
        case imageData(Date)
        
        var url: URL? {
            switch self {
                case .url(let url):
                    return url
                default:
                    return  nil
            }
        }
        
        var imageData: Date? {
            switch self {
                case .imageData(let data):
                    return data
                default:
                    return nil
            }
        }
        
    }
}
