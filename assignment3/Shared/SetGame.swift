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
    private(set) var table: [Card] = []
    private(set) var isMatch: Bool?

    init(count: Int, createContent: (Int) -> Content) {
        self.init(
            count: count,
            createContent: createContent,
            startWith: GameConstants.startWith
        )
    }

    init(count: Int, createContent: (Int) -> Content, startWith: Int) {
        deck = []
        for index in 0..<count {
            deck.append(Card(id: index, content: createContent(index)))
        }
        pickCards(startWith)
    }

    private var selectedCount: Int {
        var count = 0
        table.forEach { if $0.isSelected { count += 1 } }
        return count
    }

    private var selectedIndices: [Int] {
        var selected = [Int]()
        for index in table.indices {
            if table[index].isSelected {
                selected.append(index)
            }
        }
        return selected
    }

    private var selectedCards: [Card] {
        selectedIndices.map { table[$0] }
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
        for index in table.indices { table[index].isSelected = false }
        isMatch = nil
    }

    private mutating func pick(_ amount: Int) -> [Card] {
        let amountOrRemaining = amount < deck.count ? amount : deck.count
        var picked = [Card]()
        for index in (0..<amountOrRemaining).reversed() {
            picked.append(deck[index])
            deck.remove(at: index)
        }
        return picked

    }

    mutating func pickCards(_ amount: Int) {
        table.append(contentsOf: pick(amount))
    }

    mutating func removeOrReplaceMatched() {
        var picked = pick(GameConstants.pickAmount)
        for index in selectedIndices.reversed() {
            if picked.isEmpty {
                table.remove(at: index)
            } else {
                table[index] = picked.last!
                picked.removeLast()
            }
            resetSelected()
        }
    }

    mutating func choose(_ card: Card) {
        if let index = table.firstIndex(where: { $0.id == card.id }) {

            if isMatch ?? false {
                let selected = selectedIndices
                removeOrReplaceMatched()
                if selected.contains(index) { return }
            }

            if selectedCount >= 3 {
                resetSelected()
            }

            table[index].isSelected.toggle()
            isMatch = checkMatch()
        }

    }

    struct Card: Identifiable {
        var id: Int
        var isSelected: Bool = false
        var isMatched: Bool = false
        var content: Content
    }
}
