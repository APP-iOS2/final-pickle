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
    
    // MARK: Old version
    static func register<Dependency>(type: Dependency.Type,
                                     _ factory: @autoclosure @escaping () -> Dependency) {
        factories[String(describing: type.self)] = factory
    }
    
    // MARK: New One using injectionKey
    static func register<T: InjectionKey>(_ name: T.Type,
                                          _ factory: @autoclosure @escaping () -> Dependency) {
        factories[String(describing: name.self)] = factory
    }
    
    //    static func resolve<T>(for type: Any.Type?) -> T {
    //        let name = type.map { String(describing: $0) } ?? String(describing: T.self)
    //
    //        guard let component: T = .modules[name]?.resolve() as? T else {
    //            fatalError("Dependency '\(T.self)' not resolved!")
    //        }
    //
    //        return component
    //    }
    
    static func resolve<Dependency>(_ resolveType: DependencyType = .automatic,
                                    _ type: Any.Type?) -> Dependency {
        let serviceName = type.map { String(describing: $0) } ?? String(describing: Dependency.self)
        
        switch resolveType {
        case .singleton:
            if let service = cache[serviceName] as? Dependency {
                return service
            } else {
                let service = factories[serviceName]?() as? Dependency
                if let service = service {
                    cache[serviceName] = service
                    return service
                }
            }
            assert(false, "fattalError singleton Occur")
        case .newSingleton:
            let service = factories[serviceName]?() as? Dependency
            if let service = service {
                cache[serviceName] = service
                return service
            }
            assert(false, "fattalError singleton Occur")
        case .automatic:
            fallthrough
        case .new:
            if let dependency = factories[serviceName]?() as? Dependency {
                return dependency
            }
            assert(false, "fattalError singleton Occur")
        }
    }
}
