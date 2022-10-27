//
//  PhotoInfoViewModel.swift
//  TestApp
//
//  Created by OREKHOV ALEXEY on 22.10.2022.
//

import SwiftUI

class PhotoInfoViewModel: ObservableObject {
    
    @Published var photo: UnsplashPhoto?
    
    func getPhotoInfo(by id: String) {
        photo = nil
        
        APIManager.shared.getPhotoInfo(by: id) { result in
            self.photo = result
        }
    }
    
}
