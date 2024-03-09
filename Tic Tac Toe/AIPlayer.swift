//
//  AIPlayer.swift
//  Tic Tac Toe
//
//  Created by Andy Lin on 2024/3/5.
//

import Foundation

class AIPlayer {
    static var main: AIPlayer {
        return AIPlayer()
    }
    
    ///if AI can win, then win.
    ///if AI can't win, then block.
    ///if AI can't block, then take the middle square.
    ///if AI can't take the middle square, then take random square.
    ///
    ///You can use this function to decide the number that AI computer player's position on Tic Tac Toe game,
    ///for example:
    ///```swift
    ///let position = AIPlayer.main.move(in: moves)
    ///let AIMoves = Move(player: .computer, boardIndex: position)
    ///```
    func move(in moves: [Move?]) -> Int {
        let checker = MoveChecker(moves: moves)
        // If AI can win, then win
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        // .compactMap: remove nil in Set, and filter is used to find the $0.player equals .computer in the Set
        let computerPosition = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPosition)
            /* .subtracting(_: Set<Element>): check Set and the input Set, and only return the value that pravious Set has and the input Set doesn't
             for example, if there's two Set,
             let kkk: Set = [2, 5, 3, 7, 9]
             let jjj: Set = [1, 2, 3, 4, 5]
             and
             kkk.subtracting(jjj) will return [7, 9]
             */
            
            ///winPosition.count equals 1 means the number(position) u found is the position that can let AI win
            if winPositions.count == 1 {
                let isAvailable = !checker.isSquareOccupied(forIndex: winPositions.first!)
                
                if isAvailable { return winPositions.first! }
            }
        }
        
        // If AI can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPosition = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPosition)
            
            ///winPosition.count equals 1 means this position is the position that human can win after select this
            if winPositions.count == 1 {
                let isAvailable = !checker.isSquareOccupied(forIndex: winPositions.first!)
                
                if isAvailable { return winPositions.first! }
            }
        }
        
        // If AI can't block, then take middle square
        let middleSquare = 4
        if !checker.isSquareOccupied(forIndex: middleSquare){ return middleSquare }
        
        // If AI can't take middle square, take random available square
        var movePosition = Int.random(in: 0..<9)
        
        while checker.isSquareOccupied(forIndex: movePosition) {
            //didn't need add "self." is bcuz the moves is equals self.moves( self.moves will enter the function)
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
}

