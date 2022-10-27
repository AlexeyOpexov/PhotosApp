//
//  CollectionView.swift
//  TestApp
//
//  Created by   imac on 25.10.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct CollectionView: View {
    
    @EnvironmentObject var collection: CollectionViewModel
    @Binding var details: Bool
    @Binding var selectedPhoto: UnsplashPhoto?
    
    let columns = [GridItem(.flexible(), spacing: 2), GridItem(.flexible(), spacing: 2)]
    
    @ViewBuilder
    var body: some View {
        ZStack {
            // MARK: - Background
            Color.black.opacity(0.9).edgesIgnoringSafeArea(.all)

            // MARK: - Collection
            if !collection.favorites.isEmpty {
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(collection.favorites.reversed(), id: \.key) { _, photo in
                            photoCell(photo)
                                .onTapGesture {
                                    withAnimation {
                                        selectedPhoto = photo
                                        details = true
                                    }
                                }
                        }
                    }
                }
            } else {
                Text("Add photos in favorites")
                    .foregroundColor(.white)
            }
        }
        
    }
    
    @ViewBuilder
    func photoCell(_ photo: UnsplashPhoto) -> some View {
        let thumb = UnsplashPhoto.URLKind.thumb.rawValue
        let screenWidth = UIScreen.main.bounds.width / 2
        
        WebImage(url: photo.urls[thumb])
            .resizable()
            .scaledToFill()
            .frame(width: screenWidth, height: screenWidth, alignment: .center)
            .clipped()
            .overlay(alignment: .bottomTrailing, content: {
                Text(photo.user.name ?? "no name")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .font(.callout)
                    .padding()
                    .shadow(color: .black, radius: 5)
            })
    }
    
}


