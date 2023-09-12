//
//  NetworkViewModel.swift
//  StressDectect
//
//  Created by 陈汉超 on 2023/9/5.
//

import SwiftUI

final class NetworkViewModel: ObservableObject {
    @Published var user: GitHubUser?
    @Published var userName: String = "gogo"

    func doTask() async {
        do {
            let resUser = try await getUser()
            DispatchQueue.main.async {
                self.user = resUser
            }
        } catch GHError.invalidUrl {
            print("invalid Url")
        } catch GHError.invalidResponse {
            print("invalid Response")
        } catch GHError.invalidData {
            print("invalid Data")
        } catch {}
    }

    func getUser() async throws -> GitHubUser {
        let endpoint = "https://api.github.com/users/\(userName)"

        guard let url = URL(string: endpoint) else { throw GHError.invalidUrl }

        let (data, response) = try await URLSession.shared.data(from: url)
        print(response)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
}
