//
//  Tic Tac Toe View Modle.swift
//  Tic Tac Toe
//
//  Created by Andy Lin on 2023/9/9.
//

import SwiftUI

final class TicTacToeViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
//    @Published var moves: [Move?] = [Move(player: .human, boardIndex: 0), Move(player: .computer, boardIndex: 1), nil, nil, nil, nil, nil, nil, nil]
    @Published var isGameDisable = false
    @Published var alertItem: AlertItem?
    @Published var isPlayWithAI = true
    @Published var isHumanTurn = true
    @Published var xScore = 0
    @Published var oScore = 0
    
    func processPlayerMove(for position: Int) {
        let checker = MoveChecker()
        if isPlayWithAI {
            // human's turn
            let checker = MoveChecker()
            if checker.isSquareOccupied(in: moves, forIndex: position) { return }
            // return is means the code is just return, didn't do anything
            
            moves[position] = Move(player: .human, boardIndex: position)
            
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                // check for win or draw
                if checker.checkWin(in: moves, for: .human) {
                    xScore += 1
                    alertItem = AlertContext.humanWin
                    return
                }
                
                if checker.checkDraw(in: moves) {
                    alertItem = AlertContext.drawWithComputer
                    return
                }
    //        }
            
            // computer's turn
            isGameDisable = true
            isHumanTurn = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [self] in
    //            let computerPosition = AIComputerPlayer(in: moves)
//                let computerPosition = AIPlayer.main.move(in: moves)
                let computerPosition = AIPlayer.main.smarterMove(in: moves)
                
                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                    let checker = MoveChecker()
                    if checker.checkWin(in: moves, for: .computer) {
                        oScore += 1
                        alertItem = AlertContext.computerWin
                        return
                    }
                    
                    if checker.checkDraw(in: moves) {
                        alertItem = AlertContext.drawWithComputer
                        return
                    }
                    
                    isGameDisable = false
                    isHumanTurn = true
                }
            }
        }else {
            if checker.isSquareOccupied(in: moves, forIndex: position) { return }
            
            moves[position] = Move(player: isHumanTurn ? .human: .computer, boardIndex: position)
            
            if checker.checkWin(in: moves, for: isHumanTurn ? .human: .computer) {
                if isHumanTurn {
                    xScore += 1
                    alertItem = AlertContext.XWin
                }else {
                    oScore += 1
                    alertItem = AlertContext.OWin
                }
                return
            }
            
            if checker.checkDraw(in: moves) {
                alertItem = AlertContext.drawWithFriend
                return
            }
            
            isHumanTurn.toggle()
        }
    }
    
    private func processMoveWithFriend(to position: Int) {
        var checker = MoveChecker()
        if checker.isSquareOccupied(in: moves, forIndex: position) { return }
        
        moves[position] = Move(player: isHumanTurn ? .human: .computer, boardIndex: position)
        
        if checker.checkWin(in: moves, for: isHumanTurn ? .human: .computer) {
            if isHumanTurn {
                xScore += 1
                alertItem = AlertContext.XWin
            }else {
                oScore += 1
                alertItem = AlertContext.OWin
            }
            return
        }
        
        if checker.checkDraw(in: moves) {
            alertItem = AlertContext.drawWithFriend
            return
        }
        
        isHumanTurn.toggle()
    }
    
    private func processHumanMove(to position: Int) {
        var checker = MoveChecker()
        if checker.isSquareOccupied(in: moves, forIndex: position) { return }
        // return is means the code is just return, didn't do anything
        
        moves[position] = Move(player: .human, boardIndex: position)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            // check for win or draw
            if checker.checkWin(in: moves, for: .human) {
                xScore += 1
                alertItem = AlertContext.humanWin
                return
            }
            
            if checker.checkDraw(in: moves) {
                alertItem = AlertContext.drawWithComputer
                return
            }
//        }
    }
    
    private func processComputerMove() {
        isGameDisable = true
        isHumanTurn = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [self] in
//            let computerPosition = AIComputerPlayer(in: moves)
            let computerPosition = AIPlayer.main.move(in: moves)
            
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                let checker = MoveChecker()
                if checker.checkWin(in: moves, for: .computer) {
                    oScore += 1
                    alertItem = AlertContext.computerWin
                    return
                }
                
                if checker.checkDraw(in: moves) {
                    alertItem = AlertContext.drawWithComputer
                    return
                }
                
                isGameDisable = false
                isHumanTurn = true
            }
        }
    }
    
    func getWinPattern(for player: Player, in moves: [Move?]) -> Set<Int>? {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        
        //find all the position on the board moved by selected player(computer or human)
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        //find matching pattern and return it
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return pattern }
        
        return nil
    }
    
    ///just reset the game, doesn't change score of X or O
    func resetGame() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isGameDisable = false
            moves = Array(repeating: nil, count: 9)
            isHumanTurn = true
        }
    }
    
    ///It will also reset the score
    func changeMode(isPlayWithAI: Bool) {
        self.isPlayWithAI = isPlayWithAI
        xScore = 0
        oScore = 0
        resetGame()
    }
    
    func checkWinOrDraw(moves: [Move?]) {
        let checker = MoveChecker()
        if checker.checkWin(in: moves, for: .human) {
            xScore += 1
            alertItem = AlertContext.humanWin
            return
        }else if checker.checkWin(in: moves, for: .computer) {
            oScore += 1
            alertItem = AlertContext.computerWin
            return
        }
        if checker.checkDraw(in: moves) {
            alertItem = AlertContext.drawWithComputer
        }
    }
}
