//
//  HomeViewController.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 3.03.2024.
//

import UIKit
import SideMenu

final class HomeViewController: BaseViewController {

    @IBOutlet private weak var takeButton: UIButton!
    @IBOutlet private weak var uploadButton: UIButton!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    lazy var sideMenuNavigationVC = SideMenuNavigationController(rootViewController: SideMenuViewController(), settings: makeSettings())
    private let presentationStyle = SideMenuPresentationStyle.viewSlideOut

    var items: [SamplePhoto] = SamplePhoto.createSamples() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    let threshold: CGFloat = 10 // Eşik değeri
        
    override func applyStyling() {
        super.applyStyling()
  
        titleLabel.font = .mainHeading
        titleLabel.textColor = .white
        subtitleLabel.textColor = .white
        subtitleLabel.font = .bodyR
        
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
    
    override func applyLocalizations() {
        super.applyLocalizations()
        
        navigationItem.title = "Greencard AI"
        takeButton.setTitle("Take a photo", for: .normal)
        uploadButton.setTitle("Upload photo", for: .normal)
    }
    
    override func setupAfterInit() {
        super.setupAfterInit()
        
        setupCollectionView()
        addSideMenuItem()
        addPhotosItem()
        setupSideMenu()
    }
    
    private func setupSideMenu() {
        SideMenuManager.default.leftMenuNavigationController = sideMenuNavigationVC
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view)
    }
    
    private func makeSettings() -> SideMenuSettings {
        presentationStyle.backgroundColor = .white
        presentationStyle.menuStartAlpha = 1
        presentationStyle.menuScaleFactor = 1
        presentationStyle.presentingEndAlpha = 0.4
        presentationStyle.presentingScaleFactor = 1
        presentationStyle.menuOnTop = false
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = UIScreen.main.bounds.width * 0.7
        settings.statusBarEndAlpha = 0
        settings.dismissDuration = .leastNonzeroMagnitude
        return settings
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: 0, left: 24, bottom: 240, right: 24)
        collectionView.register(cellType: SampleCollectionCell.self)
        collectionView.register(UINib(nibName: "SampleTitleCollectionCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: SampleTitleCollectionCell.self))
    }
    
    private func addSideMenuItem() {
        let item = UIBarButtonItem(image: UIImage(resource: .iconSideMenu), style: .done, target: self, action: #selector(didTapSideMenu))
        navigationItem.leftBarButtonItem = item
    }
    
    private func addPhotosItem() {
        let item = UIBarButtonItem(title: "Photos", style: .done, target: self, action: #selector(didTapPhotos))
        item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.bodyM, NSAttributedString.Key.foregroundColor: UIColor.blueColor], for: .normal)
        navigationItem.rightBarButtonItem = item
    }
    
    private func openInfo() {
        let vc = InfoViewController()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                imagePicker.modalPresentationStyle = .popover
                imagePicker.modalTransitionStyle = .coverVertical
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    private func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func showOpenCameraSettingsAlert() {
        let alert = UIAlertController(title: nil, message: "You should open camera settings on app settings.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let go = UIAlertAction(title: "Open settings", style: .destructive) { [weak self] _ in
            self?.openSettings()
        }
        alert.addAction(cancel)
        alert.addAction(go)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func showOpenGallerySettingsAlert() {
        let alert = UIAlertController(title: nil, message:"You should open gallery settings on app settings.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let go = UIAlertAction(title: "Open settings", style: .destructive) { [weak self] _ in
            self?.openSettings()
        }
        
        alert.addAction(cancel)
        alert.addAction(go)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    func showRequestError() {
        let alert = UIAlertController(title: "Ooops!", message: "Check your photo or network connection.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    //MARK: - IBActions
    @IBAction func didTapUpload(_ sender: UIButton) {
        PermissionManager.checkPhotoLibraryPermission { [weak self] success in
            if success {
                self?.openGallery()
            } else {
                self?.showOpenGallerySettingsAlert()
            }
        }
    }
    
    @IBAction func didTapTake(_ sender: UIButton) {
        PermissionManager.checkCameraPermission { [weak self] success in
            if success {
                self?.openCamera()
            } else {
                self?.showOpenCameraSettingsAlert()
            }
        }
    }
    
    @objc private func didTapPhotos() {
        let vc = PhotosViewController()
        vc.onUpload = {
            PermissionManager.checkPhotoLibraryPermission { [weak self] success in
                if success {
                    self?.openGallery()
                } else {
                    self?.showOpenGallerySettingsAlert()
                }
            }
        }
        
        vc.onTake = {
            PermissionManager.checkCameraPermission { [weak self] success in
                if success {
                    self?.openCamera()
                } else {
                    self?.showOpenCameraSettingsAlert()
                }
            }
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .coverVertical
        self.present(nav, animated: true)
    }
    
    @objc func didTapSideMenu() {
        present(sideMenuNavigationVC, animated: true)
    }
    
    private func openLoadingScreen(with image: UIImage) {
        let vc = LoadingViewController(image: image) { [weak self] url in
            if let url {
                self?.openCompletedScreen(url: url)
            } else {
                self?.showRequestError()
            }
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    private func openCompletedScreen(url: URL) {
        let vc = UINavigationController(rootViewController: CompletedViewController(url: url))
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

//MARK: - UICollectionView DataSource&Delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SampleCollectionCell.self)
        cell.configure(with: items[indexPath.item])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: SampleTitleCollectionCell.self), for: indexPath) as? SampleTitleCollectionCell else { return UICollectionReusableView() }
        header.onTapInfo = { [weak self] in
            self?.openInfo()
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2) - 36
        let height: CGFloat = 196
        return .init(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: self.collectionView.frame.width, height: 70)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        // Eşik değeri kontrolü
        if offsetY > threshold {
            // Eşik değeri aşıldı, UIView'i animasyonlu bir şekilde gizle
            if !headerView.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.headerView.alpha = 0.0
                } completion: { _ in
                    self.headerView.isHidden = true
                }
            }
        } else {
            // Eşik değeri aşılmadı, UIView'i animasyonlu bir şekilde görünür yap
            if headerView.isHidden {
                headerView.isHidden = false
                UIView.animate(withDuration: 0.3) {
                    self.headerView.alpha = 1.0
                }
            }
        }
    }
}


//MARK: - UIImagePickerControllerDelegate
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let image = info[.originalImage] as? UIImage {
                self.openLoadingScreen(with: image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

