//
//  PizzaObject.swift
//  Pickle
//
//  Created by 박형환 on 10/17/23.
//

import SwiftUI
import RealmSwift

class PizzaObject: EmbeddedObject, Identifiable {
    @Persisted var id: String
    @Persisted var name: String
    @Persisted var image: String
    @Persisted var lock: Bool
    @Persisted var createdAt: Date  // 피자 생성 날짜
    
    convenience init(id: String,
                     name: String,
                     image: String,
                     lock: Bool,
                     createdAt: Date) {
        self.init()
        self.id = id
        self.name = name
        self.image = image
        self.lock = lock
        self.createdAt = createdAt
    }
}

extension PizzaObject {
    static let pizza = PizzaObject(id: UUID().uuidString,
                                   name: "포테이토",
                                   image: "potatoPizza",
                                   lock: false,
                                   createdAt: Date())
}
