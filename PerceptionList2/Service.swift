//
//  Service.swift
//  PerceptionList2
//
//  Created by Stefan O'Shea on 21/2/2024.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
struct Service {
    var fetchObjects: (String) async throws -> [Object]
    
    init(fetchObjects: @escaping (String) -> [Object]) {
        self.fetchObjects = fetchObjects
    }
}

extension Service: TestDependencyKey {
    static var testValue: Service = Service()
}

extension DependencyValues {
    enum ServiceDependencyKey: DependencyKey {
        static let liveValue = Service()
    }
    
    var service: Service {
        get { self[Service.self] }
        set { self[Service.self] = newValue }
    }
}

struct Object {
    let name: String
    let number: Int
}

struct SomeNetworkClient {}

extension Service {
    init(client: SomeNetworkClient) {
        self.init { request in
            
            guard !Thread.isMainThread else {
                // Not in the real app - just to demo we aren't sleeping the main thread here
                fatalError()
            }
            
            // Simulate Network call
            Thread.sleep(forTimeInterval: 1)
            
            // Real app has network client do this
            
            return [
                Object(name: "Section 1", number: 1),
                Object(name: "Section 1", number: 1),
                Object(name: "Section 1", number: 1),
                Object(name: "Section 1", number: 1),
                Object(name: "Section 2", number: 2),
                Object(name: "Section 2", number: 2),
                Object(name: "Section 2", number: 2),
                Object(name: "Section 2", number: 2),
                Object(name: "Section 2", number: 2),
                Object(name: "Section 3", number: 3),
                Object(name: "Section 3", number: 3),
                Object(name: "Section 3", number: 3),
                Object(name: "Section 3", number: 3),
                Object(name: "Section 3", number: 3),
                Object(name: "Section 3", number: 3),
                Object(name: "Section 3", number: 3)
            ]
        }
    }
}
