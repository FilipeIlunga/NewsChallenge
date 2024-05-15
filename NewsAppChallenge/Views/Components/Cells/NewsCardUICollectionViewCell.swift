//
//  NewsCardUICollectionViewCell.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

import UIKit

class NewsCardUICollectionViewCell: UICollectionViewCell {
    static let identifier: String = "NewsCardUICollectionViewCell"

    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var source: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var publishedAt: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(title)
        contentView.addSubview(publishedAt)
        contentView.addSubview(source)

        setConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
          NSLayoutConstraint.activate([
              imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
              imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
              imageView.heightAnchor.constraint(equalToConstant: 200),
              imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
              
              title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
              title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
              title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
              
              source.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
              source.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
              
              publishedAt.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
              publishedAt.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10)
          ])
      }
    
    func configureCell(news: News) {
        title.text = news.title
        source.text = news.source.name
        publishedAt.text = news.publishedAt

    }
    
    func updateImage(_ data: Data) {
        imageView.image = UIImage(data: data)
    }
    
}

