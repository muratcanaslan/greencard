//
//  ButtonsViewController.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 15.03.2024.
//

import UIKit
import PanModal

final class ButtonsViewController: UIViewController {

    @IBOutlet private weak var takeButton: UIButton!
    @IBOutlet private weak var uploadButton: UIButton!
    
    var onTake: OnTap?
    var onUpload: OnTap?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        takeButton.setTitle("Take a photo", for: .normal)
        uploadButton.setTitle("Upload photo", for: .normal)
        
        takeButton.backgroundColor = .yellowColor
        takeButton.titleLabel?.font = .button
        takeButton.setTitleColor(.textColor, for: .normal)
        takeButton.cornerRadius = 12
        
        uploadButton.borderColor = .textColor20
        uploadButton.borderWidth = 1
        uploadButton.backgroundColor = .yellowColor20
        uploadButton.titleLabel?.font = .button
        uploadButton.setTitleColor(.textColor, for: .normal)
        uploadButton.cornerRadius = 12
    }
    
    //MARK: - IBActions
    @IBAction func didTapUpload(_ sender: UIButton) {
        dismiss(animated: true) {
            self.onUpload?()
        }
    }
    
    @IBAction func didTapTake(_ sender: UIButton) {
        dismiss(animated: true) {
            self.onTake?()
        }
    }
}

extension ButtonsViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    var cornerRadius: CGFloat { 0 }
    var longFormHeight: PanModalHeight { .contentHeight(184) }
}
