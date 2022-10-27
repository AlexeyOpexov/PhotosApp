//
//  TestAppApp.swift
//  TestApp
//
//  Created by OREKHOV ALEXEY on 14.10.2022.
//

import SwiftUI

@main
struct TestAppApp: App {
    
    @StateObject private var manager = CoreDataController()
    @StateObject private var photos = PhotosViewModel()
    @StateObject private var collection = CollectionViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, manager.container.viewContext)
                .environmentObject(photos)
                .environmentObject(collection)
        }
    }
}
