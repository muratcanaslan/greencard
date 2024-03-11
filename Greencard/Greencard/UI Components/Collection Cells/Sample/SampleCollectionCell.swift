//
//  SampleCollectionCell.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 3.03.2024.
//

import UIKit

final class SampleCollectionCell: BaseCollectionViewCell {

    @IBOutlet private weak var iconStatus: UIImageView!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var iconSample: UIImageView!
    
    override func applyStyling() {
        super.applyStyling()
        
        descLabel.textColor = .textColor
        descLabel.font = .additionalInfo
    }
    
    func configure(with model: SamplePhoto) {
        iconStatus.image = model.status ? UIImage(resource: .iconSuccess) : UIImage(resource: .iconWarning)
        descLabel.text = model.title
        iconSample.image = model.image
        
    }
}



struct SamplePhoto {
    let image: UIImage?
    let status: Bool
    let title: String
    
    
    static func createSamples() -> [Self] {
        return [
            .init(image: UIImage(named: "sample1"), status: true, title: "Accepted"),
            .init(image: UIImage(named: "sample1x"), status: false, title: "Facial expression is not neutral"),
            .init(image: UIImage(named: "sample2"), status: true, title: "Accepted"),
            .init(image: UIImage(named: "sample2x"), status: false, title: "Head subtly tilted down"),
            .init(image: UIImage(named: "sample3"), status: true, title: "Accepted"),
            .init(image: UIImage(named: "sample3x"), status: false, title: "Glasses are not allowed"),
            .init(image: UIImage(named: "sample4"), status: true, title: "Accepted"),
            .init(image: UIImage(named: "sample4x"), status: false, title: "There are shadows on the face"),
            .init(image: UIImage(named: "sample5"), status: true, title: "Accepted"),
            .init(image: UIImage(named: "sample5x"), status: false, title: "Full head not in photo, camera is too close."),
            .init(image: UIImage(named: "sample6"), status: true, title: "Accepted"),
            .init(image: UIImage(named: "sample6x"), status: false, title: "Glasses are not allowed"),
            .init(image: UIImage(named: "sample7"), status: true, title: "Accepted"),
            .init(image: UIImage(named: "sample7x"), status: false, title: "Face partly covered, shadows present"),
            .init(image: UIImage(named: "sample8"), status: true, title: "Accepted"),
            .init(image: UIImage(named: "sample8x"), status: false, title: "Hats are not allowed"),
            .init(image: UIImage(named: "sample9"), status: true, title: "Accepted"),
            .init(image: UIImage(named: "sample9x"), status: false, title: "Hair obscures a portion of the face"),
            
        ]
    }
}

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()

    class func setImage(_ image: UIImage, forKey key: String) {
        shared.setObject(image, forKey: key as NSString)
    }

    class func getImage(forKey key: String) -> UIImage? {
        return shared.object(forKey: key as NSString)
    }
}
