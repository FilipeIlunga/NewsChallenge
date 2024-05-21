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
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private lazy var newsFilterCollectionView: NewsFilterUICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = NewsFilterUICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.filterDelegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    weak var coordinator: MainCoordinator?
    var loader = ImageLoader()
    
    // MARK: - Initialization
    init(viewModel: NewsHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.addObserver(self)
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
        setupTableView()
        fetchAllNews()
    }
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
           navigationItem.title = "News"
        navigationItem.largeTitleDisplayMode = .automatic
        [newsFilterCollectionView, tableView, activityIndicator].forEach {
            view.addSubview($0)
        }
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            newsFilterCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsFilterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsFilterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsFilterCollectionView.heightAnchor.constraint(equalToConstant: 50),
            tableView.topAnchor.constraint(equalTo: newsFilterCollectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.register(HorizontalTableViewCell.self, forCellReuseIdentifier: HorizontalTableViewCell.identifier)
    }
    
    // MARK: - Private Methods
    private func fetchAllNews() {
        startActivityIndicator()
        Task {
            await viewModel.fetchAllNews()
            stopActivityIndicator()
            tableView.reloadData()
        }
    }
    
    private func selectInitialFilter() {
        let firstIndexPath = IndexPath(item: 0, section: 0)
        newsFilterCollectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: .left)
        newsFilterCollectionView.delegate?.collectionView?(newsFilterCollectionView, didSelectItemAt: firstIndexPath)
    }
    
    private func startActivityIndicator() {
        activityIndicator.startAnimating()
        tableView.isHidden = true
    }
    
    private func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        tableView.isHidden = false
    }
    
    private func loadImage(urlString: String?, into imageView: UIImageView, indexPath: IndexPath ) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            // Load default image from assets
            imageView.image = UIImage(named: "imageDefault")
            return
        }

        imageView.loadImage(at: url) { [weak self] data in
            if let data = data {
                self?.viewModel.setImageData(data: data, index: indexPath.row)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension NewsHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
        switch sectionType {
        case .horizontal:
            return 1
        case .vertical:
            return viewModel.getNews().count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SectionType.allCases[indexPath.section]

        if section == .horizontal {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalTableViewCell.identifier, for: indexPath) as? HorizontalTableViewCell else {
                return UITableViewCell()
            }
            
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            return cell
        }
        let newsList = viewModel.getNews()
        let newsIndex = indexPath.row
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell, newsList.indices.contains(newsIndex) else {
            return UITableViewCell()
        }

        let newsItem = newsList[newsIndex]
        cell.configure(news: newsItem)
        loadImage(urlString: newsItem.urlToImage, into: cell.newsImageView, indexPath: indexPath)
        cell.onReuse = {
            cell.newsImageView.cancelImageLoad()
        }
        
         return cell
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = SectionType.allCases[indexPath.section]
        let horizontalTableViewCellHeight: CGFloat = 300
        let verticalTableViewCellHeight: CGFloat = 110
        
        switch section {
            case .horizontal:
                return horizontalTableViewCellHeight
            case .vertical:
                return verticalTableViewCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = SectionType.allCases[indexPath.section]

        if section == .horizontal {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        }
//        let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section) - 1
//        if indexPath.row == lastRowIndex {
//            Task {
//                await viewModel.fetchNews(type: viewModel.selectedNewsType)
//                DispatchQueue.main.async {
//                    tableView.reloadData()
//                }
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let section = SectionType.allCases[section]

        let labelText = section == .horizontal ? "Main News" : "All News"
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = headerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerView.addSubview(blurEffectView)
        
        let label = UILabel()
        label.text = labelText
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: headerView.leadingAnchor, constant: 10),
        ])
        
        return headerView
    }
}

// MARK: - UITableViewDelegate
extension NewsHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section =  SectionType.allCases[indexPath.section]
        let newsIndex = indexPath.row
        let newsList = viewModel.getNews()
        guard section == .vertical, newsList.indices.contains(newsIndex) else { return }
        let selectedNews = newsList[newsIndex]
        coordinator?.showNewsDetail(news: selectedNews)
    }
}

extension NewsHomeViewController: NewsFilterUICollectionViewProtocol {
    func didSelectedFilter(newsType: NewsType) {
        viewModel.selectedNewsType = newsType
        tableView.reloadData()
    }
}

extension NewsHomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNews().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newsList = viewModel.getNews()
        let newsIndex = indexPath.item
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCardUICollectionViewCell.identifier, for: indexPath) as? NewsCardUICollectionViewCell, newsList.indices.contains(newsIndex) else {
            return UICollectionViewCell()
        }
        let newsItem = newsList[newsIndex]
        cell.configureCell(news: newsItem)
        
        loadImage(urlString: newsItem.urlToImage, into: cell.newsImageView, indexPath: indexPath)
        cell.onReuse = {
            cell.newsImageView.cancelImageLoad()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newsList = viewModel.getNews()
        guard newsList.indices.contains(indexPath.item) else { return }
        let news = newsList[indexPath.item]
        coordinator?.showNewsDetail(news: news)
    }
}

extension NewsHomeViewController: NewsObserver {
    func newsDidUpdate() {
        DispatchQueue.main.async {
             self.tableView.reloadData()
         }
    }
}
