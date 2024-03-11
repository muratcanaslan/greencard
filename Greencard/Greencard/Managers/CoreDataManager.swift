//
//  CoreDataManager.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 9.03.2024.
//

import CoreData
import UIKit

final class CoreDataManager {
    private lazy var context = persistentContainer.viewContext
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        ValueTransformer.setValueTransformer(UIImageTransformer(), forName: NSValueTransformerName("UIImageTransformer"))
        persistentContainer = NSPersistentContainer(name: "Photos")
        persistentContainer.loadPersistentStores { desc, error in
            if let error {
                fatalError("Unable to initialize core data: \(error)")
            }
            
        }
    }
    
    func addImage(time: Date, content: UIImage) {
        do {
            let photo = Photo(context: context)
            photo.time = time
            photo.content = content
            
            try context.save()
        } catch {
            // Hata durumlarını kontrol et ve gerekirse uygun bir şekilde işle
            print("Fotoğraf kaydederken hata oluştu: \(error.localizedDescription)")
        }
    }
    
    func removeImage(id: NSManagedObjectID, completion: @escaping (() -> Void)) {
        do {
            let photo = try context.existingObject(with: id) as? Photo
            if let photo = photo {
                context.delete(photo)
                try context.save()
                completion()
            }
        } catch {
            print("Hata: Veri silinirken bir hata oluştu - \(error)")
            completion()
        }
    }
    
    func fetchImages(imagesCompletion: (([Photo]) -> Void)) {
        let request: NSFetchRequest<Photo> = NSFetchRequest(entityName: "Photo")
        
        do {
            let photos: [Photo] = try context.fetch(request)
            imagesCompletion(photos)
        } catch {
            imagesCompletion([])
        }
    }
}
