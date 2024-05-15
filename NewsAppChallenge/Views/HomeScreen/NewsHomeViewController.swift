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
        view.addSubview(newsCardCollectionView)
        setConstraints()
        
        let firstIndexPath = IndexPath(item: 0, section: 0)
        newsFilterCollectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: .left)
        newsFilterCollectionView.delegate?.collectionView?(newsFilterCollectionView, didSelectItemAt: firstIndexPath)
        
        loadNews()
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
    
    private lazy var newsCardCollectionView: NewsCardUICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width * 0.85, height: 300)
        let collectionView = NewsCardUICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            newsFilterCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsFilterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsFilterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsFilterCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            newsCardCollectionView.topAnchor.constraint(equalTo: newsFilterCollectionView.bottomAnchor, constant: 10),
            newsCardCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsCardCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsCardCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }
    
    func loadNews() {
        Task {
                await viewModel.fetchNews(type: .apple)
                DispatchQueue.main.async {
                    self.newsCardCollectionView.reloadData()
                }
            
        }
    }
}


extension NewsHomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNews(for: .apple).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCardUICollectionViewCell.identifier, for: indexPath) as? NewsCardUICollectionViewCell else {
            return UICollectionViewCell()
        }
        let newsItem = viewModel.getNews(for: .apple)[indexPath.item]
        cell.configureCell(news: newsItem)
        if let urlImage = newsItem.urlToImage {
            viewModel.fetchImage(url: urlImage) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.updateImage(data)
                    }
                case .failure(let error):
                    print("Error fetching image: \(error)")
                }
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? NewsCardUICollectionViewCell {
            
        }
    }
    

}
