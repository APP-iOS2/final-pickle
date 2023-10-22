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
        
        let value = self.pizzas.map { $0.mapToPersistenceObject() }
        
        if let _ = UUID(uuidString: self.id) {
            return UserObject(nickName: self.nickName,
                              currentPizzaCount: self.currentPizzaCount,
                              currentPizzaSlice: self.currentPizzaSlice,
                              pizzaList: value,
                              createdAt: self.createdAt)
        } else {
            return UserObject(id: self.id,
                              nickName: self.nickName,
                              currentPizzaCount: self.currentPizzaCount,
                              currentPizzaSlice: self.currentPizzaSlice,
                              pizzaList: value,
                              createdAt: self.createdAt)
        }
    }
    
    static func mapFromPersistenceObject(_ object: PersistenceType) -> Self {
        User(id: object.id.stringValue,
             nickName: object.nickName,
             currentPizzaCount: object.currentPizzaCount,
             currentPizzaSlice: object.currentPizzaSlice,
             pizzas: object.pizza.map { Pizza.mapFromPersistenceObject($0) },
             createdAt: object.createdAt)
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    /// 피자 조각을 추가하고 , 8조각 이상일시 슬라이스를 0으로 만들고 피자카운트를 (1 = defaut) 증가 시키는 메서드
    /// - Parameter count: 피자 조각갯수
    mutating func addPizzaSliceValidation(count: Int = 1) -> Self {
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
        var pizza = pizza
        pizza.lockToggle()
        let newPizzas = self.pizzas.map { originalPizza in
            originalPizza.name == pizza.name ? pizza : originalPizza
        }
        self.pizzas = newPizzas
    }

    // MARK: 안쓰는 메서드 확인후 삭제바람
    func update(_ status: Status) -> Self {
        User(id: self.id,
             nickName: self.nickName,
             currentPizzaCount: self.currentPizzaSlice,
             currentPizzaSlice: self.currentPizzaSlice,
             createdAt: self.createdAt)
    }
    
}
