//
//  AlertView.swift
//  StressDectect
//
//  Created by 陈汉超 on 2023/9/4.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

enum AlertContext {
    static let humanWin = AlertItem(title: Text("You Win"), message: Text("You are so smart, you beat your own AI"), buttonTitle: Text("Hell Yeah"))
    static let computerWin = AlertItem(title: Text("You Lost"), message: Text("Sorry, your own AI beat you"), buttonTitle: Text("Hell No"))
    static let draw = AlertItem(title: Text("Draw"), message: Text("What a battle"), buttonTitle: Text("Try Again"))
}
