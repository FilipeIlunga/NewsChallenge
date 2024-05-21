//
//  NetworkServiceTest.swift
//  NewsAppChallengeTests
//
//  Created by Filipe Ilunga on 20/05/24.
//

import XCTest
@testable import NewsAppChallenge

final class NetworkServiceTest: XCTestCase {
    
    func testRequestAndCreateDataTaskWithUrl() {
        let url = URL(string: "https://newschallengeapp.com.br")!
        let session = URLSessionSpy()
        let sut = NetworkService(session: session)
        sut.request(url: url, type: News.self) { _ in }
        XCTAssertNotNil(session.urlRequest)
    }
    
}

final class URLSessionSpy: URLSession {
    private(set) var urlRequest: URL?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask {
        urlRequest = url
        return URLSessionDataTask()
    }
}
