//
//  NewsDetailViewController.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 17/05/24.
//

import UIKit

class NewsDetailViewController: UIViewController {
    private let news: News
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    private lazy var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var publishedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(news: News) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupImage()
        setupConstraints()
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            newsImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
        ])
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        title = news.source.name
        view.backgroundColor = .systemBackground
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(newsImageView)
        stackView.addArrangedSubview(publishedLabel)
        stackView.addArrangedSubview(contentLabel)
                
        titleLabel.text = news.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize)
        titleLabel.numberOfLines = 0
        
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        newsImageView.layer.cornerRadius = 8

        publishedLabel.text = formatData(news.publishedAt)
        publishedLabel.font = UIFont.preferredFont(forTextStyle: .footnote)

        contentLabel.text = news.content
        contentLabel.textAlignment = .justified
        contentLabel.numberOfLines = 0

    }
    
    private func setupImage() {
        guard let imageData = news.imageData else {
            let defaultImage = UIImage(named: "imageDefault") ?? UIImage()
            newsImageView.image = defaultImage
            return
        }
        
        newsImageView.image = UIImage(data: imageData)
    }
    
    private func formatData(_ data: String) -> String? {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = dateFormatter.date(from: data) else {
            print("Data inválida")
            return nil
        }

        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en_US") // Corrigido para inglês americano
        
        let formattedDate = dateFormatter.string(from: date)

        return formattedDate
    }
}
