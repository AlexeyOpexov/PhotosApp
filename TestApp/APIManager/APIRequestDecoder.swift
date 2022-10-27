//
//  APIDecoder.swift
//  TestApp
//
//  Created by OREKHOV ALEXEY on 14.10.2022.
//

import SwiftUI
import Combine

struct APIRequestDecoder {
    
    static func getRequest<T: Decodable>(for request: URLRequest) -> AnyPublisher<T, Swift.Error> {
        URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
