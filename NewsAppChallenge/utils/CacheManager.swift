//
//  CacheManager.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 18/05/24.
//

import Foundation

final class CacheManager {
     var cache: [String: Any] = [:]
    private var maxSize: Int?
    
    static var shared = CacheManager()

    init(maxSize: Int? = nil) {
        self.maxSize = maxSize
    }

    func setValue(_ value: Any, forKey key:   String) {
        cache[key] = value

        // Verifica se o cache atingiu o tamanho máximo, se definido
        if let maxSize = maxSize, cache.count > maxSize {
            removeOldestItem()
        }
    }

    func value<T>(forKey key: String) -> T? {
        // Recupera um valor do cache
        return cache[key] as? T
        
    }

    func removeValue(forKey key: String) {
        // Remove um valor do cache
        cache[key] = nil
    }

    func removeAll() {
        // Remove todos os valores do cache
        cache.removeAll()
    }

    private func removeOldestItem() {
        // Remove o item mais antigo do cache se o tamanho máximo for atingido
        if let oldestKey = cache.keys.first {
            cache.removeValue(forKey: oldestKey)
        }
    }
}

