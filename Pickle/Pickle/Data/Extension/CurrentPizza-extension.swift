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

extension CurrentPizza: Equatable {
    static func == (lhs: CurrentPizza, rhs: CurrentPizza) -> Bool {
        lhs.id == rhs.id &&
        lhs.pizza == rhs.pizza &&
        lhs.currentPizzaSlice == rhs.currentPizzaSlice &&
        lhs.currentPizzaCount == rhs.currentPizzaCount &&
        lhs.createdAt == rhs.createdAt
    }
    
    /// 피자 조각을 추가하고 , 8조각 이상일시 슬라이스를 0으로 만들고 피자카운트를 (1 = defaut) 증가 시키는 메서드
    /// - Parameter count: 피자 조각갯수
    mutating func addPizzaSliceValidation(count: Int = 1) -> Self {
        // TODO: 변경 필요 Pizza adding logic
        currentPizzaSlice += count
        if currentPizzaSlice >= 8 {
            currentPizzaSlice = 0
            currentPizzaCount += 1
        }
        return self
    }
    
    /// 피자 한개의 잠금해제 메소드
    /// - Parameter pizza: 잠금 해제할 피자
    mutating func unlockPizza(pizza: Pizza) {
        // TODO: 변경 필요 Pizza Unlock 로직
        var pizza = pizza
        pizza.lockToggle()
        self.pizza = pizza
    }
}
