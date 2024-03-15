//
//  LoadingViewModel.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 15.03.2024.
//

import UIKit

final class LoadingViewModel {
    
    var image: UIImage
    var onError: OnTap?
    var onComplete: ((URL) -> Void)?
    
    var isAnimationFinsihed = false {
        didSet {
            if let url = url, isRequestFinished {
                onComplete?(url)
            }
        }
    }
    var isRequestFinished = false {
        didSet {
            if let url = url, isAnimationFinsihed {
                onComplete?(url)
            }
        }
    }
    var url: URL?
    
    var isFinished: Bool {
        return isAnimationFinsihed && isRequestFinished
    }
    
    init(image: UIImage) {
        self.image = image
    }
    
    func removeBackgroundRequest() {        
        NetworkManager.shared.start(image: image) { [weak self] response in
            
            self?.isRequestFinished = true
            
            guard let imageString = response?.data?.image, let url = URL(string: imageString) else {
                self?.onError?()
                return
            }
            self?.url = url
            self?.isRequestFinished = true
        }
    }
}
