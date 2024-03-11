//
//  UserDefaultWrapper.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 9.03.2024.
//

import Foundation

@propertyWrapper
public struct UserDefaultWrapper<K: Codable> {
    
    public struct Wrapper<T>: Codable where T: Codable {
        let wrapped: T
    }
    
    private let key: String
    private let defaultValue: K
    
    public init(key: String, defaultValue: K) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: K {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data
                else { return defaultValue }
            let value = try? JSONDecoder().decode(Wrapper<K>.self, from: data)
            return value?.wrapped ?? defaultValue
        }
        set {
            do {
                let data = try JSONEncoder().encode(Wrapper(wrapped: newValue))
                UserDefaults.standard.set(data, forKey: key)
            } catch {
                print(error)
            }
        }
    }
}
