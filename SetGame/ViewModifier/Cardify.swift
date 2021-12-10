//
// Created by 梁昊 on 2021/12/10.
//

import SwiftUI

struct Cardify: AnimatableModifier {

    var isMatched: SetGame.MatchState
    var isSelected: Bool

    var animatableData: Double {
        get {
            angle
        }
        set {
            angle = newValue
        }
    }

    var angle: Double

    init(isFaceUp: Bool, isMatched: SetGame.MatchState, isSelected: Bool) {
        angle = isFaceUp ? 180 : 0
        self.isMatched = isMatched
        self.isSelected = isSelected
    }

    func body(content: Content) -> some View {
        let cardBorder = RoundedRectangle(cornerRadius: 10)
        ZStack {
            if (angle > 90) {
                if (isMatched == .matched) {
                    cardBorder.fill(.green).opacity(0.5)
                } else if (isMatched == .unmatched) {
                    cardBorder.fill(.red).opacity(0.5)
                } else if (isSelected) {
                    cardBorder.fill(.yellow).opacity(0.5)
                } else {
                    cardBorder.fill(.white)
                }

                cardBorder.strokeBorder(lineWidth: 3)

            } else {
                cardBorder.fill()
            }
            content
                    .opacity(angle > 90 ? 100 : 0)
        }.rotation3DEffect(Angle(degrees: angle), axis: (0, 1, 0))

    }
}

extension View {
    func cardify(isFaceUp: Bool, isMatched: SetGame.MatchState, isSelected: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, isMatched: isMatched, isSelected: isSelected))
    }
}