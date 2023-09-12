//
//  TacToeViewModel.swift
//  StressDectect
//
//  Created by 陈汉超 on 2023/9/5.
//

import SwiftUI

final class TacToeViewModel: ObservableObject {
    let coloums: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isBoardDisable = false
    @Published var alertItem: AlertItem?
    
    func isSquareOccupied(in moves: [Move?], for Index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == Index })
    }
    
    func processMove(for i: Int) {
        if isSquareOccupied(in: moves, for: i) { return }
        moves[i] = Move(player: .human, boardIndex: i)
        if checkWin(for: .human, moves: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkDraw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        isBoardDisable = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerMove = deteminComputerMovePosition(in: moves)
            moves[computerMove] = Move(player: .computer, boardIndex: computerMove)
            isBoardDisable = false
            if checkWin(for: .computer, moves: moves) {
                alertItem = AlertContext.computerWin
                return
            }
            if checkDraw(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func deteminComputerMovePosition(in moves: [Move?]) -> Int {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        // if can win, then win
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPosition = Set(computerMoves.map { $0.boardIndex })
        for patten in winPatterns {
            let winPosition = patten.subtracting(computerPosition)
            
            if winPosition.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, for: winPosition.first!)
                if isAvaiable { return winPosition.first! }
            }
        }
        
        // if can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPosition = Set(humanMoves.map { $0.boardIndex })
        for patten in winPatterns {
            let blockPosition = patten.subtracting(humanPosition)

            if blockPosition.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, for: blockPosition.first!)
                if isAvaiable { return blockPosition.first! }
            }
        }
        
        // if can't block, then take middle square
        if !isSquareOccupied(in: moves, for: 4) { return 4 }
        
        // if can't take, then take random square
        
        var movePosition = Int.random(in: 0 ..< 9)
        while isSquareOccupied(in: moves, for: movePosition) {
            movePosition = Int.random(in: 0 ..< 9)
        }
        return movePosition
    }
    
    func checkWin(for player: Player, moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 9], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPosition = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPosition) { return true }
        
        return false
    }
    
    func checkDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetNewGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
