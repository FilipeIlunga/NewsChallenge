//
//  NewsCardUICollectionViewCell.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

import UIKit

class HorizontalTableViewCell: UITableViewCell {
    static let identifier: String = "HorizontalTableViewCell"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.85, height: 300)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
        setupConstraints()
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.register(NewsCardUICollectionViewCell.self, forCellWithReuseIdentifier: NewsCardUICollectionViewCell.identifier)
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

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
    
    private lazy var publishedAt: UILabel = {
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
        contentView.addSubview(publishedAt)
        contentView.addSubview(source)

        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            newsImageView.heightAnchor.constraint(equalToConstant: 200),
            
            title.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            source.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            source.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            source.trailingAnchor.constraint(lessThanOrEqualTo: contentView.centerXAnchor, constant: -5),
            
            publishedAt.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            publishedAt.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            publishedAt.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.centerXAnchor, constant: 5)
        ])
    }
    
    func configureCell(news: News) {
        title.text = news.title
        source.text = news.source.name
        publishedAt.text = news.publishedAt
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
