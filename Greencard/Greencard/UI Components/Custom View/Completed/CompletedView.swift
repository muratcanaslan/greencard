//
//  CompletedView.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 10.03.2024.
//

import UIKit

final class CompletedView: BaseView {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var pixelLabel: UILabel!
    @IBOutlet private weak var pixelValueLabel: UILabel!
    @IBOutlet private weak var photoSizeLabel: UILabel!
    @IBOutlet private weak var photoSizeValueLabel: UILabel!
    @IBOutlet private weak var fileFormatLabel: UILabel!
    @IBOutlet private weak var fileFormatValueLabel: UILabel!
    @IBOutlet private weak var greencardTitleLabel: UILabel!
    @IBOutlet private weak var iconWaterfall: UIImageView!
    
    override func applyStyling() {
        super.applyStyling()
        
        imageView.borderWidth = 16
        imageView.borderColor = .softGrayColor
        
        greencardTitleLabel.textColor = .textColor
        greencardTitleLabel.font = .subHeading
        
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
        
        updateWaterfall()
    }
    
    override func applyLocalizations() {
        super.applyLocalizations()
        
        greencardTitleLabel.text = "US Green Card Photo"
        
        pixelLabel.text = "Photo pixel:"
        photoSizeLabel.text = "Photo size:"
        fileFormatLabel.text = "File format:"
        pixelValueLabel.text = "1200x1200"
        photoSizeValueLabel.text = "2x2 in"
        fileFormatValueLabel.text = "JPEG"
    }
    
    public func setupImage(with image: UIImage) {
        imageView.image = image
    }
    
    public func updateWaterfall() {
        iconWaterfall.isHidden = UserManager.shared.isPremium
    }
    
}
