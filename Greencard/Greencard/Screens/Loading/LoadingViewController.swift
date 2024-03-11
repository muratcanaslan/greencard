//
//  LoadingViewController.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 7.03.2024.
//

import UIKit

final class LoadingViewController: BaseViewController {

    //MARK: - IBOutlets
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
    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0
    private let duration: TimeInterval = 4.0
    private var circlePath: UIBezierPath?
    private let shape = CAShapeLayer()
    
    var onComplete: OnTap?
    
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
        
        title1.text = "Background removed"
        title2.text = "Adjusted size"
        title3.text = "Adjusted color"
        title4.text = "Adjusting quality..."
        ringTitle.text = "AI Adjusting..."
    }
  
    override func setupAfterInit() {
        super.setupAfterInit()
                
        setTimer()
        setPath()

    }
    
    func updateAdjustedTitle() {
        ringTitle.text = "Adjusted"
    }
    
    override func setBlocks() {
        super.setBlocks()
        
    }
    
    private func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
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
            ringView.progress = 0.25
        }
        
        if elapsedTime == 2.0 {
            iconCheck2.image = UIImage(resource: .iconCheck)
            ringView.progress = 0.50
        }
        
        if elapsedTime == 3.0 {
            iconCheck3.image = UIImage(resource: .iconCheck)
            ringView.progress = 0.75
        }
        
        if elapsedTime == 4.0 {
            iconCheck4.image = UIImage(resource: .iconCheck)
            ringView.progress = 1.0
        }

        if elapsedTime >= duration {
            timer?.invalidate()
            onComplete?()
        }
    }
    
}


