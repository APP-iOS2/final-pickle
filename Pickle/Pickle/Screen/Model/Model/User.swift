//
//  User.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/26.
//

import Foundation

struct User: Identifiable {
    let id: String
    var nickName: String
    var currentPizzaCount: Int
    var currentPizzaSlice: Int
    var pizzaID: String
    var currentPizzas: [CurrentPizza]
    var createdAt: Date  // 유저 계정 생성 날짜,시간
    
    init(id: String,
         nickName: String,
         currentPizzaCount: Int,
         currentPizzaSlice: Int,
         pizzaID: String = "",
         currentPizzas: [CurrentPizza],
         createdAt: Date) {
        self.id = id
        self.nickName = nickName
        self.currentPizzaCount = currentPizzaCount
        self.currentPizzaSlice = currentPizzaSlice
        self.pizzaID = pizzaID
        self.currentPizzas = currentPizzas
        self.createdAt = createdAt
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
        let currentPizza = getCurrentPizza(using: pizza.id)
    
        guard var currentPizza else { return }
        var pizza = pizza
        pizza.lockToggle()
        currentPizza.pizza = pizza
        
        self.currentPizzas = self.currentPizzas.map {
            return currentPizza.id == $0.id ? currentPizza : $0
        }
    }
    
    func getCurrentPizza(using id: String) -> CurrentPizza? {
        return self.currentPizzas.filter {
            if $0.pizza?.id == id {
                return true
            }
            return false
        }.first
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

extension User {
    static var defaultUser: User {
        let currentPizzas = Pizza.allCasePizza.map { CurrentPizza(pizza: $0) }
        return .init(id: UUID().uuidString,
                     nickName: "Guest",
                     currentPizzaCount: 0,
                     currentPizzaSlice: 0,
                     pizzaID: currentPizzas.first!.pizza!.id,
                     currentPizzas: currentPizzas,
                     createdAt: Date())
    }
}
