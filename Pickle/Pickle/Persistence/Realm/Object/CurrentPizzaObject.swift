//
//  CurrentPizzaObject.swift
//  Pickle
//
//  Created by 박형환 on 11/13/23.
//

import Foundation
import RealmSwift

class CurrentPizzaObject: Object, Identifiable {
    
    @Persisted var currentPizzaCount: Int
    @Persisted var currentPizzaSlice: Int
    @Persisted(originProperty: "currentPizzaList") var users: LinkingObjects<UserObject>
    @Persisted var pizza: PizzaObject?
    @Persisted var createdAt: Date
    
    convenience init(id: String,
                     currentPizzaCount: Int,
                     currentPizzaSlice: Int,
                     pizza: PizzaObject?,
                     createdAt: Date) {
        self.init()
        self.currentPizzaCount = currentPizzaCount
        self.currentPizzaSlice = currentPizzaSlice
        self.createdAt = createdAt
        self.pizza = pizza
        // self.users = LinkingObjects(fromType: UserObject.self, property: "currentPizzaList")
    }
}
