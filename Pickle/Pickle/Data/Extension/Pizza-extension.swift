//
//  Pizza-extension.swift
//  Pickle
//
//  Created by 박형환 on 10/18/23.
//

import Foundation

/*
 - 포인트
 - 통계
 */
extension Pizza: MappableProtocol {
    typealias PersistenceType = PizzaObject
    
    func mapToPersistenceObject() -> PersistenceType {
        PizzaObject(id: self.id,
                    name: self.name,
                    image: self.image,
                    lock: self.lock,
                    createdAt: self.createdAt)
    }
    
    static func mapFromPersistenceObject(_ object: PersistenceType) -> Self {
        Pizza(id: object.id,
              name: object.name,
              image: object.image,
              lock: object.lock,
              createdAt: object.createdAt)
    }
}
