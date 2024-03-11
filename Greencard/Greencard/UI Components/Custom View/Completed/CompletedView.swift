//
//  CompletedView.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 10.03.2024.
//

import UIKit

final class CompletedView: BaseView {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pixelLabel: UILabel!
    @IBOutlet weak var pixelValueLabel: UILabel!
    @IBOutlet weak var photoSizeLabel: UILabel!
    @IBOutlet weak var photoSizeValueLabel: UILabel!
    @IBOutlet weak var fileFormatLabel: UILabel!
    @IBOutlet weak var fileFormatValueLabel: UILabel!
    
    override func applyStyling() {
        super.applyStyling()
        
        imageView.borderWidth = 16
        imageView.borderColor = .softGrayColor
        
        titleLabel.textColor = .textColor
        titleLabel.font = .subHeading
        
        pixelLabel.textColor = .textColor
        pixelValueLabel.textColor = .textColor
        pixelLabel.font = .bodyM
        pixelValueLabel.font = .bodyR
        
        photoSizeLabel.textColor = .textColor
        photoSizeValueLabel.textColor = .textColor
        photoSizeLabel.font = .bodyM
        photoSizeValueLabel.font = .bodyR
        
        fileFormatLabel.textColor = .textColor
        fileFormatValueLabel.textColor = .textColor
        fileFormatLabel.font = .bodyM
        fileFormatValueLabel.font = .bodyR
    }
    
    override func applyLocalizations() {
        super.applyLocalizations()
        
        titleLabel.text = "US Green Card Photo"
        
        pixelLabel.text = "Photo pixel:"
        photoSizeLabel.text = "Photo size:"
        fileFormatLabel.text = "File format:"

    }
    
    override func setupAfterInit() {
        super.setupAfterInit()
    }
    
    public func setupImage(with image: UIImage) {
        imageView.image = image
        let widthInPixels = image.size.width * image.scale
        let heightInPixels = image.size.height * image.scale
        pixelValueLabel.text = "\(widthInPixels)x\(heightInPixels)"
        photoSizeValueLabel.text = "2x2 in"
        fileFormatValueLabel.text = "JPEG"
    }
    
}
