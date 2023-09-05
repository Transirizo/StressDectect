//
//  Network.swift
//  StressDectect
//
//  Created by 陈汉超 on 2023/9/5.
//

import Foundation
struct GitHubUser: Codable {
    let login: String?
    let avatarUrl: String?
    let bio: String?
}

enum GHError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}
