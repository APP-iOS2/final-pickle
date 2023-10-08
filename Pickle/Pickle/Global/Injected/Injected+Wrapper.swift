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
    
    // MARK: Before
    //    init(_ type: DependencyType = .automatic) {
    //        guard let service: Dependency = DependencyContainer.resolve(type, Dependency.self) else {
    //            let serviceName = String(describing: Dependency.self)
    //            fatalError("No service of type \(serviceName) registered!")
    //        }
    //        self.service = service
    //    }
    
    // MARK: After
    init<T>(_ key: T.Type, _ type: DependencyType = .automatic) where T: InjectionKey, Dependency == T.Value {
        let service: Dependency = key.currentValue
        //        guard let service: Dependency = DependencyContainer.resolve(type, key.self) else {
        //            let serviceName = String(describing: Dependency.self)
        //            fatalError("No service of type \(serviceName) registered!")
        //        }
        self.service = service
    }
    
    var wrappedValue: Dependency {
        get { self.service }
        mutating set { service = newValue }
    }
}
