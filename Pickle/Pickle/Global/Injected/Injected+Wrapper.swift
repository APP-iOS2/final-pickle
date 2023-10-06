//
//  Service-PropertyWrapper.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import Foundation

@propertyWrapper
struct Injected<Dependency> {

    var service: Dependency

    init(_ type: DependencyType = .automatic) {
        guard let service: Dependency = DependencyContainer.resolve(type, Dependency.self) else {
            let serviceName = String(describing: Dependency.self)
            fatalError("No service of type \(serviceName) registered!")
        }
        self.service = service
    }

    var wrappedValue: Dependency {
        get { self.service }
        mutating set { service = newValue }
    }
}
