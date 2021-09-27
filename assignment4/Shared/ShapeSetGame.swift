//
//  ShapeSetGame.swift
//  ShapeSetGame
//
//  Created by Simon Amitiel Rodoni on 23.08.21.
//

import Foundation

class ShapeSetGame: ObservableObject {
    typealias Card = SetGame<SetContent>.Card

    @Published
    private var game: SetGame<SetContent>
    private var isNewGame: Bool

    init() {
        game = ShapeSetGame.createGame()
        isNewGame = true
    }

    var deck: [Card] {
        game.deck
    }

    private static func generateDeck() -> [SetContent] {
        var deck = [SetContent]()
        for shape in SetContent.SetShape.allCases {
            for count in SetContent.SetCount.allCases {
                for shading in SetContent.SetShading.allCases {
                    for color in SetContent.SetColor.allCases {
                        deck.append(
                            SetContent(
                                shape: shape,
                                count: count,
                                shading: shading,
                                color: color
                            )
                        )
                    }
                }
            }
        }
        return deck
    }

    private static func createGame() -> SetGame<SetContent> {
        let deck = ShapeSetGame.generateDeck().shuffled()
        return SetGame(
            count: deck.count,
            createContent: { index in deck[index] }
        )
    }

    func choose(_ card: Card) {
        game.choose(card)
    }

    func firstPick() {
        game.pickCards(GameConstants.startWith)
    }

    func pickCards() {
        if isNewGame {
            firstPick()
            isNewGame.toggle()
        } else {
            // Perform normal deal.
            if game.isMatch ?? false {
                // Replace matched set
                game.removeOrReplaceMatched()
            } else {
                // Normal pick
                game.pickCards(GameConstants.pickAmount)
            }
        }
    }

    func newGame() {
        game = ShapeSetGame.createGame()
        isNewGame = true
    }

    var isMatch: Bool? { return game.isMatch }
}
