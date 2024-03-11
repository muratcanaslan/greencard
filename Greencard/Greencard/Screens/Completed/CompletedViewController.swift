//
//  CompletedViewController.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 8.03.2024.
//

import UIKit
import Kingfisher

final class CompletedViewController: BaseViewController {

    //MARK: - IBOutlets
    @IBOutlet private weak var completedView: CompletedView!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    //MARK: - Properties
    private let url: URL
    private let manager = CoreDataManager()
    
    var image: UIImage?
    
    //MARK: - Inits
    init(url: URL) {
        self.url = url
        super.init(nibName: "CompletedViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Base methods
    override func applyStyling() {
        super.applyStyling()
        
        shareButton.titleLabel?.font = .button
        shareButton.borderColor = .textColor
        shareButton.borderWidth = 1
        shareButton.backgroundColor = .yellowColor20
        shareButton.setTitleColor(.textColor, for: .normal)
        
        saveButton.setTitleColor(.textColor, for: .normal)
        saveButton.backgroundColor = .yellowColor
        saveButton.titleLabel?.font = .button
        
        saveButton.cornerRadius = 9
        shareButton.cornerRadius = 9
    }
    
    override func applyLocalizations() {
        super.applyLocalizations()
        
        navigationItem.title = "Ready to use!"
        saveButton.setTitle("Save to gallery", for: .normal)
        shareButton.setTitle("Share", for: .normal)
    }
    
    override func setupAfterInit() {
        super.setupAfterInit()
        
        setupImage()
        setCloseButton()
        scrollView.contentInset = .init(top: 0, left: 0, bottom: 240, right: 0)
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setCloseButton() {
        let button = UIBarButtonItem(image: UIImage(resource: .iconClose), style: .done, target: self, action: #selector(didTapClose))
        navigationItem.leftBarButtonItem = button
    }
    
    //MARK: - UI Helpers
    private func openPremium(onPurchased: (() -> Void)?) {
        DispatchQueue.main.async {
            let vc = UINavigationController(rootViewController: PremiumViewController(onPurchased: onPurchased))
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    private func setupImage() {
        HUDManager.showAnimation()
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            HUDManager.hideAnimation()
            switch result {
            case .success(let response):
                self?.image = response.image
                
                DispatchQueue.main.async {
                    self?.completedView.setupImage(with: response.image)
                    
                }
                self?.manager.addImage(time: Date(), content: response.image)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func saveImage(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.showSaveAlert()
    }
    
    private func openActivityShareImage(image: UIImage?) {
        guard let image else { return }
        let item = ShareableImage(image: image, title: "Greencard AI")
        let avc = UIActivityViewController(activityItems: [item] as [AnyObject], applicationActivities: nil)
        self.present(avc, animated: true, completion: nil)
    }
    
    private func showSaveAlert() {
        let alert = UIAlertController(title: "Your photo has been saved successfully.", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        ok.setValue(UIColor.textColor, forKey: "titleTextColor")
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    //MARK: - IBActions
    @objc private  func didTapClose() {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapShare(_ sender: UIButton) {
        guard let image else { return }
        if !UserManager.shared.isPremium {
            self.openPremium(onPurchased: {
                if UserManager.shared.isPremium {
                    self.openActivityShareImage(image: image)
                }
            })
        } else {
            self.openActivityShareImage(image: image)
        }
    }
    
    @IBAction private func didTapSave(_ sender: UIButton) {
        guard let image else { return }

        if !UserManager.shared.isPremium {
            self.openPremium(onPurchased: {
                if UserManager.shared.isPremium {
                    self.saveImage(image: image)
                }
            })
        } else {
            self.saveImage(image: image)
        }
    }
}
