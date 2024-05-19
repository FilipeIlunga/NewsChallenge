//
//  ImageLoader.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 18/05/24 - This code is based on this article: https://www.donnywals.com/efficiently-loading-images-in-table-views-and-collection-views/
//

import UIKit

class ImageLoader {
    private var loadedImages: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 100 // Limit cache to 100 objects
        return cache
    }()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    private func handleData(_ data: Data?, _ url: NSURL, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let data = data, let image = UIImage(data: data) {
            self.loadedImages.setObject(image, forKey: url)
            completion(.success(image))
        } else {
            // Load default image from assets
            let defaultImage = UIImage(named: "imageDefault") ?? UIImage()
            completion(.success(defaultImage))
        }
    }
    
    private func handleError(_ error: Error?, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let error = error, (error as NSError).code != NSURLErrorCancelled {
            completion(.failure(error))
        }
    }
    
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        let url = url as NSURL
        if let image = loadedImages.object(forKey: url) {
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url as URL) { [weak self] data, response, error in
            guard let self = self else { return }
            
            defer { self.runningRequests.removeValue(forKey: uuid) }
            
            self.handleData(data, url, completion)
            self.handleError(error, completion)
        }
        task.resume()
        
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
