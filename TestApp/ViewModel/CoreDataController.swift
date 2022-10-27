//
//  CoreDataController.swift
//  TestApp
//
//  Created by   imac on 26.10.2022.
//

import CoreData
import SwiftUI

class CoreDataController: ObservableObject {
    let container = NSPersistentContainer(name: "PhotoCollection")
    
    init() {
        container.loadPersistentStores { description, err in
            if let err = err {
                print("❌ CoreData failed to load: \(err.localizedDescription)")
            }
        }
    }
    
    func create(entity: UnsplashPhoto) {
        let context = container.viewContext

        let object = Photo(context: context)
        object.timestamp = Date()
        object.id = entity.id
        
        if context.hasChanges {
            do { try context.save() }
            catch {
                let nsError = error as NSError
                print("❌ Unresolved error with add new intake \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func remove(entity: UnsplashPhoto) {
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        let context = container.viewContext
        
        // TODO remove selected
        let removed = try? context.fetch(request)
        removed?.forEach() { photo in
            if photo.id == entity.id {
                context.delete(photo)
                
                if context.hasChanges {
                    try? context.save()
                }
            }
        }
    }
    
    func removeAll() {
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        let context = container.viewContext
        
        var fetchContent = try? context.fetch(request)
        fetchContent?.removeAll()
        
        if context.hasChanges {
            try? context.save()
        }
    }
}
