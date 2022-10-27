//
//  CollectionViewModel.swift
//  TestApp
//
//  Created by   imac on 25.10.2022.
//

import SwiftUI

class CollectionViewModel: ObservableObject {
    
    @Published var favorites = [String: UnsplashPhoto]()
     
    func addToFavorites(_ photo: UnsplashPhoto) {
        if favorites[photo.id] == nil {
            favorites[photo.id] = photo
            print("✅ \(photo.id) add to favorites")
        }
    }
    
    func removeFromFavorites(_ photo: UnsplashPhoto) {
        if favorites[photo.id] != nil {
            favorites[photo.id] = nil
            print("✅ \(photo.id) remove from favorites")
        }
    }
    
    func isContains(_ photoId: String) -> Bool {
        favorites.contains { $0.key == photoId }
    }
}
