//
//  HomeViewModel.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 7.03.2024.
//

import UIKit

final class HomeViewModel {
    
    var onStartRequest: OnTap?
    var onError: OnTap?
    var complete: OnTap?
    
    var url: URL?
    
    var image: UIImage? {
        didSet {
            removeBackgroundRequest()
        }
    }
    
    
    
    func removeBackgroundRequest() {
        guard let image else { return }
        
        onStartRequest?()
        
        NetworkManager.shared.start(image: image) { [weak self] response in
            
            guard let imageString = response?.data?.image, let url = URL(string: imageString) else {
                self?.onError?()
                return
            }
            self?.url = url
            self?.complete?()
        }
    }
    
}
