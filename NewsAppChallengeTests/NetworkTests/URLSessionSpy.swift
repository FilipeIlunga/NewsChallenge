//
//  URLSessionSpy.swift
//  NewsAppChallengeTests
//
//  Created by Filipe Ilunga on 21/05/24.
//

import Foundation

final class URLSessionSpy: URLSession {
    
    private(set) var stubs: [URL: Stubs] = [:]
    
    struct Stubs {
        var task: URLSessionDataTask
        var error: Error?
        let data: Data?
        let response: HTTPURLResponse?
        
    }
    
    func stubs(url: URL, task: URLSessionDataTask, error: Error? = nil, data: Data? = nil, response: HTTPURLResponse? = nil) {
        stubs[url] = Stubs(task: task, error: error, data: data, response: response)
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask {
        guard let stub = stubs[url] else {
            return FakeURLSessionDataTask()
        }
        
        completionHandler(stub.data, stub.response, stub.error)
        
        return stub.task
    }
}
