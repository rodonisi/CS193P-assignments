//
//  SetGame.swift
//  SetGame
//
//  Created by Simon Amitiel Rodoni on 22.08.21.
//

import Foundation

protocol SetEquatable {

    static func isSet(a: Self, b: Self, c: Self) -> Bool
}

struct SetGame<Content: SetEquatable> {

    private(set) var deck: [Card]
    private(set) var isMatch: Bool?

    init(count: Int, createContent: (Int) -> Content) {
        deck = []
        for index in 0..<count {
            deck.append(Card(id: index, content: createContent(index)))
        }
    }

    private var selectedCount: Int {
        return deck.filter({ $0.isSelected }).count
    }

    private var selectedIndices: [Int] {
        var selected = [Int]()
        for index in deck.indices {
            if deck[index].isSelected {
                selected.append(index)
            }
        }
        return selected
    }

    private var selectedCards: [Card] {
        selectedIndices.map { deck[$0] }
    }

    private func checkMatch() -> Bool? {
        let selected = selectedCards
        if selected.count >= 3 {
            return Content.isSet(
                a: selected[0].content,
                b: selected[1].content,
                c: selected[2].content
            )
        }

        return nil
    }

    private mutating func resetSelected() {
        for index in deck.indices { deck[index].isSelected = false }
        isMatch = nil
    }

    private mutating func pick(_ amount: Int) -> [Int] {
        let amountOrRemaining = amount < deck.count ? amount : deck.count
        let picked = deck.filter { $0.state == .undealt }[0..<amountOrRemaining]
        return picked.map { $0.id }

    }

    mutating func pickCards(_ amount: Int) {
        let ids = pick(amount)
        ids.forEach {
            deck[$0].state = .dealt
        }
    }

    mutating func removeMatched() {
        for index in selectedIndices.reversed() {
            deck[index].state = .discarded

            resetSelected()
        }
    }

    mutating func removeOrReplaceMatched() {
        if isMatch ?? false {
            let indices = selectedIndices
            var picked = pick(GameConstants.pickAmount)
            for index in indices {
                if !picked.isEmpty {
                    let pickedID = picked.removeLast()
                    if let pickedIndex = deck.firstIndex(where: {
                        $0.id == pickedID
                    }) {
                        deck[index].state = .discarded
                        deck[pickedIndex].state = .dealt
                        deck.swapAt(index, pickedIndex)
                    }
                }
            }
            resetSelected()
        } else {
            removeMatched()
        }
    }

    mutating func choose(_ card: Card) {
        if let index = deck.firstIndex(where: { $0.id == card.id }) {
            if isMatch ?? false {
                let selected = selectedIndices
                removeMatched()
                if selected.contains(index) { return }
            }

            if selectedCount >= 3 {
                resetSelected()
            }

            deck[index].isSelected.toggle()
            isMatch = checkMatch()
        }

    }

    enum CardState {
        case undealt
        case dealt
        case discarded
    }

    struct Card: Identifiable {
        var id: Int
        var isSelected: Bool = false
        var state: CardState = .undealt
        var content: Content
    }
}
