//
//  ContentView.swift
//  memorize
//
//  Created by Simon Amitiel Rodoni on 16.08.21.
//

import SwiftUI

struct ContentView: View {
    @State
    var emojis: [String]

    let vehicles = [
        "✈️", "🚂", "🚀", "🚜", "🚗", "🚕", "🚙", "🚌", "🏎", "🚓", "🚑", "🛻", "🚁", "🚤",
        "⛵️", "🛥", "🛸", "🛰",
    ]
    let vegetables = [
        "🍎", "🍐", "🍊", "🍋", "🍌", "🍇", "🫐", "🍆", "🥑", "🥦", "🥬", "🌽", "🧄", "🥔",
    ]
    let animals = [
        "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷",
        "🐸", "🐵",
    ]

    @State
    var emojiCount = 6

    
    init() {
        self.emojis = vegetables
    }

    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                    ForEach(
                        emojis.shuffled()[0..<8],
                        id: \.self,
                        content: { emoji in
                            CardView(content: emoji)
                                .aspectRatio(2 / 3, contentMode: .fit)
                        }
                    )
                }
                .padding()
                .foregroundColor(.red)
            }
            .font(.largeTitle)
            HStack {

                Button(
                    action: { emojis = vegetables },
                    label: {
                        VStack {
                            Image(systemName: "fork.knife")
                                .font(.largeTitle)
                            Text("vegetables")
                        }
                    }
                )
                .padding(.horizontal)
                Spacer()
                Button(
                    action: { emojis = animals },
                    label: {
                        VStack {
                            Image(systemName: "pawprint")
                                .font(.largeTitle)
                            Text("animals")
                        }
                    }
                )
                .padding(.horizontal)
                Spacer()
                Button(
                    action: { emojis = vehicles },
                    label: {
                        VStack {
                            Image(systemName: "car")
                                .font(.largeTitle)
                            Text("vehicles")
                        }
                    }
                )
                .padding(.horizontal)
            }

        }
    }
}

struct CardView: View {
    var content: String
    @State
    var isFaceUp: Bool = true

    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20.0)

            if isFaceUp {
                shape
                    .fill()
                    .foregroundColor(.white)
                shape
                    .stroke(lineWidth: 3)
                Text(content)
                    .font(.largeTitle)
            } else {
                shape
                    .fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
        ContentView()
            .preferredColorScheme(.light)
    }
}
