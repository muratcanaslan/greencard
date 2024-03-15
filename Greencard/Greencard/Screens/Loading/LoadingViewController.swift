//
//  LoadingViewController.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 7.03.2024.
//

import UIKit

final class LoadingViewController: BaseViewController {

    //MARK: - IBOutlets
    @IBOutlet private weak var greencardImage: UIImageView!
    @IBOutlet private weak var ringTitle: UILabel!
    @IBOutlet private weak var ringView: CircleProgressView!
    @IBOutlet private weak var iconCheck1: UIImageView!
    @IBOutlet private weak var title1: UILabel!
    @IBOutlet private weak var iconCheck2: UIImageView!
    @IBOutlet private weak var title2: UILabel!
    @IBOutlet private weak var iconCheck3: UIImageView!
    @IBOutlet private weak var title3: UILabel!
    @IBOutlet private weak var iconCheck4: UIImageView!
    @IBOutlet private weak var title4: UILabel!
    
    //MARK: - Properties
    private let viewModel: LoadingViewModel
    
    private var timer: Timer?
    private var imageTimer: Timer?
    
    private var elapsedTime: TimeInterval = 0
    private let duration: TimeInterval = 4.0
    private var circlePath: UIBezierPath?
    private let shape = CAShapeLayer()
    let initialScale: CGFloat = 1
    lazy var initialTransform = CGAffineTransform(scaleX: initialScale, y: initialScale)
    
    var onHandler: ((URL?) -> Void)?
    init(image: UIImage, onHandler: ((URL?) -> Void)?) {
        self.onHandler = onHandler
        self.viewModel = LoadingViewModel(image: image)
        super.init(nibName: "LoadingViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Base methods
    override func applyStyling() {
        super.applyStyling()
        
        ringTitle.font = .subHeading
        ringTitle.textColor = .textColor
        
        title1.font = .bodyR
        title2.font = .bodyR
        title3.font = .bodyR
        title4.font = .bodyR
        
        title1.textColor = .textColor
        title2.textColor = .textColor
        title3.textColor = .textColor
        title4.textColor = .textColor
    }
    
    override func applyLocalizations() {
        super.applyLocalizations()
        
        title1.text = "Background removing"
        title2.text = "Adjusting size"
        title3.text = "Adjusting color"
        title4.text = "Adjusting quality..."
        ringTitle.text = "AI Adjusting..."
    }
  
    override func setupAfterInit() {
        super.setupAfterInit()
        greencardImage.transform = initialTransform

        setTimer()
        setPath()
        
        viewModel.removeBackgroundRequest()
    }
    
    override func setBlocks() {
        super.setBlocks()
    
        viewModel.onComplete = { url in
            self.loadingCompleteUI()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                self.dismiss(animated: true) {
                    self.onHandler?(url)
                }
            }
        }
        
        viewModel.onError = {
            self.dismiss(animated: true) {
                self.onHandler?(nil)
            }
        }
    }
    
    private func loadingCompleteUI() {
        DispatchQueue.main.async {
            self.iconCheck1.image = UIImage(resource: .iconCheck)
            self.title1.text = "Background removed"
            self.iconCheck2.image = UIImage(resource: .iconCheck)
            self.title2.text = "Adjusted size"
            self.iconCheck3.image = UIImage(resource: .iconCheck)
            self.title3.text = "Adjusted color"
            self.iconCheck4.image = UIImage(resource: .iconCheck)
            self.title4.text = "Adjusted quality..."
            
            self.ringTitle.text = "AI Adjusted..."
            
            self.ringView.progress = 1.0
        }
    }
    
    private func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
        
        imageTimer = Timer.scheduledTimer(timeInterval: 0.50, target: self, selector: #selector(updateGreencardImage), userInfo: nil, repeats: true)
    }
    
    private func setPath() {
        ringView.tintColor = .blueColor
        ringView.setupAnimationLayer(progressColor: .softGrayColor, showTriangle: false)
        ringView.progress = 0.0
        ringView.showTriangle = false
    }
    
    @objc private func updateUI() {
        elapsedTime += 1.0
        
        if elapsedTime == 1.0 {
            iconCheck1.image = UIImage(resource: .iconCheck)
            title1.text = "Background removed"
            ringView.progress = 0.25
        }
        
        if elapsedTime == 2.0 {
            iconCheck2.image = UIImage(resource: .iconCheck)
            title2.text = "Adjusted size"
            ringView.progress = 0.50
        }
        
        if elapsedTime == 3.0 {
            iconCheck3.image = UIImage(resource: .iconCheck)
            title3.text = "Adjusted color"
            ringView.progress = 0.75
        }
        
        if elapsedTime == 4.0 {
            iconCheck4.image = UIImage(resource: .iconCheck)
            title4.text = "Adjusted quality..."
            ringView.progress = 1.0
        }

        if elapsedTime >= duration {
            timer?.invalidate()
            self.viewModel.isAnimationFinsihed = true
        }
    }
    
    @objc func updateGreencardImage() {
        UIView.animate(withDuration: 1.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.5, // Spring damping factor
                                   initialSpringVelocity: 0.5, // Initial spring velocity
                                   options: [],
                                   animations: {
                                    // UIImageView'nin boyutunu küçültün veya normal boyuta geri döndürün
                                    if self.greencardImage.transform == .identity {
                                        self.greencardImage.transform = self.initialTransform
                                    } else {
                                        self.greencardImage.transform = .identity
                                    }
                    }, completion: nil)
    }
}


