

//
//  PhotoViewCover.swift
//  TestApp
//
//  Created by OREKHOV ALEXEY on 22.10.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailedView: View {
    
    @Environment(\.presentationMode) var presentaionMode
    
//    @Namespace private var photoNamespace
    
    @EnvironmentObject var queryResult: PhotosViewModel // Для подгрузки новой страницы
    @EnvironmentObject var collection: CollectionViewModel // для добавления в избранное
    @EnvironmentObject var coordinator: Coordinator
    //    @EnvironmentObject var storage: CoreDataController
    
    @StateObject var info = PhotoInfoViewModel() // Для информации о текущем фото
    
    @State var collectionTemp: [UnsplashPhoto] // Показываемый массив фотографий
    
    @State private var isShowControls = true
    @State private  var currentId = ""
    // Gesture
    @State private var currentAmount: Double = 0.0
    @State private var finalAmount: Double = 1.0
    
    @Binding var showDetails: Bool
    
    @State var selectedPhoto: UnsplashPhoto
    
    var body: some View {
        ZStack {
            // MARK: - Background
            Color.black.opacity(0.9)
                .edgesIgnoringSafeArea(.all)
            
            
            TabView(selection: $currentId) {
                ForEach(collectionTemp) { photo in
                    photoCell(photo)
                }
            }.tabViewStyle(.page(indexDisplayMode: .never))
            
            ControllButtons
        }
        
        .onTapGesture {
            withAnimation { isShowControls.toggle() }
        }
        .onAppear { currentId = selectedPhoto.id }
        .onChange(of: currentId) { photo in
            info.getPhotoInfo(by: photo)
        }
    }
    
    
    var ControllButtons: some View {
        VStack(alignment: .leading, spacing: 10) {
            // - Top
            HStack {
                Spacer().frame(maxWidth: .infinity, alignment: .center)

                Group {
                    if let user = info.photo?.user {
                        Text(user.name ?? "name")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.semibold)
                    } else {
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .fixedSize()

                Button {
                    withAnimation { showDetails = false }
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding()

                }.frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Spacer()
            // - Bottom
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    // Downloads count
                    if let downloads = info.photo?.downloadsCount {
                        HStack {
                            Image(systemName: "arrow.down.to.line")
                            Text("\(downloads)")
                        }
                    }
                    
                    // Published date
                    if let creation = info.photo?.created {
                        HStack {
                            Image(systemName: "calendar")
                            Text("\(getDate(creation))")
                        }
                    }
                }
                .foregroundColor(.white)
                .font(.footnote)
                
                Spacer()
                
                // Add to like
                Button(action: addToFavorites) {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(collection.isContains(currentId) ? .red : .white)
                }
                .frame(width: 60, height: 60, alignment: .center)
                .background(.black)
                .cornerRadius(.infinity)
                
            }.padding()
        }.opacity(isShowControls ? 1.0 : 0)
    }
    
    
    @ViewBuilder
    func photoCell(_ photo: UnsplashPhoto) -> some View {
        let small = UnsplashPhoto.URLKind.small.rawValue
//        let full = UnsplashPhoto.URLKind.full.rawValue
        
        WebImage(url: photo.urls[small])
            .placeholder(
                Image(uiImage:
                        loadImageFromCash(url: photo.urls[small]!.absoluteString))
                ).resizable()
            .resizable()
            .aspectRatio(contentMode: .fit)
            .tag(photo.id)
            .onAppear {
                // Load next page
                if collectionTemp.last?.id == photo.id {
                    if coordinator.path == .search {
                        queryResult.fetchNextPage()
                    }
                }
                selectedPhoto = photo
            }
            .onDisappear {
                currentAmount = 0
                finalAmount = 1.0
            }
            .scaleEffect(finalAmount + currentAmount)
            .gesture(
                MagnificationGesture()
                    .onChanged { amount in
                        currentAmount = amount - 1
                    }
                    .onEnded { amount in
                        finalAmount += currentAmount
                        currentAmount = 0
                    }
            )
    }
   
    // MARK: - Functions
    
    private func addToFavorites() {
        if let photo = info.photo {
            collection.isContains(currentId)
            ? collection.removeFromFavorites(photo)
            : collection.addToFavorites(photo)
        }
    }
    
    private func getDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let bufer = dateFormatter.date(from: date)
        dateFormatter.dateStyle = .long
        
        return dateFormatter.string(from: bufer ?? Date())
    }
}
