//
//  UnspashUser.swift
//  TestApp
//
//  Created by OREKHOV ALEXEY on 14.10.2022.
//



import Foundation

/// A struct representing a user's public profile from the Unsplash API.
public struct UnsplashUser: Codable {

    public let identifier: String
    public let username: String
    public let firstName: String?
    public let lastName: String?
    public let name: String?

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        username = try container.decode(String.self, forKey: .username)
        firstName = try? container.decode(String.self, forKey: .firstName)
        lastName = try? container.decode(String.self, forKey: .lastName)
        name = try? container.decode(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(username, forKey: .username)
        try? container.encode(firstName, forKey: .firstName)
        try? container.encode(lastName, forKey: .lastName)
        try? container.encode(name, forKey: .name)
    }

}

// MARK: - Convenience
extension UnsplashUser {
    var displayName: String {
        if let name = name {
            return name
        }

        if let firstName = firstName {
            if let lastName = lastName {
                return "\(firstName) \(lastName)"
            }
            return firstName
        }

        return username
    }

    var profileURL: URL? {
        return URL(string: "https://unsplash.com/@\(username)")
    }
}

// MARK: - Equatable
extension UnsplashUser: Equatable {
    public static func == (lhs: UnsplashUser, rhs: UnsplashUser) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
