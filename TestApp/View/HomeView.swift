//
//  ContentView.swift
//  TestApp
//
//  Created by OREKHOV ALEXEY on 14.10.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    
    @EnvironmentObject var vm: PhotosViewModel
    
    @Namespace private var photoNamespace
    
    @StateObject private var coordinator = Coordinator()
    
    @State private var isShowDetails = false
    @State private var selectedPhoto: UnsplashPhoto?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Home screen
            Group {
                Color.black.opacity(0.9).edgesIgnoringSafeArea(.all)
                
                VStack {
                    QueryTextField
                    ResultScrollView
                }
            }.zIndex(coordinator.path == .search ? 2 : 1)
            
            CollectionView(details: $isShowDetails, selectedPhoto: $selectedPhoto)
                .frame(maxHeight: .infinity)
                .background(Color.white)
                .zIndex(coordinator.path == .collection ? 2 : 1)
            
            // Detailed screen
            if isShowDetails {
                if let selectedPhoto = selectedPhoto {
                    DetailedView(
                        showDetails: $isShowDetails,
                        selectedPhoto: selectedPhoto
                    )
                    .zIndex(4)
                    .matchedGeometryEffect(id: "photo.id", in: photoNamespace)
                }
            }
            // Custom Tabbar
            else {
                CustomTabView(coordinator: coordinator)
                    .zIndex(3)
            }
        }
    }
    
    var QueryTextField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
        
            TextField("...", text: $vm.query)
                .frame(height: 30)
                .autocapitalization(.none)
                .onSubmit {
                    vm.resetQuery()
                    vm.fetchPhotos()
                }
                .submitLabel(.done)
                .padding(.leading, 5)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color(UIColor.darkGray))
                )
        }
        .foregroundColor(.white)
        .padding()
    }
    
    @ViewBuilder
    var ResultScrollView: some View {
        if vm.photos.isEmpty {
            if vm.fetchProgress {
                ProgressView()
                    .frame(maxHeight: .infinity)
            } else {
                Text("Введите запрос")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(maxHeight: .infinity)
            }
        }
        
        else {
            // MARK: - Result
            ScrollView {
                LazyVStack(spacing: 1) {
                    ForEach(vm.photos) { photo in
                        photoCell(photo)
                    }
                }
                
                if vm.fetchProgress { ProgressView() }
            }.padding(.bottom, 50)
        }
    }
    
    @ViewBuilder
    func photoCell(_ photo: UnsplashPhoto) -> some View {
        let photoURL = photo.urls[UnsplashPhoto.URLKind.small.rawValue]
        
        WebImage(url: photoURL)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onTapGesture {
                selectedPhoto = photo
                withAnimation { isShowDetails = true }
            }
            .onAppear {
                if vm.photos.last?.id == photo.id {
                    vm.fetchNextPage()
                }
            }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(PhotosViewModel())
    }
}
