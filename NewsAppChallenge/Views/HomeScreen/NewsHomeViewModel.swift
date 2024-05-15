//
//  NewsHomeViewModel.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

import Foundation

import Foundation

final class NewsHomeViewModel {
        
    private var news: [NewsType: [News]] = [:]
    private var currentPage: [NewsType: Int] = [:]
    
    let newsService: NewsServiceProtocol

    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
        NewsType.allCases.forEach { currentPage[$0] = 1 }
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
    
    func fetchAllNews() async {
        for type in NewsType.allCases {
            await fetchNews(type: type)
        }
    }
    
    func getNews(for type: NewsType) -> [News] {
        return news[type] ?? []
    }
    
    func getNewsTypes() -> [NewsType] {
        return NewsType.allCases
    }
}
