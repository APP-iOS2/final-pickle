//
//  Migrator.swift
//  Pickle
//
//  Created by 박형환 on 9/27/23.
//

import Foundation
import RealmSwift
import Realm

// 데이터 마이그레이션
// let migrator = Migrator()
// 최상단 에서 마이그레이션 하면 될듯?

class RealmMigrator {
    
    init() {
        updateSchema()
    }
    
    // MARK: 마이그레이션 DOCUMENT 문서화 하기
    func updateSchema() {
        let config = Realm.Configuration(fileURL: URL.inDocumentsFolder("main.realm"), schemaVersion: 3) { migration, oldSchemaVersion in
            print("migration: \(migration)")
            print("oldSchemaVersion : \(oldSchemaVersion)")
            if oldSchemaVersion < 2 { migrationFromV1ToV2(migration: migration) }
            if oldSchemaVersion < 3 { migrationFromV2ToV3(migration: migration) }
        }
        
        func migrationFromV1ToV2(migration: Migration) {
            migration.enumerateObjects(ofType: UserObject.className()) { oldObject, newObject in
                guard let oldObject = oldObject else { return }
                let userObjectPizzaList = newObject?.dynamicList("pizza")
                
                migration.enumerateObjects(ofType: PizzaObject.className()) { pizzaObject, newPizzaObject in
                    guard let object = pizzaObject else { return }
                    if let newPizzaObject {
                        userObjectPizzaList?.append(newPizzaObject)
                    }
                }
            }
        }
        
        func migrationFromV2ToV3(migration: Migration) {
            migration.enumerateObjects(ofType: TimeMissionObject.className(), { oldObject, newObject in
                guard let oldObject else { return }
                newObject!["changeWakeupTime"] = Date()
            })
        }
        Realm.Configuration.defaultConfiguration = RealmProvider(config: config).configuration
    }
    
}

struct RealmProvider {
    
    let configuration: Realm.Configuration
    
    init(config: Realm.Configuration) {
        configuration = config
    }
    
    var _realm: Realm? {
        return try? Realm(configuration: configuration)
    }
    
    static var defaultRealm: Realm {
        try! Realm()
    }
    
    var realm: Realm? {
        do {
            return try Realm(configuration: configuration)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private static let defaultConfig = Realm.Configuration(schemaVersion: 1)
    
    static var previewRealm: Realm {
        let identifier = "preview.realm"
        let config = Realm.Configuration(inMemoryIdentifier: identifier)
        return RealmProvider(config: config).realm!
    }
           
    private static let mainConfig = Realm.Configuration(
        fileURL: URL.inDocumentsFolder("main.realm"),
        schemaVersion: 1)
    
    static var `default`: Realm? = {
        return RealmProvider(config: RealmProvider.defaultConfig).realm
    }()
    
    static var main: Realm? = {
        return RealmProvider(config: RealmProvider.mainConfig).realm
    }()
}
