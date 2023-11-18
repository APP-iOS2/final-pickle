//
//  CurrentPizza-extension.swift
//  Pickle
//
//  Created by 박형환 on 11/14/23.
//

import Foundation

extension CurrentPizza: MappableProtocol {
    typealias PersistenceType = CurrentPizzaObject
    
    func mapToPersistenceObject() -> CurrentPizzaObject {
        CurrentPizzaObject(id: self.id,
                           currentPizzaCount: self.currentPizzaCount,
                           currentPizzaSlice: self.currentPizzaSlice,
                           pizza: self.pizza?.mapToPersistenceObject() ?? nil,
                           createdAt: self.createdAt)
    }
    
    static func mapFromPersistenceObject(_ object: CurrentPizzaObject) -> CurrentPizza {
        var pizza = Pizza.defaultPizza
        if let _pizza = object.pizza {
            pizza = Pizza.mapFromPersistenceObject(_pizza)
        }
        return CurrentPizza(currentPizzaCount: object.currentPizzaCount,
                            currentPizzaSlice: object.currentPizzaSlice,
                            pizza: pizza,
                            createdAt: object.createdAt)
    }
}
