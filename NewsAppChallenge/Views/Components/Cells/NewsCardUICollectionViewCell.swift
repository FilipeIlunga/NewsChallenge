//
//  NewsCardUICollectionViewCell.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

import UIKit

class NewsCardUICollectionViewCell: UICollectionViewCell {
    static let identifier: String = "NewsCardUICollectionViewCell"
    var onReuse: () -> Void = {}

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
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(newsImageView)
        contentView.addSubview(title)
        contentView.addSubview(authorLabel)
        contentView.addSubview(source)

        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        let padding: CGFloat = 10.0
        let spacing: CGFloat = 5.0
        let imageHeight: CGFloat = 200.0
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            newsImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            
            title.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: padding),
            title.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor),
            
            source.topAnchor.constraint(equalTo: title.bottomAnchor, constant: spacing),
            source.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            source.trailingAnchor.constraint(lessThanOrEqualTo: contentView.centerXAnchor, constant: -spacing),
            
            authorLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: spacing),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            authorLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.centerXAnchor, constant: spacing)
        ])
    }
    
    func configureCell(news: News) {
        title.text = news.title
        source.text = news.source.name
        authorLabel.text = news.author
    }
    
    func updateImage(_ uiimage: UIImage) {
        newsImageView.image = uiimage
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
      onReuse()
        newsImageView.image = nil
    }
}
