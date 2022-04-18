//
//  EmojiArtModel.Background.swift
//  EmojiArt
//
//  Created by ChrisChou on 2022/4/1.
//

import Foundation


extension DocumentModel{
    enum Background: Equatable{
        case blank
        case url(URL)
        case imageData(Data)
        
        var url: URL? {
            switch self {
                case .url(let url):
                    return url
                default:
                    return  nil
            }
        }
        
        var imageData: Data? {
            switch self {
                case .imageData(let data):
                    return data
                default:
                    return nil
            }
        }
        
    }
}
