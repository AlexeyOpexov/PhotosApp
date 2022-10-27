//
//  UnsplashResult.swift
//  TestApp
//
//  Created by OREKHOV ALEXEY on 14.10.2022.
//

import Foundation

struct UnsplashQueryResult: Codable {
    let total: Int
    let totalPages: Int
    let results: [UnsplashPhoto]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total = try container.decode(Int.self, forKey: .total)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
        results = try container.decode([UnsplashPhoto].self, forKey: .results)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(total, forKey: .total)
        try? container.encode(totalPages, forKey: .totalPages)
        try? container.encode(results, forKey: .results)
    }
}
