//
//  RealmStore.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import SwiftUI
import RealmSwift
import Combine
import Realm

extension KeyPath {
    var propertyAsString: String {
        print("\(self)")
        return "\(self)".components(separatedBy: ".").last ?? ""
    }
    var keyPath: String {
           let me = String(describing: self)
           let dropLeading =  "\\" + String(describing: Root.self) + "."
           let keyPath = "\(me.dropFirst(dropLeading.count))"
           return keyPath
       }
    
    var stringValue: String {
           NSExpression(forKeyPath: self).keyPath
       }
}

typealias RealmFilter<Object> = (Query<Object>) -> Query<Bool>

enum RFilter<Object: Storable> {
    case filter(RealmFilter<Object>)
}

typealias RObjectBase = ObjectBase
typealias RObjectChange = ObjectChange
typealias ObjectCompletion<T> = (ObjectChange<T>) -> Void
typealias RNotificationToken = NotificationToken
final class RealmStore: DBStore {
    
    enum RealmType {
        case disk
        case inmemory
    }
    
    private var realmStore: Realm? {
        switch type {
        case .disk:
            return RealmProvider.defaultRealm
        case .inmemory:
            return RealmProvider.previewRealm
        }
    }
    
    private var type: RealmType
    
    init(type: RealmType = .disk) {
        self.type = type
    }
    
    static var previews: RealmStore = RealmStore(type: .inmemory)
    
    func create<T>(_ model: T.Type,
                   data: Data,
                   completion: @escaping (T) -> Void) throws where T: Storable {
        guard
            let realm = realmStore,
            let model = model as? Object.Type
        else {
            throw RealmError.notRealmObject
        }
        
        try realm.write {
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            let value = realm.create(model, value: json) as! T
            completion(value)
        }
    }
    
    func create<T>(_ model: T.Type, completion: @escaping (T) -> Void) throws where T: Storable {
        guard
            let realm = realmStore,
            let model = model as? Object.Type
        else {
            throw RealmError.notRealmObject
        }
        
        try realm.write {
            let type = realm.create(model, value: []) as! T
            completion(type)
        }
    }
    
    func save(object: Storable) throws {
        guard
            let realm = realmStore,
            let object = object as? Object
        else {
            throw RealmError.notRealmObject
        }
        
        try realm.write {
            realm.add(object)
        }
    }
    
    func update(object: Storable) throws {
        guard
            let realm = realmStore,
            let object = object as? Object
        else {
            throw RealmError.notRealmObject
        }
        
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
        guard
            let realm = realmStore,
        else {
            throw RealmError.notRealmObject
        }
        
        try realm.write {
        }
    }
    
    func delete(object: Storable) throws {
        return
    }
    /// Delete Model 메타타입 과 id를 받아서 delete할 오브젝트를 골라 삭제한다.
    /// - Parameters:
    ///   - model: 삭제할 모델의 메타타입
    ///   - id: Primary id
    func delete<T>(model: T.Type, id: String) throws {
        guard
            let realm = realmStore,
            let model = model as? Object.Type,
            let objectID = try? ObjectId(string: id)
        else {
            throw RealmError.notRealmObject
        }
        try realm.write {
            if let value = realm.object(ofType: model, forPrimaryKey: objectID) {
                realm.delete(value)
            } else {
                throw RealmError.deleteFailed
            }
        }
    }
    
    func deleteAll<T>(_ model: T.Type) throws where T: Storable {
        guard
            let realm = realmStore,
            let model = model as? Object.Type
        else {
            throw RealmError.notRealmObject
        }
        try realm.write {
            let objects = realm.objects(model)
            for object in objects {
                realm.delete(object)
            }
        }
    }
    
    func fetch<T>(_ model: T.Type,
                  predicate: NSPredicate?,
                  sorted: Sorted?) throws -> [T] where T: Storable {
        guard
            let realm = realmStore,
            let model = model as? Object.Type
        else {
            throw RealmError.notRealmObject
        }
        
        var objects = realm.objects(model)
        
        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        
        if let sorted {
            objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }
        return objects.compactMap { $0 as? T }
    }
    
    func notificationToken<T>(_ model: T.Type,
                              id: String,
                              keyPaths: [PartialKeyPath<T>],
                              _ completion: @escaping ObjectCompletion<T>) throws -> NotificationToken where T: Storable, T: ObjectBase  {
        guard
            let realm = realmStore,
            let model = model as? Object.Type,
            let id =  try? ObjectId(string: id)
        else {
            Log.error("notification Token guard error")
            throw RealmError.notRealmObject
        }
        let object = realm.object(ofType: model, forPrimaryKey: id)
        guard let object else { throw RealmError.invalidObjectORPrimaryKey }
        return object.observe(keyPaths: keyPaths, completion)
    }
    
    func fetch<T>(_ model: T.Type,
                  predicate: NSPredicate?,
                  sorted: Sorted?,
                  complection: ([T]) -> Void) throws where T: Storable {
        guard
            let realm = realmStore,
            let model = model as? Object.Type
        else {
            throw RealmError.notRealmObject
        }
        
        var objects = realm.objects(model)
        
        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        
        if let sorted {
            objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }
        complection(objects.compactMap { $0 as? T })
    }
}

extension RealmStore: Dependency {}

struct Sorted {
    var key: String
    var ascending: Bool = true
}
extension Sorted {
    static var missionAscending: Self {
        Sorted(key: "date", ascending: true)
    }
    
    static var missionDscending: Self {
        Sorted(key: "date", ascending: false)
    }
    
    static var createdAscending: Self {
        Sorted(key: "createdAt", ascending: true)
    }
}

