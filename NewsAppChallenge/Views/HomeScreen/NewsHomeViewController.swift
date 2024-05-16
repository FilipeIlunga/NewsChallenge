//
//  NewsHomeViewController.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 14/05/24.
//

import UIKit

class NewsHomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: NewsHomeViewModel
    private let tableView = UITableView()
    private lazy var newsFilterCollectionView = createNewsFilterCollectionView()
    private lazy var newsCardCollectionView = createNewsCardCollectionView()
    
    // MARK: - Initialization
    
    init(viewModel: NewsHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        selectInitialFilter()
        loadNews()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        [newsFilterCollectionView, newsCardCollectionView, tableView].forEach {
            view.addSubview($0)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            newsFilterCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsFilterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsFilterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsFilterCollectionView.heightAnchor.constraint(equalToConstant: 50),
//            
//            newsCardCollectionView.topAnchor.constraint(equalTo: newsFilterCollectionView.bottomAnchor, constant: 10),
//            newsCardCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            newsCardCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            newsCardCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            tableView.topAnchor.constraint(equalTo: newsFilterCollectionView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Private Methods
    
    private func createNewsFilterCollectionView() -> NewsFilterUICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = NewsFilterUICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    private func createNewsCardCollectionView() -> NewsCardUICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width * 0.85, height: 300)
        let collectionView = NewsCardUICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }
    
    private func selectInitialFilter() {
        let firstIndexPath = IndexPath(item: 0, section: 0)
        newsFilterCollectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: .left)
        newsFilterCollectionView.delegate?.collectionView?(newsFilterCollectionView, didSelectItemAt: firstIndexPath)
    }
    
    private func loadNews() {
        Task {
            await viewModel.fetchNews(type: .apple)
            DispatchQueue.main.async {
                self.newsCardCollectionView.reloadData()
                self.tableView.reloadData()
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
        
        cell.configureCell(news: newsItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Implement selection logic if needed
    }
}

// MARK: - UITableViewDataSource

extension NewsHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNews(for: .apple).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let newsItem = viewModel.getNews(for: .apple)[indexPath.row]
        cell.configure(news: newsItem)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewsHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Implement selection logic if needed
    }
}
