//
//  CollectionViewCell.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 3.03.2024.
//

import UIKit

final class SampleTitleCollectionCell: UICollectionReusableView {

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    var onTapInfo: OnTap?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headerLabel.text = "Photo samples"
        headerLabel.textColor = .textColor
        headerLabel.font  = .subHeading
        
        infoButton.setTitleColor(.blueColor, for: .normal)
        infoButton.titleLabel?.font = .bodyM
    }
    
    @IBAction private func didTapInfo(_ sender: UIButton) {
        onTapInfo?()
    }
}
