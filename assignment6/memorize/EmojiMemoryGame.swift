//
//  EmojiMemoryGame.swift
//  EmojiMemoryGame
//
//  Created by Simon Amitiel Rodoni on 18.08.21.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card

    private static func pickRandom(from string: String, amount: Int) -> [String]
    {
        if string.isEmpty { return [] }

        let shuffled = string.shuffled()
        return shuffled[0..<amount].map { String($0) }
    }

    @Published
    private var model: MemoryGame<String>

    private var emojis: [String]

    private var safePairs: Int {
        let minPairs = max(theme.pairs, 2)
        return minPairs < theme.emojis.count ? minPairs : theme.emojis.count
    }

    var theme: MemoryTheme {
        willSet {
            if newValue != theme {
                print("restarted \(theme.name)")
                restart()
            }
        }
    }

    var cards: [Card] {
        return model.cards
    }

    var score: Double {
        return model.score
    }

    init(theme: MemoryTheme) {
        let emojis = EmojiMemoryGame.pickRandom(
            from: theme.emojis,
            amount: theme.pairs
        )
        let minPairs = max(theme.pairs, 2)
        self.theme = theme
        self.emojis = emojis
        self.model = MemoryGame(
            numberPairs: minPairs < theme.emojis.count
                ? minPairs : theme.emojis.count,
            createContent: { index in emojis[index] }
        )
    }

    // MARK: - Intent(s)
    func choose(_ card: Card) {
        model.choose(card)
    }

    func shuffle() {
        model.shuffle()
    }

    func restart() {
        emojis = EmojiMemoryGame.pickRandom(
            from: theme.emojis,
            amount: safePairs
        )
        model = MemoryGame(
            numberPairs: safePairs,
            createContent: { index in
                emojis[index]
            }
        )
    }
}
