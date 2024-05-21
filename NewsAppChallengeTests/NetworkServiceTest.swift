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
        sut.request(url: url) { _ in }

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
        
        sut.request(url: url) { result in
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
    
    func testLoadRequestResumeDataTaskWithSucess() {
        let url = URL(string: "https://newschallengeapp.com.br")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        let sut = NetworkService(session: session)
        let anyError = NSError(domain: "any error", code: -1)
        
        let data = Data()
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.stubs(url: url, task: task, data: data, response: response)
        
        let exp = expectation(description: "Aguardando retorno da closure")
        
        var returnedResult : NewsServiceProtocol.NetworkResult?
        
        sut.request(url: url) { result in
            switch result {
            case let .success(returnedData, returnedResponse):
                XCTAssertEqual(returnedData, data)
                XCTAssertEqual(returnedResponse, response)
            default:
                XCTFail("Esperado sucesso, porem retornou \(result)")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
    
}
