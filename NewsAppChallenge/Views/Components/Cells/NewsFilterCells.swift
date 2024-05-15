//
//  NewsFilterCells.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

import UIKit

class NewsFilterCells: UICollectionViewCell {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static let identifier: String = "NewsFilterCells"

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 16
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configureCell(with newsType: NewsType, isSelected: Bool) {
        label.text = newsType.name
        contentView.backgroundColor = isSelected ? .black : .white
        label.textColor = isSelected ? .white : .black
    }
}
