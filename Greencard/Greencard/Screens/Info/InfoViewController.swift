//
//  InfoViewController.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 7.03.2024.
//

import UIKit

final class InfoViewController: BaseViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoTitle1: UILabel!
    @IBOutlet weak var infoSubtitle1: UILabel!
    @IBOutlet weak var infoTitle2: UILabel!
    @IBOutlet weak var infoSubtitle2: UILabel!
    @IBOutlet weak var infoTitle3: UILabel!
    @IBOutlet weak var infoSubtitle3: UILabel!
    @IBOutlet weak var infoTitle4: UILabel!
    @IBOutlet weak var infoSubtitle4: UILabel!
    @IBOutlet weak var infoTitle5: UILabel!
    @IBOutlet weak var infoSubtitle5: UILabel!
    @IBOutlet weak var infoTitle6: UILabel!
    @IBOutlet weak var infoSubtitle6: UILabel!
    @IBOutlet weak var infoTitle7: UILabel!
    @IBOutlet weak var infoSubtitle7: UILabel!
    
    override func applyLocalizations() {
        super.applyLocalizations()
        
        titleLabel.text = "Info"
    }
    
    override func applyStyling() {
        super.applyStyling()
        
        titleLabel.textColor = .textColor
        titleLabel.font = .button
        
        infoSubtitle1.setLineSpacing(alignment: .left)
        infoSubtitle2.setLineSpacing(alignment: .left)
        infoSubtitle3.setLineSpacing(alignment: .left)
        infoSubtitle4.setLineSpacing(alignment: .left)
        infoSubtitle5.setLineSpacing(alignment: .left)
        infoSubtitle6.setLineSpacing(alignment: .left)
        infoSubtitle7.setLineSpacing(alignment: .left)
    }

    @IBAction func didTapClose(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
