//
//  UnsplashPhoto.swift
//  TestApp
//
//  Created by OREKHOV ALEXEY on 14.10.2022.
//

import Foundation

// A struct representing a photo from the Unsplash API.
public struct UnsplashPhoto: Codable, Identifiable {

    public enum URLKind: String, Codable {
        case raw
        case full
        case regular
        case small
        case thumb
    }


    public let id: String
    public let created: String
    public let user: UnsplashUser
    public let urls: [String: URL]
    public let likesCount: Int
    public let downloadsCount: Int?
    public let viewsCount: Int?
    
    public struct Location: Codable {
        let name, city, country: String?
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case created = "created_at"
        case user
        case urls
        case likesCount = "likes"
        case downloadsCount = "downloads"
        case viewsCount = "views"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        created = try container.decode(String.self, forKey: .created)
        user = try container.decode(UnsplashUser.self, forKey: .user)
        urls = try container.decode([String: URL].self, forKey: .urls)
        likesCount = try container.decode(Int.self, forKey: .likesCount)
        downloadsCount = try? container.decode(Int.self, forKey: .downloadsCount)
        viewsCount = try? container.decode(Int.self, forKey: .viewsCount)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(user, forKey: .user)
        try container.encode(created, forKey: .created)
        try container.encode(urls, forKey: .urls)
        try container.encode(likesCount, forKey: .likesCount)
        try? container.encode(downloadsCount, forKey: .downloadsCount)
        try? container.encode(viewsCount, forKey: .viewsCount)
    }
    
}
