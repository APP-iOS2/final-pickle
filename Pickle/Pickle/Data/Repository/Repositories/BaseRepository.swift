//
//  BaseRepository.swift
//  Pickle
//
//  Created by 박형환 on 10/4/23.
//

import Foundation
import RealmSwift

class BaseRepository<T> {
    
    @Injected(DBStoreKey.self) var dbStore: DBStore
    
    func fetch(_ model: T.Type,
               predicate: NSPredicate?,
               sorted: Sorted?) throws -> [T] where T: Storable {
        do {
            return try dbStore.fetch(model,
                                     predicate: predicate,
                                     sorted: sorted)
        } catch {
            throw error
        }
    }
    
    func fetch(_ model: T.Type,
               predicate: NSPredicate?,
               sorted: Sorted,
               completion: ([T]) -> Void) where T: Storable {
        do {
            try dbStore.fetch(model,
                              predicate: predicate,
                              sorted: sorted,
                              complection: completion)
        } catch {
            return
        }
    }
    
    func deleteAll(_ model: T.Type) throws where T: Storable {
        try dbStore.deleteAll(model)
    }
    
    func delete(object: T, id: String) throws where T: Storable {
        try dbStore.delete(model: T.self, id: id)
    }
    
    func update(object: T) throws where T: Storable {
        try dbStore.update(object: object)
    }
    
    func save(object: T) throws where T: Storable {
        try dbStore.save(object: object)
    }
    
    func create(_ model: T.Type,
                item: T,
                completion: @escaping (T) -> Void) throws where T: Storable {
        try dbStore.create(model, item: item, completion: completion)
    }
    
    func create(_ model: T.Type,
                data: Data,
                completion: @escaping (T) -> Void) throws where T: Storable {
        try dbStore.create(model, data: data, completion: completion)
    }
}
