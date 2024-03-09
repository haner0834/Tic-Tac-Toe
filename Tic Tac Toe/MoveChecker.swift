//
//  MoveChecker.swift
//  Tic Tac Toe
//
//  Created by Andy Lin on 2024/3/5.
//

import Foundation

class MoveChecker {
    var moves: [Move?]
    
    init(moves: [Move?]) {
        self.moves = moves
    }
    
    func isSquareOccupied(forIndex index: Int) -> Bool {
        //check the sqare if occupied
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func checkWin(for player: Player) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        // .compactMap: remove nil in Set, and filter is find the $0.player equals player in the Set
        let playerPosition = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPosition) { return true }
        //isSubset: check the Set is contain another Set
        
        return false
    }
    
    func checkDraw() -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
}
