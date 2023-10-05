//
//  DBStore.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import Foundation

protocol Storable {}

protocol DBStore {
    func create<T: Storable>(_ model: T.Type, completion: @escaping (T) -> Void) throws
    func save(object: Storable) throws
    func update(object: Storable) throws
    func delete(object: Storable) throws
    func deleteAll<T: Storable>(_ model: T.Type) throws
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, complection: ([T]) -> Void) throws
}

protocol MappableProtocol {
    associatedtype PersistenceType: Storable
    func mapToPersistenceObject() -> PersistenceType
    static func mapFromPersistenceObject(_ object: PersistenceType) -> Self
}
