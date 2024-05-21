//
//  NewsHomeViewModel.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//
import UIKit

protocol NewsObserver: AnyObject {
    func onStarNewstUpdating()
    func newsDidUpdate()
    func onEndNewsUpdate()
}

protocol ErrorHandlerDelegate: AnyObject {
    func showErrorMessage(error: any Error)
}

final class NewsHomeViewModel {
    
    private(set) weak var observer: NewsObserver? = nil
    weak var errorHandlerDelegate: ErrorHandlerDelegate?
    @Atomic private(set) var news: [NewsType: [News]] = [:]
    private var currentPage: [NewsType: Int] = [:]
    var selectedNewsType: NewsType = .apple

    let newsService: NewsServiceProtocol

    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
        NewsType.allCases.forEach { currentPage[$0] = 100 }
    }
    
    func fetchAllNews()  {
        for type in NewsType.allCases {
            fetchNews(type: type)
        }
    }
    
    func fetchNews(type: NewsType)  {
        guard let page = currentPage[type],  let url = type.url(page: page) else {
            let error = NewsServiceError.badURL
            errorHandlerDelegate?.showErrorMessage(error: error)
            return
        }
        observer?.onStarNewstUpdating()
        newsService.request(url: url) { result in
            switch result {
            case let .success((data, _)):
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
                        self.observer?.onEndNewsUpdate()
                    } catch {
                        self.errorHandlerDelegate?.showErrorMessage(error: error)
                        self.observer?.onEndNewsUpdate()
                    }
                }
            case .failure(let error):
                self.errorHandlerDelegate?.showErrorMessage(error: error)
                self.observer?.onEndNewsUpdate()
            }
        }
    }
    
    func fetchImage(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        newsService.request(url: url) { result in
            switch result {
            case let .success((data, _)):
                completion(.success(data))
            case let .failure(error):
                self.errorHandlerDelegate?.showErrorMessage(error: error)
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
