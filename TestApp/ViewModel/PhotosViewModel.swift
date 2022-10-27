//
//  PhotosViewModel.swift
//  TestApp
//
//  Created by OREKHOV ALEXEY on 14.10.2022.
//

import SwiftUI


class PhotosViewModel: ObservableObject {
    
    @Published var query = "moto"
    @Published var fetchProgress = false
    @Published var currentPage = 1
    @Published var photos = [UnsplashPhoto]()

    init() { fetchPhotos() }
    
    func fetchPhotos() {
        fetchProgress = true
        
        APIManager.shared.fetchPhotos(for: query, page: currentPage) { result in
            if self.currentPage < result.totalPages || result.totalPages == 1 {
                self.photos += result.results
            }
            else { print("Last page") }
            
            self.fetchProgress = false
        }
    }
    
    func fetchNextPage() {
        currentPage += 1
        fetchPhotos()
    }
    
    func resetQuery() {
        currentPage = 1
        photos.removeAll()
    }
    
}

