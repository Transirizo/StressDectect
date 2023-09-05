//
//  NetworkView.swift
//  StressDectect
//
//  Created by 陈汉超 on 2023/9/5.
//

import SwiftUI

struct NetworkView: View {
    @StateObject private var vm = NetworkViewModel()
    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: vm.user?.avatarUrl ?? "")) { image in
                image.resizable().aspectRatio(contentMode: .fit).clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.secondary)
            }.frame(width: 120, height: 120)
            Text(vm.user?.login ?? "UserName")
                .bold()
                .font(.title)

            Text(vm.user?.bio ?? "This is bio blblblblblbblblblb")
                .font(.subheadline)
                .padding()

            TextField("User Name", text: $vm.userName)
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.blue)
                )
                .padding()
                .shadow(color: .gray.opacity(0.4), radius: 3, x: 1, y: 2)

            Spacer()

            Button("Retry") {
                Task {
                    await vm.doTask()
                }
            }
        }
        .padding()
        .task {
            await vm.doTask()
        }
    }
}

struct NetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkView()
    }
}
