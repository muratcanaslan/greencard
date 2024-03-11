//
//  PermissionManager.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 7.03.2024.
//

import AVFoundation
import Photos
 
class PermissionManager {
    
    class func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
        case .restricted, .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        @unknown default:
            completion(false)
        }
    }
    
    class func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
        case .restricted, .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                completion(status == .authorized)
            }
        default:
            completion(false)
        }
    }
}
