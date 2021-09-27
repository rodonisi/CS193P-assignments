//
//  ContentView.swift
//  memorize
//
//  Created by Simon Amitiel Rodoni on 16.08.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject
    var viewModel: EmojiMemoryGame

    func getColor() -> Color {
        switch viewModel.currentTheme.color {
        case "red":
            return Color.red
        case "green":
            return Color.green
        case "blue":
            return Color.blue
        case "orange":
            return Color.orange
        case "purple":
            return Color.purple
        case "pink":
            return Color.pink
        default:
            return Color.black
        }
    }

    var body: some View {
        VStack {
            HStack {
                Text("Score: \(viewModel.score)")
                    .padding(.horizontal)
                Spacer()
                Text(viewModel.currentTheme.name).font(.largeTitle)
                Spacer()
                Button(
                    action: { viewModel.newGame() },
                    label: {
                        Text("New")
                    }
                )
                .padding(.horizontal)
            }
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(
                        viewModel.cards,
                        content: { card in
                            CardView(card: card)
                                .aspectRatio(2 / 3, contentMode: .fit)
                                .onTapGesture {
                                    viewModel.choose(card)
                                }
                        }
                    )
                }
                .padding()
                .foregroundColor(getColor())
            }
            .font(.largeTitle)
        }
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card

    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20.0)

            if card.isFaceUp {
                shape
                    .fill()
                    .foregroundColor(.white)
                shape
                    .stroke(lineWidth: 3)
                Text(card.content)
                    .font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0.0)
            } else {
                shape
                    .fill()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game)
            .preferredColorScheme(.dark)
    }
}
