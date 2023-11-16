//
//  User-extension.swift
//  Pickle
//
//  Created by 박형환 on 10/18/23.
//

import Foundation

extension User: MappableProtocol {
    typealias PersistenceType = UserObject
    
    func mapToPersistenceObject() -> PersistenceType {
        let list = self.currentPizzas.map { $0.mapToPersistenceObject() }
        return UserObject(id: self.id,
                          nickName: self.nickName,
                          currentPizzaCount: self.currentPizzaCount,
                          currentPizzaSlice: self.currentPizzaSlice,
                          currentPizzaID: self.pizzaID,
                          currentPizzaList: list,
                          createdAt: self.createdAt)
    }
    
    static func mapFromPersistenceObject(_ object: PersistenceType) -> Self {
        let list = object.currentPizzaList
        // 
        let pizzas = list.map { value in CurrentPizza.mapFromPersistenceObject(value) }
        return User(id: object.id,
                    nickName: object.nickName,
                    currentPizzaCount: object.currentPizzaCount,
                    currentPizzaSlice: object.currentPizzaSlice,
                    pizzaID: object.currentPizzaID,
                    currentPizzas: object.currentPizzaList.map { CurrentPizza.mapFromPersistenceObject($0) },
                    createdAt: object.createdAt)
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id &&
        lhs.nickName == rhs.nickName &&
        lhs.currentPizzaSlice == rhs.currentPizzaSlice &&
        lhs.currentPizzaCount == rhs.currentPizzaCount &&
        lhs.currentPizzas == rhs.currentPizzas &&
        lhs.pizzaID == rhs.pizzaID &&
        lhs.createdAt == rhs.createdAt 
    }
    
    mutating func update(current pizza: CurrentPizza) -> Self {
        let list = self.currentPizzas.map { return $0.id == pizza.id ? pizza : $0 }
        return try! self.update(path: \.currentPizzas, to: list)
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
        var currentPizza = self.currentPizzas.filter {
            if let id = $0.pizza?.id { return id == pizza.id }
            else { return false }
        }.first
    
        guard var currentPizza else { return }
        var pizza = pizza
        pizza.lockToggle()
        currentPizza.pizza = pizza
        
        self.currentPizzas = self.currentPizzas.map {
            return currentPizza.id == $0.id ? currentPizza : $0
        }
    }

    // MARK: 안쓰는 메서드 확인후 삭제바람
    func update(_ status: Status) -> Self {
        User(id: self.id,
             nickName: self.nickName,
             currentPizzaCount: self.currentPizzaSlice,
             currentPizzaSlice: self.currentPizzaSlice,
             currentPizzas: self.currentPizzas, 
             createdAt: self.createdAt)
    }
    
}
