//
//  UIImageView+Extension.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 18/05/24.
//

import UIKit

extension UIImageView {
    func loadImage(at url: URL, completion: @escaping (Data?) -> Void) {
        UIImageLoader.loader.load(url, for: self, completion: completion)
    }

  func cancelImageLoad() {
    UIImageLoader.loader.cancel(for: self)
  }
}
