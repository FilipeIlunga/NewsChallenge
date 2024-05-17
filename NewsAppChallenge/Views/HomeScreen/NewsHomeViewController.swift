//
//  NewsHomeViewController.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 14/05/24.
//

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
        
        [newsFilterCollectionView, tableView].forEach {
            view.addSubview($0)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.register(HorizontalTableViewCell.self, forCellReuseIdentifier: HorizontalTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            newsFilterCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsFilterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsFilterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsFilterCollectionView.heightAnchor.constraint(equalToConstant: 50),
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
    
    private func selectInitialFilter() {
        let firstIndexPath = IndexPath(item: 0, section: 0)
        newsFilterCollectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: .left)
        newsFilterCollectionView.delegate?.collectionView?(newsFilterCollectionView, didSelectItemAt: firstIndexPath)
    }
    
    private func loadNews() {
        Task {
            await viewModel.fetchNews(type: .apple)
            DispatchQueue.main.async {
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
        if section == 0 {
            return 1
        }
        return viewModel.getNews(for: .apple).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section

        if section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalTableViewCell.identifier, for: indexPath) as? HorizontalTableViewCell else {
                return UITableViewCell()
            }
            
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let newsItem = viewModel.getNews(for: .apple)[indexPath.row]

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
        
        cell.configure(news: newsItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 300
        default:
            return 100
        }
    }
}

// MARK: - UITableViewDelegate

extension NewsHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Implement selection logic if needed
    }
}
