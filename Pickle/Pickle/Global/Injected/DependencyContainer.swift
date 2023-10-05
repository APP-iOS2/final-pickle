//
//  ServiceContainer.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import Foundation

struct DependencyContainer {
    
    private static var factories: [String: () -> Any] = [:]
    private static var cache: [String: Any] = [:]
    
    static func register<Dependency>(type: Dependency.Type,
                                     _ factory: @autoclosure @escaping () -> Dependency) {
        factories[String(describing: type.self)] = factory
    }
    
    static func resolve<Dependency>(_ resolveType: DependencyType = .automatic,
                                    _ type: Dependency.Type) -> Dependency? {
        let serviceName = String(describing: type.self)
        
        switch resolveType {
        case .singleton:
            if let service = cache[serviceName] as? Dependency {
                return service
            } else {
                let service = factories[serviceName]?() as? Dependency
                if let service = service {
                    cache[serviceName] = service
                }
                return service
            }
        case .newSingleton:
            let service = factories[serviceName]?() as? Dependency
            if let service = service {
                cache[serviceName] = service
            }
            return service
        case .automatic:
            fallthrough
        case .new:
            return factories[serviceName]?() as? Dependency
        }
    }
}
