//
//  UIImageView+Extension.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 18/05/24.
//

import UIKit

extension UIImageView {
  func loadImage(at url: URL) {
    UIImageLoader.loader.load(url, for: self)
  }

  func cancelImageLoad() {
    UIImageLoader.loader.cancel(for: self)
  }
}
