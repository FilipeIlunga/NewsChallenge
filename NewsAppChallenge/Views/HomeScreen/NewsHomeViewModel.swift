//
//  NewsHomeViewModel.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//
import UIKit

protocol NewsObserver: AnyObject {
    func newsDidUpdate()
}

final class NewsHomeViewModel {
    
    private(set) weak var observer: NewsObserver? = nil
    @Atomic private(set) var news: [NewsType: [News]] = [:]
    private var currentPage: [NewsType: Int] = [:]
    var selectedNewsType: NewsType = .apple
    var onUpdate: (() -> Void)?

    let newsService: NewsServiceProtocol

    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
        NewsType.allCases.forEach { currentPage[$0] = 20 }
    }
    
    func fetchAllNews()  {
        for type in NewsType.allCases {
            fetchNews(type: type)
        }
    }
    
    func fetchNews(type: NewsType)  {
        guard let page = currentPage[type], let url = type.url(page: page) else { return }
        
        newsService.request(url: url) { result in
            switch result {
            case let .success((data, response)):
                DispatchQueue.main.async {
                    let decoder: JSONDecoder = JSONDecoder()
                    do {
                        let result: NewsDataResponse = try decoder.decode(NewsDataResponse.self, from: data)
                        if let currentNews = self.news[type] {
                            self.news[type] = currentNews + result.articles
                        } else {
                            self.news[type] = result.articles
                        }
                        self.currentPage[type] = page + 1
                        self.observer?.newsDidUpdate()
                    } catch let error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
                break
            case .failure(let error):
                print("error on: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchImage(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        newsService.request(url: url) { result in
            switch result {
            case let .success((data, response)):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func setImageData(data: Data, index: Int) {
        news[selectedNewsType]?[index].imageData = data
    }
    
    func getNews() -> [News] {
        return news[selectedNewsType] ?? []
    }
    
    func addObserver(_ observer: NewsObserver) {
        self.observer = observer
    }
}
