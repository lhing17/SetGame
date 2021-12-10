//
//  ContentView.swift
//  SetGame
//
//  Created by 梁昊 on 2021/12/8.
//
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var game: SetGameViewModel
    @Namespace var deckNameSpace

    var body: some View {

        VStack {
            Text("SET!").font(.largeTitle)

            AspectVGrid(aspectRatio: 2 / 3, items: game.cards.filter {
                $0.state == .onTable
            }) { card in
                CardView(card: card)
                        .padding(2)
                        .matchedGeometryEffect(id: card.id, in: deckNameSpace)
                        .transition(.asymmetric(insertion: .scale, removal: .scale))
                        .onTapGesture {
                            game.select(card)
                        }
            }
            HStack {
                dealThreeMoreCards
                deckBody.frame(maxWidth: .infinity)
                newGame
            }
        }
                .foregroundColor(.purple)
                .padding(.horizontal)
    }

    private func zIndex(of card: SetGameViewModel.Card) -> Double {
        game.cards.firstIndex {
            $0.id == card.id
        }.map {
            -Double($0)
        } ?? 0
    }

    var deckBody: some View {
        ZStack {
            ForEach(game.cards) { card in
                if (card.state == .inDeck) {
                    CardView(card: card)
                            .frame(width: 65, height: 65 / 2 * 3).zIndex(zIndex(of: card))
                            .matchedGeometryEffect(id: card.id, in: deckNameSpace)

                            .transition(.asymmetric(insertion: .identity, removal: .identity))
                }

            }
        }
    }

    private func dealingAnimation(index: Int) -> Animation {
        let delay = 0.0
        return .easeInOut(duration: 1).delay(delay)
    }

    private func flippingAnimation(index: Int) -> Animation {
        let delay =  0.1
        return .easeInOut(duration: 1).delay(delay)
    }

    var dealThreeMoreCards: some View {
        Button("DEAL CARDS") {
            let onTableIndices = game.cards.indices.filter {
                game.cards[$0].state == .inDeck
            }
            if (onTableIndices.count >= 3) {
                onTableIndices[0..<3].enumerated()
                        .forEach { (index, onTableIndex) in

                            withAnimation(dealingAnimation(index: index)) {
                                game.dealCard(of: onTableIndex)
                            }
                            withAnimation(flippingAnimation(index: index)) {
                                game.flipCard(of: onTableIndex)
                            }
                        }
            }
        }
    }

    var newGame: some View {
        Button("NEW GAME") {
            game.startNewGame()
        }
    }
}

struct CardView: View {

    var card: SetGameViewModel.Card

    private func getColor(color: SetGame.CardColor) -> Color {
        switch color {

        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        }
    }

    @ViewBuilder
    private func getShape(shape: SetGame.CardShape, shading: SetGame.CardShading) -> some View {


        switch (shape, shading) {
        case (.diamond, .solid):
            Diamond().fill()
        case (.rectangle, .solid):
            Rectangle().fill()
        case (.oval, .solid):
            Circle().fill()
        case (.diamond, .semiTransparent):
            let r = Diamond()
            ZStack {
                r.opacity(0.5)
                r.stroke()
            }
        case (.rectangle, .semiTransparent):
            let r = Rectangle()
            ZStack {
                r.opacity(0.5)
                r.strokeBorder()
            }
        case (.oval, .semiTransparent):
            let r = Circle()
            ZStack {
                r.opacity(0.5)
                r.strokeBorder()
            }
        case (.diamond, .open):
            let r = Diamond()
            ZStack {
                r.fill(.white)
                r.stroke()
            }
        case (.rectangle, .open):
            let r = Rectangle()
            ZStack {
                r.fill(.white)
                r.strokeBorder()
            }
        case (.oval, .open):
            let r = Circle()
            ZStack {
                r.fill(.white)
                r.strokeBorder()
            }
        }
    }


    var body: some View {
        GeometryReader { geometry in
            VStack {
                ForEach(0..<card.numberOfShapes.rawValue, id: \.self) { index in
                    getShape(shape: card.shape, shading: card.shading).aspectRatio(2 / 1, contentMode: .fit)
                }
            }
                    .foregroundColor(getColor(color: card.color))
                    .padding(8)
                    .cardify(isFaceUp: card.isFaceUp, isMatched: card.isMatched, isSelected: card.isSelected)

        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: SetGameViewModel())
    }
}
