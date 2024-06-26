//
//  UIImageLoader.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 18/05/24.
//

import UIKit

class UIImageLoader {
  static let loader = UIImageLoader()

  private let imageLoader = ImageLoader()
  private var uuidMap = [UIImageView: UUID]()

  private init() {}

    func load(_ url: URL, for imageView: UIImageView, completion: @escaping (Data?) -> Void) {
        let token = imageLoader.loadImage(url) { result in
            defer { self.uuidMap.removeValue(forKey: imageView) }
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    imageView.image = image
                    completion(image.pngData())
                }
            } catch {
                completion(nil)
            }
        }
        
        if let token = token {
            uuidMap[imageView] = token
        }
    }

  func cancel(for imageView: UIImageView) {
      if let uuid = uuidMap[imageView] {
        imageLoader.cancelLoad(uuid)
        uuidMap.removeValue(forKey: imageView)
      }
  }
}
