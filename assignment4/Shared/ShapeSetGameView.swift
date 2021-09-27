//
//  ShapeSetGameView.swift
//  Shared
//
//  Created by Simon Amitiel Rodoni on 22.08.21.
//

import SwiftUI

struct ShapeSetGameView: View {
    @ObservedObject
    var game: ShapeSetGame

    @Namespace
    private var setNamespace

    var body: some View {
        VStack {
            gameBody
            HStack {
                discardedView
                    .padding()
                Spacer()
                newGameButton
                    .padding()
                Spacer()
                deckView
                    .padding()
            }
        }
    }

    func zIndex(of card: ShapeSetGame.Card) -> Double {
        -Double(game.deck.firstIndex(where: { $0.id == card.id }) ?? 0)
    }

    var gameBody: some View {
        AspectVGrid(
            items: game.deck.filter { $0.state == .dealt },
            aspectRatio: 2 / 3
        ) { card in
            CardView(card: card, isMatch: game.isMatch, flip: true)
                .matchedGeometryEffect(id: card.id, in: setNamespace)
                .padding(5)
                .transition(.asymmetric(insertion: .identity, removal: .scale))
                .zIndex(zIndex(of: card))
                .onTapGesture {
                    withAnimation {
                        game.choose(card)
                    }
                }
        }
    }

    var newGameButton: some View {
        Button("new") {
            withAnimation {
                game.newGame()
            }
        }
    }

    var deckView: some View {
        DeckView(
            namespace: setNamespace,
            cards: game.deck.filter { $0.state == .undealt },
            cardsFaceUp: false,
            zIndex: zIndex

        )
        .onTapGesture {
            withAnimation {
                game.pickCards()
            }
        }
    }

    var discardedView: some View {
        DeckView(
            namespace: setNamespace,
            cards: game.deck.filter { $0.state == .discarded },
            cardsFaceUp: true,
            zIndex: zIndex
        )
    }
}

struct DeckView: View {
    var namespace: Namespace.ID

    var cards: [ShapeSetGame.Card]
    var cardsFaceUp: Bool
    var zIndex: (ShapeSetGame.Card) -> Double

    var body: some View {
        ZStack {
            ForEach(cards) { card in
                CardView(card: card, isMatch: false)
                    .matchedGeometryEffect(id: card.id, in: namespace)
                    .transition(
                        .asymmetric(insertion: .opacity, removal: .identity)
                    )
                    .zIndex(zIndex(card))
            }
        }
        .frame(
            width: DrawingConstants.deckWidth,
            height: DrawingConstants.deckHeight
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ShapeSetGame()
        ShapeSetGameView(game: game)
        ShapeSetGameView(game: game)
            .preferredColorScheme(.dark)
    }
}
