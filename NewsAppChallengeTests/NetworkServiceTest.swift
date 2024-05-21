//
//  NetworkServiceTest.swift
//  NewsAppChallengeTests
//
//  Created by Filipe Ilunga on 20/05/24.
//

import XCTest
@testable import NewsAppChallenge

final class NetworkServiceTest: XCTestCase {
    
    func testLoadRequestResumeDataTaskWithUrl() {
        let url = URL(string: "https://newschallengeapp.com.br")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        let sut = NetworkService(session: session)
        session.stubs(url: url, task: task)
        sut.request(url: url, type: News.self) { _ in }

        XCTAssertEqual(task.resumeCount, 1)
    }
    
    func testLoadRequestResumeDataTaskWithError() {
        let url = URL(string: "https://newschallengeapp.com.br")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        let sut = NetworkService(session: session)
        let anyError = NSError(domain: "any error", code: -1)
        session.stubs(url: url, task: task, error: anyError)
        
        let exp = expectation(description: "Aguardando retorno da closure")
        var returnedResult : NewsServiceProtocol.NetworkResult?
        
        sut.request(url: url, type: News.self) { result in
            switch result {
            case let .failure(returnedError):
                XCTAssertEqual(returnedError as NSError, anyError)
            default:
                XCTFail("Esperado falha, porem retornou \(result)")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
    
}

final class URLSessionSpy: URLSession {
    
    private(set) var stubs: [URL: Stubs] = [:]
    
    struct Stubs {
        var task: URLSessionDataTask
        var erro: Error?
        
    }
    
    func stubs(url: URL, task: URLSessionDataTask, error: Error? = nil) {
        stubs[url] = Stubs(task: task, erro: error)
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask {
        guard let stub = stubs[url] else {
            return FakeURLSessionDataTask()
        }
        
        completionHandler(nil, nil, stub.erro)
        
        return stub.task
    }
}

final class URLSessionDataTaskSpy: URLSessionDataTask {
    private(set) var resumeCount = 0
    override func resume() {
        resumeCount += 1
    }
}

final class FakeURLSessionDataTask: URLSessionDataTask {
    override func resume() {}
}
