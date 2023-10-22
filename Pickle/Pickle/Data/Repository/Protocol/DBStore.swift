//
//  DBStore.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import Foundation

// MARK: DB나 persistence 저장소에 저장가능한 타입을 나타내는 Protocol
protocol Storable {}

// MARK: 프로퍼티 래퍼로 의존성 주입을 하기위한 Protocol,
// MARK: @Injected로 주입하기 위해서는 Dependency Protocol을 만족하도록 해야한다.
protocol Dependency {}

protocol DBStore: Dependency {
    func create<T: Storable>(_ model: T.Type, completion: @escaping (T) -> Void) throws
    
    func create<T: Storable>(_ model: T.Type, data: Data, completion: @escaping (T) -> Void) throws
    
    func save(object: Storable) throws
    func update(object: Storable) throws
    func delete(object: Storable) throws
    
    /// Update Realm Using filter
    /// - Parameters:
    ///   - model: <#model description#>
    ///   - id: <#id description#>
    ///   - query: <#query description#>
    func update<T: Storable>(_ model: T.Type, id: String, query: RealmFilter<T>) throws
    
    /// 특정 모델을 Delete 하는 함수 입니다.
    /// - Parameters:
    ///   - model: 삭제할 데이터의 타입
    ///   - id: 삭제할 데이터의 ID값
    func delete<T: Storable>(model: T.Type, id: String) throws
    
    func deleteAll<T: Storable>(_ model: T.Type) throws
    
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, complection: ([T]) -> Void) throws
    
    func fetch<T>(_ model: T.Type,
                  predicate: NSPredicate?,
                  sorted: Sorted?) throws -> [T] where T: Storable
    
    func notificationToken<T>(_ model: T.Type,
                              id: String,
                              keyPaths: [PartialKeyPath<T>],
                              _ completion: @escaping ObjectCompletion<T>) throws -> RNotificationToken where T: Storable, T: RObjectBase
    
}
