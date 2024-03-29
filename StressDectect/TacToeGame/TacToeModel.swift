//
//  TacToeModel.swift
//  StressDectect
//
//  Created by 陈汉超 on 2023/9/5.
//

import Foundation
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
