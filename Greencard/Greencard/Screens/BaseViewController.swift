//
//  BaseViewController.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 3.03.2024.
//

import UIKit

typealias OnTap = () -> Void

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
        
        view.backgroundColor = .white
        
        applyStyling()
        applyLocalizations()
        setupAfterInit()
        setBlocks()
    }
    
    func applyStyling() { }
    func applyLocalizations() { }
    func setupAfterInit() { }
    func setBlocks() { }
}
