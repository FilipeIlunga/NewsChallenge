//
//  NewsTableViewCell.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    let newsImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let authorLabel = UILabel()
    static let identifier = "NewsTableViewCell"
    var onReuse: () -> Void = {}

    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
      onReuse()
      newsImageView.image = nil
    }
    
    // MARK: - Setup
    
    private func setupView() {
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        newsImageView.layer.cornerRadius = 8
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.numberOfLines = 1
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        authorLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(authorLabel)
    }
    
    private func setConstraints() {
        let imageWidth: CGFloat = 100
        let imageHeight: CGFloat = 90
        let padding: CGFloat = 10
        let horizontalSpacing: CGFloat = 18
        let verticalSpacing: CGFloat = 8
        
        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            newsImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            newsImageView.widthAnchor.constraint(equalToConstant: imageWidth),
            newsImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            
            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: horizontalSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.topAnchor.constraint(equalTo: newsImageView.topAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: verticalSpacing),
            
            authorLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: verticalSpacing),
            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: verticalSpacing)
        ])
    }
    
    func configure(news: News) {
        titleLabel.text = news.title
        descriptionLabel.text = news.description
        authorLabel.text = news.author
    }
    
    func updateImage(_ uiimage: UIImage) {
        newsImageView.image = uiimage
    }
    
}
