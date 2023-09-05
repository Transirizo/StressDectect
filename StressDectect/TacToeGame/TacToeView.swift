//
//  TacToeView.swift
//  StressDectect
//
//  Created by 陈汉超 on 20

import SwiftUI

struct TacToeView: View {
    let coloums: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isBoardDisable = false
    @State private var alertItem: AlertItem?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: coloums, spacing: 5) {
                    ForEach(0 ..< 9) { i in
                        ZStack {
                            Circle()
                                .foregroundColor(.red)
                                .opacity(0.5)
                                .frame(width: geometry.size.width / 3 - 15, height: geometry.size.width / 3 - 15)
                            Image(systemName: moves[i]?.indicator ?? "").resizable().frame(width: 40, height: 40).foregroundColor(.white)
                        }.onTapGesture {
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
                    }
                }
                .padding()
                .disabled(isBoardDisable)
                .alert(item: $alertItem) { alertItem in
                    Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle) {
                        resetNewGame()
                    })
                }
                Spacer()
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], for Index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == Index })
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

enum Player {
    case human
    case computer
}

struct Move {
    let player: Player
    let boardIndex: Int

    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct TacToeView_Previews: PreviewProvider {
    static var previews: some View {
        TacToeView()
    }
}
