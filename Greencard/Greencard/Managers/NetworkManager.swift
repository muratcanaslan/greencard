//
//  NetworkManager.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 7.03.2024.
//

import UIKit
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
        
    private init () { }
    
    /// Begin task
    func start(image: UIImage, completion: @escaping (CompletedTaskResponse?) -> Void) {
        let size = "1200x1200"
        
        createTask(size: size, image: image) { taskId in
            let startTime = CFAbsoluteTimeGetCurrent()
            guard let taskId else { return }
            self.getTaskResult(taskId: taskId, taskStartTime: startTime) { result in
                completion(result)
            }
        }
    }

    /// Create a task
    private func createTask(size: String, image: UIImage, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: ConstantManager.baseURL) else { return }
        let headers: HTTPHeaders = [
            "X-API-KEY": ConstantManager.picWishApiKey
        ]
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(Data(imageData), withName: "image_file", fileName: "test.jpg", mimeType: "image/jpeg")
                if let sync = "0".data(using: .utf8) {
                    multipartFormData.append(sync, withName: "sync")
                }
                if let bgColor = "FFFFFF".data(using: .utf8) {
                    multipartFormData.append(bgColor, withName: "bg_color")
                }
                if let size = size.data(using: .utf8) {
                    multipartFormData.append(size, withName: "size")
                }
            }, to: url, method: .post, headers: headers).responseData { response in
                switch response.result {
                case .success(let value):
                    if let json = try? JSONSerialization.jsonObject(with: value) as? [String: Any],
                       let data = json["data"] as? [String: Any],
                       let taskId = data["task_id"] as? String {
                        completion(taskId)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            print("Failed to convert image to data")
        }
    }

    /// Get result
    private func getTaskResult(taskId: String,
                       taskStartTime: CFAbsoluteTime,
                       completion: @escaping (CompletedTaskResponse?) -> Void) {
        let url = URL(string: "\(ConstantManager.baseURL)/\(taskId)")!

        let headers: HTTPHeaders = [
            "X-API-KEY": ConstantManager.picWishApiKey
        ]

        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let value):
                print(response.debugDescription)
                guard let json = try? JSONSerialization.jsonObject(with: value) as? [String: Any],
                      let data = json["data"] as? [String: Any],
                      let state = data["state"] as? Int else {
                    print("parse failed")
                    return
                }
                // Task failed, log the details, and exit the loop
                if state < 0 {
                    completion(nil)
                    return
                }
                // Task successful
                if state == 1 {
                    do {
                        let model = try JSONDecoder().decode(CompletedTaskResponse.self, from: value)
                        completion(model)
                        return
                    }
                    catch {
                        completion(nil)
                        return
                    }
                }
                // Retrieve the results by looping only thirty times
                let endTime = CFAbsoluteTimeGetCurrent()
                if endTime - taskStartTime < 30 {
                    // Wait for one second between each loop iteration
                    sleep(1)
                    self.getTaskResult(taskId: taskId, taskStartTime: taskStartTime, completion: completion)
                    return
                }
                // Timeout, log the details, and search for support from the picwish service
                print("timeout")
            case .failure(let error):
                completion(nil)
                // Request from user server failed. Please record the relevant error logs
                print(error)
            }
        }
    }

}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
