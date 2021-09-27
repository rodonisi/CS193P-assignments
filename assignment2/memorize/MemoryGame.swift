//
//  MemoryGame.swift
//  MemoryGame
//
//  Created by Simon Amitiel Rodoni on 18.08.21.
//

import Foundation

struct MemoryGame<Content> where Content: Equatable {
    private(set) var cards: [Card]

    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    private(set) var score: Int = 0

    init(numberPairs: Int, createContent: (Int) -> Content) {
        cards = [Card]()
        for index in 0..<numberPairs {
            let content: Content = createContent(index)
            cards.append(Card(content: content, id: index * 2))
            cards.append(Card(content: content, id: index * 2 + 1))
        }
        cards.shuffle()
    }

    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content
                    == cards[potentialMatchIndex].content
                {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                    
                } else {
                    score -= cards[chosenIndex].flippedCount
                    score -= cards[potentialMatchIndex].flippedCount
                }
                cards[chosenIndex].flippedCount += 1
                cards[potentialMatchIndex].flippedCount += 1
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }

    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var flippedCount: Int = 0
        var content: Content

        var id: Int
    }
}
