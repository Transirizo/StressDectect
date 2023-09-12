//
//  TacToeView.swift
//  StressDectect
//
//  Created by 陈汉超 on 20

import SwiftUI

struct TacToeView: View {
    @StateObject private var viewModel = TacToeViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.coloums, spacing: 5) {
                    ForEach(0 ..< 9) { i in
                        ZStack {
                            SquareView(proxy: geometry)
                            MarkView(systemImage: viewModel.moves[i]?.indicator)
                        }.onTapGesture {
                            viewModel.processMove(for: i)
                        }
                    }
                }
                .padding()
                .disabled(viewModel.isBoardDisable)
                .alert(item: $viewModel.alertItem) { alertItem in
                    Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle) {
                        viewModel.resetNewGame()
                    })
                }
                Spacer()
            }
        }
    }
}

struct TacToeView_Previews: PreviewProvider {
    static var previews: some View {
        TacToeView()
    }
}

struct SquareView: View {
    var proxy: GeometryProxy
    var body: some View {
        Circle()
            .foregroundColor(.red)
            .opacity(0.5)
            .frame(width: proxy.size.width / 3 - 15, height: proxy.size.width / 3 - 15)
    }
}

struct MarkView: View {
    var systemImage: String?
    var body: some View {
        Image(systemName: systemImage ?? "")
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
