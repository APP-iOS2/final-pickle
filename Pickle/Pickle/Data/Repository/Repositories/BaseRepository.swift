//
//  BaseRepository.swift
//  Pickle
//
//  Created by 박형환 on 10/4/23.
//

import Foundation
import RealmSwift

class BaseRepository<T> {
    
    // MARK: Before
    //    private var dbStore: DBStore
    //    required init(dbStore: DBStore) {
    //        self.dbStore = dbStore
    //    }
    
    //    required init(dbStore: DBStore = FireBaseStore()) {
    //        self.dbStore = dbStore
    //    }
    
    // MARK: After
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
        Log.debug("dbStore: \(dbStore)")
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
    
//    func delete(object: T) throws where T: Storable {
//        try dbStore.delete(object: object)
//    }
    func delete(object: T) throws where T: Storable {
        try dbStore.delete(object: object)
    }
    
    func delete(object: T, id: String) throws where T: Storable {
        try dbStore.delete(model: T.self, id: id)
    }
    
    func update(object: T) throws where T: Storable {
        try dbStore.update(object: object)
    }
    
    func update(id: String, query: RealmFilter<T>) throws where T: Storable {
        try dbStore.update(T.self, id: id, query: query)
    }
    
    func save(object: T) throws where T: Storable {
        try dbStore.save(object: object)
    }
    
    func create(_ model: T.Type,
                completion: @escaping (T) -> Void) throws where T: Storable {
        try dbStore.create(model, completion: completion)
    }
    
    func create(_ model: T.Type,
                data: Data,
                completion: @escaping (T) -> Void) throws where T: Storable {
        try dbStore.create(model, data: data, completion: completion)
    }
}
