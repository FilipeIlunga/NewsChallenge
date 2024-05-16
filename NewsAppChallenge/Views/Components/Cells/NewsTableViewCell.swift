//
//  NewsTableViewCell.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let newsImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let sourceLabel = UILabel()
    static let identifier = "NewsTableViewCell"
    
    private var infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 4
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 18
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
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
    
    // MARK: - Setup
    
    private func setupView() {
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(descriptionLabel)
        infoStackView.addArrangedSubview(sourceLabel)
        
        mainStackView.addArrangedSubview(newsImageView)
        mainStackView.addArrangedSubview(infoStackView)
        
        contentView.addSubview(mainStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            newsImageView.widthAnchor.constraint(equalToConstant: 100),
            newsImageView.heightAnchor.constraint(equalToConstant: 100),

        ])
    }
    
    func configure(news: News) {
        titleLabel.text = news.title
        descriptionLabel.text = news.description
        sourceLabel.text = news.source.name
    }
}
