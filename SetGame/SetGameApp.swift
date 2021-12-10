//
//  SetGameApp.swift
//  SetGame
//
//  Created by 梁昊 on 2021/12/8.
//
//

import SwiftUI

@main
struct SetGameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(game: SetGameViewModel())
        }
    }
}
