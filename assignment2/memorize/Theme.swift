//
//  Theme.swift
//  Theme
//
//  Created by Simon Amitiel Rodoni on 19.08.21.
//

import Foundation

struct Theme<T: Equatable> {
    let name: String
    let pairsCount: Int
    let color: String
    let contents: [T]

    init(name: String, pairsCount: Int, color: String, contents: [T]) {
        self.name = name
        self.pairsCount = pairsCount
        self.color = color
        self.contents = contents
    }
    
    init(name: String, color: String, contents: [T]) {
        self.name = name
        self.pairsCount = contents.count
        self.color = color
        self.contents = contents
    }
    
    func getRandomContents() -> [T] {
        if contents.count < pairsCount { return contents }

        var pickedContents: [T] = []
        while pickedContents.count < pairsCount {
            if let pick = contents.randomElement() {
                if pickedContents.firstIndex(where: { $0 == pick }) == nil {
                    pickedContents.append(pick)
                }
            }
        }

        return pickedContents
    }
}
