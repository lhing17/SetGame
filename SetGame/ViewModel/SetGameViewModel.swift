//
// Created by 梁昊 on 2021/12/8.
//

import SwiftUI

class SetGameViewModel: ObservableObject {

    typealias Card = SetGame.Card

    @Published private(set) var model: SetGame

    init() {
        model = SetGame()
    }

    var cards: [Card] {
        model.cards
    }


    // MARK: - Intent
    func dealCard(of index: Int) {
        model.dealCard(of: index)
    }

    func select(_ card: Card) {
        model.select(card)
    }

    func startNewGame() {
        model = SetGame()
    }

    func flipCard(of index: Int) {
        model.flipCard(of: index)
    }
}
