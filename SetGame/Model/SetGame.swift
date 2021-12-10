//
// Created by 梁昊 on 2021/12/8.
//

import Foundation

struct SetGame {

    var cards: [Card]

    // Card indices that are selected
    var selectedIndices: [Int] {
        cards.indices.filter {
            cards[$0].isSelected
        }
    }

    init() {
        cards = []
        var generatedId = 0
        for color in CardColor.allCases {
            for shape in CardShape.allCases {
                for numberOfShapes in CardShapeNumber.allCases {
                    for shading in CardShading.allCases {
                        cards.append(Card(color: color, shape: shape, numberOfShapes: numberOfShapes, shading: shading, state: CardState.inDeck, id: generatedId))
                        generatedId += 1
                    }
                }
            }
        }
        cards = cards.shuffled()
    }

    mutating func flipCard(of index: Int) {
        cards[index].isFaceUp = true
    }

    mutating func dealCard(of index: Int) {
//        cards[index].isFaceUp = true
        cards[index].state = .onTable
    }

    private func isASet(indices: [Int]) -> Bool {
        let filteredCards = indices.map {
            cards[$0]
        }

        if (!filteredCards.map {
            $0.color
        }.allTheSameOrAllDifferent()) {
            return false
        }
        if (!filteredCards.map {
            $0.shape
        }.allTheSameOrAllDifferent()) {
            return false
        }
        if (!filteredCards.map {
            $0.shading
        }.allTheSameOrAllDifferent()) {
            return false
        }
        if (!filteredCards.map {
            $0.numberOfShapes
        }.allTheSameOrAllDifferent()) {
            return false
        }
        return true

    }

    mutating func select(_ card: Card) {
        if let selectIndex = cards.firstIndex(where: {
            card.id == $0.id
        }), cards[selectIndex].isMatched == .origin {
            cards[selectIndex].isSelected.toggle()
        }

        // Check whether there is a set when there are exactly 3 selected indices.
        if selectedIndices.count == 3 {
            if isASet(indices: selectedIndices) {
                selectedIndices.forEach {
                    cards[$0].isMatched = .matched
                }
            } else {
                selectedIndices.forEach {
                    cards[$0].isMatched = .unmatched
                }
            }
        } else if selectedIndices.count > 3 {
            selectedIndices.filter {
                cards[$0].id != card.id
            }.forEach { index in
                cards[index].isSelected = false
                if cards[index].isMatched == .matched {
                    cards[index].state = .collected
                    if let firstInDeckIndex = cards.firstIndex(where: { card in card.state == .inDeck }) {
                        dealCard(of: firstInDeckIndex)
                        cards.swapAt(index, firstInDeckIndex)
                    }
                } else {
                    cards[index].isMatched = .origin
                }
            }
        }
    }

    struct Card: Identifiable {
        var color: CardColor
        var shape: CardShape // diamond, squiggle, oval
        var numberOfShapes: CardShapeNumber
        var shading: CardShading // solid, striped, or open
        var state: CardState
        var id: Int
        var isSelected = false
        var isMatched: MatchState = .origin
        var isFaceUp = false
    }

    enum CardColor: CaseIterable {
        case red
        case green
        case blue
    }

    enum CardShape: CaseIterable {
        case diamond
        case rectangle
        case oval
    }

    enum CardShapeNumber: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3
    }

    enum CardShading: CaseIterable {
        case solid
        case semiTransparent
        case open
    }

    enum CardState: CaseIterable {
        case inDeck
        case onTable
        case collected
    }

    enum MatchState: CaseIterable {
        case matched
        case unmatched
        case origin
    }


}

extension Array where Element: Hashable {
    func allTheSame() -> Bool {
        Set(self).count == 1
    }

    func allDifferent() -> Bool {
        Set(self).count == self.count
    }

    func allTheSameOrAllDifferent() -> Bool {
        allTheSame() || allDifferent()
    }
}
