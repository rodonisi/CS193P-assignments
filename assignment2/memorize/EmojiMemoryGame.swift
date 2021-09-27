//
//  EmojiMemoryGame.swift
//  EmojiMemoryGame
//
//  Created by Simon Amitiel Rodoni on 18.08.21.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    static let themes = [
        Theme<String>(
            name: "Vehicles",
            pairsCount: 10,
            color: "red",
            contents: [
                "🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛",
                "🚜", "🦯", "🦽", "🦼", "🛴", "🚲", "🛵", "🏍", "🛺", "🚨", "🚔", "🚍", "🚘",
                "🚖", "🚡", "🚠", "🚟", "🚃", "🚋", "🚞", "🚝", "🚄", "🚅", "🚈", "🚂", "🚆",
                "🚇", "🚊", "🚉", "✈️", "🛫", "🛬", "🛩", "💺", "🛰", "🚀", "🛸", "🚁", "🛶",
                "⛵️", "🚤", "🛥", "🛳", "⛴", "🚢",
            ]
        ),
        Theme<String>(
            name: "Vegetables",
            color: "green",
            contents: [
                "🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑",
                "🥭", "🍍", "🥥", "🥝", "🍅", "🍆", "🥑", "🥦", "🥬", "🥒", "🌶", "🫑", "🌽",
                "🥕", "🫒", "🧄", "🧅", "🥔", "🍠",
            ]
        ),
        Theme<String>(
            name: "Animals",
            pairsCount: 5,
            color: "blue",
            contents: [
                "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮",
                "🐷", "🐽", "🐸", "🐵", "🙈", "🙉", "🙊", "🐒", "🐔", "🐧", "🐦", "🐤", "🐣",
                "🐥", "🦆", "🦅", "🦉", "🦇", "🐺", "🐗", "🐴", "🦄", "🐝", "🪱", "🐛", "🦋",
                "🐌", "🐞", "🐜", "🪰", "🪲", "🪳", "🦟", "🦗", "🕷", "🕸", "🦂", "🐢", "🐍",
                "🦎", "🦖", "🦕", "🐙", "🦑", "🦐", "🦞", "🦀", "🐡", "🐠", "🐟", "🐬", "🐳",
                "🐋", "🦈", "🐊", "🐅", "🐆", "🦓", "🦍", "🦧", "🦣", "🐘", "🦛", "🦏", "🐪",
                "🐫", "🦒", "🦘", "🦬", "🐃", "🐂", "🐄", "🐎", "🐖", "🐏", "🐑", "🦙", "🐐",
                "🦌", "🐕", "🐩", "🦮", "🐕‍🦺", "🐈", "🐈‍⬛", "🪶", "🐓", "🦃", "🦤", "🦚", "🦜",
                "🦢", "🦩", "🕊", "🐇", "🦝", "🦨", "🦡", "🦫", "🦦", "🦥", "🐁", "🐀", "🐿",
                "🦔",
            ]
        ),
        Theme<String>(
            name: "Halloween",
            pairsCount: 15,
            color: "orange",
            contents: [
                "😈", "👿", "👹", "👺", "🤡", "💩", "👻", "💀", "☠️", "👽", "👾", "🤖", "🎃",
            ]
        ),
        Theme<String>(
            name: "Food",
            pairsCount: 8,
            color: "purple",
            contents: [
                "🥐", "🥯", "🍞", "🥖", "🥨", "🧀", "🥚", "🍳", "🧈", "🥞", "🧇", "🥓", "🥩",
                "🍗", "🍖", "🦴", "🌭", "🍔", "🍟", "🍕", "🫓", "🥪", "🥙", "🧆", "🌮", "🌯",
                "🫔", "🥗", "🥘", "🫕", "🥫", "🍝", "🍜", "🍲", "🍛", "🍣", "🍱", "🥟", "🦪",
                "🍤", "🍙", "🍚", "🍘",
            ]

        ),
        Theme<String>(
            name: "Sports",
            pairsCount: 9,
            color: "pink",
            contents: [
                "⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🥏", "🎱", "🪀", "🏓", "🏸",
                "🏒", "🏑", "🥍", "🏏", "🪃", "🥅", "⛳️", "🪁", "🏹", "🎣", "🤿", "🥊", "🥋",
                "🎽", "🛹", "🛼", "🛷", "⛸", "🥌", "🎿",
            ]
        ),
    ]

    static func createMemoryGame() -> (MemoryGame<String>, Theme<String>) {
        let theme = EmojiMemoryGame.themes.randomElement()!
        let content = theme.getRandomContents()
        return (
            MemoryGame(
                numberPairs: theme.pairsCount < theme.contents.count
                    ? theme.pairsCount : theme.contents.count,
                createContent: { index in content[index] }
            ), theme
        )
    }

    @Published
    private var model: MemoryGame<String>

    private(set) var currentTheme: Theme<String>

    init() {
        let game = EmojiMemoryGame.createMemoryGame()
        self.model = game.0
        self.currentTheme = game.1
    }

    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    
    var score: Int {
        return model.score
    }

    // MARK: - Intent(s)
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }

    func newGame() {
        let game = EmojiMemoryGame.createMemoryGame()
        model = game.0
        currentTheme = game.1
    }
}
