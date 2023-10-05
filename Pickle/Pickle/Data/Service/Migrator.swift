//
//  Migrator.swift
//  Pickle
//
//  Created by 박형환 on 9/27/23.
//

import Foundation
import RealmSwift

// 데이터 마이그레이션
// let migrator = Migrator()
// 최상단 에서 마이그레이션 하면 될듯?
private class Migrator {
    
    init() {
        updateSchema()
    }
    
    func updateSchema() {
        //1 -> 2
        let config = Realm.Configuration(schemaVersion: 1) { migration ,oldSchemaVersion in
            
            //        Migration Behavior
            //            if oldSchemaVersion < 1 {
            //                migration.enumerateObjects(ofType: ShoppingList.className())
            //                { _, newObject in
            //                    newObject!["items"] = List<ShopingItem>()
            //                }
            //            }
            //
            //            if oldSchemaVersion < 2 {
            //
            //                migration.enumerateObjects(ofType: ShoppingItem.className())
            //                { _ , newObject in
            //                    newObject!["category"] = ""
            //                }
            //            }
        }
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }
}

