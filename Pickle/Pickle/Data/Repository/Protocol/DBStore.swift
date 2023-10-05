//
//  DBStore.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import Foundation


//MARK: DB나 persistence 저장소에 저장가능한 타입을 나타내는 Protocol
protocol Storable {}

//MARK: 프로퍼티 래퍼로 의존성 주입을 하기위한 Protocol,
//MARK: @Injected로 주입하기 위해서는 Dependency Protocol을 만족하도록 해야한다.
protocol Dependency {}

protocol DBStore: Dependency {
    func create<T: Storable>(_ model: T.Type, completion: @escaping (T) -> Void) throws
    func save(object: Storable) throws
    func update(object: Storable) throws
    func delete(object: Storable) throws
    func deleteAll<T: Storable>(_ model: T.Type) throws
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, complection: ([T]) -> Void) throws
}
