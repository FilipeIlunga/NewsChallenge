//
//  Atomic.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 17/05/24.
//

import Foundation

// Source: https://medium.com/@vujnovacluka89/swift-atomic-properties-effd7a73070
@propertyWrapper
final public class Atomic<Value> {
    private let queue = DispatchQueue(label: "com.ilunga.atomic", qos: .userInitiated)
    private var value: Value

    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    public var wrappedValue: Value {
        get {
            queue.sync { value }
        }
        set {
            queue.sync { value = newValue }
        }
    }

    public func mutate(_ mutation: (inout Value) -> Void) {
        return queue.sync { mutation(&value) }
    }
}
