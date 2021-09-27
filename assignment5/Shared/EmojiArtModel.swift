//
//  EmojiArtModel.swift
//  EmojiArtModel
//
//  Created by Simon Amitiel Rodoni on 28.08.21.
//

import Foundation

struct EmojiArtModel {
    var background: Background = .blank
    var emojis = [Emoji]()

    init() {}

    struct Emoji: Identifiable, Hashable {
        let text: String
        var x: Int
        var y: Int
        var size: Int
        var id: Int

        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }

    private var uniqueEmojiId = 0

    mutating func addEmoji(
        _ text: String,
        at location: (x: Int, y: Int),
        size: Int
    ) {
        emojis.append(
            Emoji(
                text: text,
                x: location.x,
                y: location.y,
                size: size,
                id: uniqueEmojiId
            )
        )
        uniqueEmojiId += 1
    }
    
    mutating func removeEmoji(at index: Int) {
        emojis.remove(at: index)
    }
}
