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

    var body: some View {
        VStack {
            AspectVGrid(items: game.cards, aspectRatio: 2 / 3) { card in
                CardView(card: card, isMatch: game.isMatch)
                    .padding(5)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
            HStack {
                Button(
                    action: { game.newGame() },
                    label: { Text("new game") }
                )
                .padding(.horizontal)
                Spacer()
                Button(
                    action: { game.pickCards() },
                    label: { Text("pick cards") }
                )
                .padding(.horizontal)
                .disabled(game.deck.isEmpty)
            }
        }
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
