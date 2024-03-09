//
//  TicTacToeModel.swift
//  Tic Tac Toe
//
//  Created by Andy Lin on 2024/3/3.
//

import Foundation
import SwiftUI

enum Player {
    case computer, human
}

struct Move: Hashable {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player ==  .human ? "xmark": "circle"
    }
}
