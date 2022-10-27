//
//  APIManager.swift
//  TestApp
//
//  Created by OREKHOV ALEXEY on 14.10.2022.
//

import SwiftUI
import Combine

class APIManager {
    static let shared = APIManager()
    private var cancellableSet = Set<AnyCancellable>()
    
    private init() {}
    
    private func requestHandler<T: Decodable>(_ request: URLRequest, completion: @escaping (T) -> Void) {
        return APIRequestDecoder.getRequest(for: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let err) = completion {
                    print("❌ Retrieving data failed with error \(err)")
                }
            } receiveValue: { response in
                completion(response)
            }
            .store(in: &cancellableSet)
    }
    
    
    func fetchPhotos(for query: String, page: Int, completion: @escaping (UnsplashQueryResult) -> Void) {
        let request = NetworkRequest.fetchPhotos(query: query, page: page).request
        print(request)
        requestHandler(request) { response in
            completion(response)
        }
    }
    
    func getPhotoInfo(by id: String, comletion: @escaping (UnsplashPhoto) -> Void) {
        let request = NetworkRequest.getPhotoInfo(id: id).request
        print(request)
        requestHandler(request) { response in
            comletion(response)
        }
    }
}
