//
//  PhotosViewController.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 7.03.2024.
//

import UIKit

final class PhotosViewController: BaseViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let viewModel = PhotosViewModel()
    
    var onUpload: OnTap?
    var onTake: OnTap?
    
    override func applyLocalizations() {
        super.applyLocalizations()
        
        navigationItem.title = "My photos"
    }
    
    override func setupAfterInit() {
        super.setupAfterInit()
        
        setupCollectionView()
        setBackButton()
        viewModel.fetchPhotos()
    }
    
    override func setBlocks() {
        super.setBlocks()
        
        viewModel.onSuccess = {
            self.reload()
        }
    }
    
    private func setBackButton() {
        let back = UIBarButtonItem(image: UIImage(resource: .iconBack), style: .done, target: self, action: #selector(didTapBack))
        navigationItem.leftBarButtonItem = back
    }
    
    @objc private func didTapBack() {
        dismiss(animated: true)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: PhotosCollectionCell.self)
        collectionView.contentInset = .init(top: 16, left: 24, bottom: 240, right: 24)
    }
    
    private func reload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func createActionSheet(item: PhotosCollectionCellViewModel) {
        let share = UIAlertAction(title: "Share", style: .destructive) { [weak self] _ in
            if !UserManager.shared.isPremium {
                self?.openPremium(onPurchased: {
                    if UserManager.shared.isPremium {
                        self?.openActivityShareImage(image: item.content)
                        self?.reload()
                    }
                })
            } else {
                self?.openActivityShareImage(image: item.content)
            }
        }
        
        let save = UIAlertAction(title: "Save", style: .destructive) { [weak self] _ in
            if !UserManager.shared.isPremium {
                self?.openPremium(onPurchased: {
                    if UserManager.shared.isPremium {
                        self?.saveImage(image: item.content)
                        self?.reload()
                    }
                })
            } else {
                self?.saveImage(image: item.content)
            }
        }
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            guard let date = item.date, let image = item.content else { return }
            self.viewModel.manager.removeImage(id: item.id) {
                self.viewModel.fetchPhotos()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        share.setValue(UIColor.textColor, forKey: "titleTextColor")
        save.setValue(UIColor.textColor, forKey: "titleTextColor")
        delete.setValue(UIColor.warningColor, forKey: "titleTextColor")

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(share)
        actionSheet.addAction(save)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(actionSheet, animated: true)
        }
    }
    
    private func openPremium(onPurchased: (() -> Void)?) {
        DispatchQueue.main.async {
            let vc = UINavigationController(rootViewController: PremiumViewController(onPurchased: onPurchased))
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    private func saveImage(image: UIImage?) {
        guard let image else { return }
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
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellVMs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PhotosCollectionCell.self)
        cell.configure(with: viewModel.cellVMs[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.cellVMs[indexPath.item]
        switch item.type {
        case .add:
            let vc = ButtonsViewController()
            vc.onTake = {
                self.dismiss(animated: true) {
                    self.onTake?()
                }
            }
            vc.onUpload = {
                self.dismiss(animated: true) {
                    self.onUpload?()
                }
            }
            self.presentPanModal(vc)
        case .user:
            createActionSheet(item: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /// Cell width değeri paddingler cıkartılarak hesaplanmıstır.
        let width = (collectionView.frame.width / 2) - 36
        /// Cell height değeri
        let height: CGFloat = 178
        
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
}
