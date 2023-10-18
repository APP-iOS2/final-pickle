//
//  Injection+Key.swift
//  Pickle
//
//  Created by 박형환 on 10/7/23.
//

import Foundation

protocol InjectionKey {
    associatedtype Value
    static var currentValue: Self.Value { get }
    static var type: DependencyType { get }
}

extension InjectionKey {
    static var currentValue: Value {
        return DependencyContainer.resolve(type, Self.self)
    }
}

struct TodoRepoKey: InjectionKey {
    typealias Value = TodoRepositoryProtocol
    static var type: DependencyType = .automatic
}

struct DBStoreKey: InjectionKey {
    typealias Value = DBStore
    static var type: DependencyType = .singleton
}

struct TimeRepoKey: InjectionKey {
    typealias Value = TimeRepositoryProtocol
    static var type: DependencyType = .automatic
}

struct BehaviorRepoKey: InjectionKey {
    typealias Value = BehaviorRepositoryProtocol
    static var type: DependencyType = .automatic
}

struct UserRepoKey: InjectionKey {
    typealias Value = UserRepositoryProtocol
    static var type: DependencyType = .singleton
}

struct PizzaRepoKey: InjectionKey {
    typealias Value = PizzaRepositoryProtocol
    static var type: DependencyType = .singleton
}
