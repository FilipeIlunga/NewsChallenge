//
//  NewsHomeViewController.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 14/05/24.
//

import UIKit

class NewsHomeViewController: UIViewController {

    let viewModel: NewsHomeViewModel
    

    init(viewModel: NewsHomeViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(newsFilterCollectionView)

        setConstraints()
    }
    
    private lazy var  newsFilterCollectionView: NewsFilterUICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        var collectionView = NewsFilterUICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            newsFilterCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsFilterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsFilterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsFilterCollectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
