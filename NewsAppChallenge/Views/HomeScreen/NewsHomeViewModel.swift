//
//  NewsHomeViewModel.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

enum SectionType: Int, CaseIterable {
    case horizontal = 0
    case vertical = 1
}


import Foundation
import UIKit

final class NewsHomeViewModel {
    
    @Atomic private var news: [NewsType: [News]] = [:]
    private var currentPage: [NewsType: Int] = [:]
    var selectedNewsType: NewsType = .apple
    
    let newsService: NewsServiceProtocol

    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
        NewsType.allCases.forEach { currentPage[$0] = 10 }
    }
    
    func fetchAllNews() async {
        for type in NewsType.allCases {
            await fetchNews(type: type)
        }
    }
    
    func fetchNews(type: NewsType) async {
        guard let page = currentPage[type] else { return }
        
        do {
            let result: NewsDataResponse = try await newsService.fetchNews(type: type, page: page)
            if let currentNews = news[type] {
                news[type] = currentNews + result.articles
            } else {
                news[type] = result.articles
            }
            currentPage[type] = page + 1
        } catch {
            print("Error on \(#function) for \(type): \(error.localizedDescription)")
        }
    }
    
    func fetchImage(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        newsService.fetchImage(url: url) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getNews() -> [News] {
        return news[selectedNewsType] ?? []
    }
    
    func getNewsTypes() -> [NewsType] {
        return NewsType.allCases
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return getNews().count
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
        switch sectionType {
        case .horizontal:
            return 1
        case .vertical:
            return getNews().count
        }
    }
}
