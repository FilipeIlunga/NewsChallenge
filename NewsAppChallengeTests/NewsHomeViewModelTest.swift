//
//  NewsHomeViewModelTest.swift
//  NewsAppChallengeTests
//
//  Created by Filipe Ilunga on 21/05/24.
//

import XCTest
@testable import NewsAppChallenge

final class MockNewsService: NewsServiceProtocol {
    var requestCalledCount = 0
    var requestUrl: URL?

    func request(url: URL, completion: @escaping (NetworkResult) -> Void) {
        requestCalledCount += 1
        requestUrl = url
    }
}

final class MockNewsObserver: NewsObserver {
    var newsDidUpdateCalled = false

    func newsDidUpdate() {
        newsDidUpdateCalled = true
    }
}

final class NewsHomeViewModelTest: XCTestCase {
    
    var viewModel: NewsHomeViewModel!
    var mockNewsService: MockNewsService!
    var mockNewsObserver: MockNewsObserver!
    
    override func setUp() {
        super.setUp()
        mockNewsService = MockNewsService()
        mockNewsObserver = MockNewsObserver()
        viewModel = NewsHomeViewModel(newsService: mockNewsService)
    }
    
    func testFetchAllNews() {
        let allNewsType = NewsType.allCases.count
        viewModel.fetchAllNews()
        XCTAssertEqual(mockNewsService.requestCalledCount, allNewsType)
    }
    
    func testFetchNews() {
        viewModel.fetchNews(type: .apple)
        XCTAssertEqual(mockNewsService.requestCalledCount, 1)
        XCTAssertEqual(mockNewsService.requestUrl, NewsType.apple.url())
    }
    
    func testFetchImage() {
        let url = "https://example.com/image.jpg"
        viewModel.fetchImage(url: url) { _ in }
        XCTAssertEqual(mockNewsService.requestCalledCount, 1)
        XCTAssertEqual(mockNewsService.requestUrl, URL(string: url))
    }
    
    func testAddObserver() {
        viewModel.addObserver(mockNewsObserver)
        XCTAssertNotNil(viewModel.observer)
    }
    
}

