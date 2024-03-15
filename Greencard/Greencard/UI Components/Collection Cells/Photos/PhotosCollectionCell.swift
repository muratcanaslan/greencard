//
//  PhotosCollectionCell.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 7.03.2024.
//

import UIKit
import CoreData

final class PhotosCollectionCell: BaseCollectionViewCell {

    @IBOutlet weak var iconAdd: UIImageView!
    @IBOutlet weak var iconUser: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconWaterfall: UIImageView!

    override func applyStyling() {
        super.applyStyling()
        
        dateLabel.textColor = .textColor
        dateLabel.font = .caption
    }
    
    func configure(with model: PhotosCollectionCellViewModel) {
        
        iconAdd.isHidden = model.type == .user
        iconUser.backgroundColor = model.bgColor
                
        switch model.type {
        case .add:
            iconWaterfall.isHidden = true
            iconUser.image = nil
            iconAdd.image = UIImage(resource: .iconAdd)
            dateLabel.text = "Create new"
        case .user:
            iconWaterfall.isHidden = UserManager.shared.isPremium
            iconUser.image = model.content
            dateLabel.text = model.formatDate
        }
    }
}

enum PhotoType {
    case add
    case user
}

struct PhotosCollectionCellViewModel {
    var type: PhotoType
    var date: Date?
    var content: UIImage?
    var id: NSManagedObjectID

    var bgColor: UIColor {
        return type == .add ? .softGrayColor : .clear
    }
    
    init(model: Photo, type: PhotoType) {
        self.type = type
        self.date = model.time
        self.content = model.content
        self.id = model.objectID
    }
    
    init() {
        type = .add
        date = nil
        content = nil
        id = .init()
    }
    
    var formatDate: String {
        guard let date = date else {
            return "none"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
