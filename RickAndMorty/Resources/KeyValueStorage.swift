//
//  KeyValueStorage.swift
//  RickAndMorty
//
//  Created by Egor Karpov on 05.02.2023.
//

import Foundation

public protocol KeyValueStorage {
    func value<T: Codable>(forKey key: String) -> T?
    
    func set<T: Codable>(_ value: T?, forKey key: String)
    
    func removeValue(forKey key: String)
    
    func hasValue(forKey key: String) -> Bool
}

public final class UserDefaultsKeyValueStorage: KeyValueStorage {
    
    public func value<T>(forKey key: String) -> T? where T : Decodable, T : Encodable {
        userDefaults.object(forKey: key) as? T
    }
    
    public func set<T>(_ value: T?, forKey key: String) where T : Decodable, T : Encodable {
        userDefaults.set(value, forKey: key)
    }
    
    public func removeValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    public func hasValue(forKey key: String) -> Bool {
        userDefaults.object(forKey: key) != nil
    }
    
    
    private let userDefaults: UserDefaults
    
    public init(_ userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

public final class LikesStorage {
    private let userDefaults: UserDefaults
    private let key = "liked"
    
    init(_ userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        
        guard let _ = userDefaults.value(forKey: key) as? Array<Int> else {
            self.userDefaults.set(Array<Int>(), forKey: key)
            return
        }
    }
    
    public func like(id: Int) {
        let likes = userDefaults.array(forKey: key)!
        userDefaults.set(likes + [id], forKey: key)
    }
    
    public func dislike(id: Int) {
        let likes = userDefaults.array(forKey: key)!
        userDefaults.set(likes.filter{($0 as! Int) != id}, forKey: key)
    }
    
    public func isLiked(id: Int) -> Bool {
//        return userDefaults.mutableSetValue(forKey: key).contains(id)
        let likes = userDefaults.array(forKey: key)!
        return likes.contains(where: {($0 as! Int) == id})
    }
    
    public func listLikes() -> [Int] {
        return userDefaults.array(forKey: key)! as! Array<Int>
    }
}
