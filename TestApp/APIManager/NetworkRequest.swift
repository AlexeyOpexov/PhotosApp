//
//  APIService.swift
//  TestApp
//
//  Created by OREKHOV ALEXEY on 14.10.2022.
//

import Foundation

enum NetworkRequest {
    
    case fetchPhotos(query: String, page: Int)
    case getPhotoInfo(id: String)
    
    enum Method: String {
        case get, post
    }
    
    var mainURL: URL {
        return APIConfiguration.shared.mainURL
    }
    
    var path: String {
        switch self {
            case .fetchPhotos:  return "/search/photos"
            case .getPhotoInfo: return "/photos"
        }
    }
    
    var headers: [String: String] {
        let headers = [
            "Authorization": "Client-ID \(APIConfiguration.shared.clientID)"
        ]
        return headers
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: mainURL)!
        
        
        switch self {
            case .fetchPhotos(query: let query, page: let page):
                let path = "?page=\(page)&query=\(query)"
                return createRequst(for: path, url: url)
                
            case .getPhotoInfo(id: let id):
                let path = "/photos/\(id)"
                return createRequst(for: path, url: url.absoluteURL)
        }
    }
    
    private func createRequst(for path: String, url: URL) -> URLRequest {
        let url = URL(string: path, relativeTo: url.absoluteURL)!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = NetworkRequest.Method.get.rawValue
        
        return request
    }
}
