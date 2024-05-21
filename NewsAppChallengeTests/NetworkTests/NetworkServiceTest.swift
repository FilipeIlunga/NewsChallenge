//
//  NetworkServiceTest.swift
//  NewsAppChallengeTests
//
//  Created by Filipe Ilunga on 20/05/24.
//

import XCTest
@testable import NewsAppChallenge

final class NetworkServiceTest: XCTestCase {
    var url: URL!
    var session: URLSessionSpy!
    var task: URLSessionDataTaskSpy!
    var sut: NetworkService!
    
    override func setUp() {
         super.setUp()
         url = URL(string: "https://newschallengeapp.com.br")!
         session = URLSessionSpy()
         task = URLSessionDataTaskSpy()
         sut = NetworkService(session: session)
     }
    
    func testLoadRequestResumeDataTaskWithUrl() {

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
        
        let data = Data()
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.stubs(url: url, task: task, data: data, response: response)
        
        let exp = expectation(description: "Aguardando retorno da closure")
                
        sut.request(url: url) { result in
            switch result {
            case let .success((returnedData, returnedResponse)):
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
