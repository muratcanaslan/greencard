//
//  PhotosViewModel.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 9.03.2024.
//

import Foundation

class PhotosViewModel {
    var cellVMs = [PhotosCollectionCellViewModel]()
    
    let manager = CoreDataManager()
    
    var onSuccess: (() -> Void)?
    
    func fetchPhotos() {
        manager.fetchImages { [weak self] photos in
            self?.cellVMs = photos.map({ .init(model: $0, type: .user)}).reversed()
            self?.cellVMs.insert(.init(), at: 0)
            self?.onSuccess?()
        }
    }
}
