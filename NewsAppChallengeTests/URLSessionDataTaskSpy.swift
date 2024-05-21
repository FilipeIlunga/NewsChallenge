//
//  URLSessionDataTaskSpy.swift
//  NewsAppChallengeTests
//
//  Created by Filipe Ilunga on 21/05/24.
//

import Foundation

final class URLSessionDataTaskSpy: URLSessionDataTask {
    private(set) var resumeCount = 0
    override func resume() {
        resumeCount += 1
    }
}

final class FakeURLSessionDataTask: URLSessionDataTask {
    override func resume() {}
}

