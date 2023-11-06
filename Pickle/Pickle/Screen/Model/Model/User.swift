//
//  User.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/26.
//

import Foundation

struct CurrentPizza: Identifiable {
    let id: String
    var currentPizzaCount: Int
    var currentPizzaSlice: Int
    var pizza: Pizza
    var createdAt: Date  // 유저 계정 생성 날짜,시간
    
    init(id: String = UUID().uuidString,
         currentPizzaCount: Int = .init(),
         currentPizzaSlice: Int = .init(),
         pizza: Pizza = .defaultPizza,
         createdAt: Date = .init()) {
        
        self.id = id
        self.currentPizzaCount = currentPizzaCount
        self.currentPizzaSlice = currentPizzaSlice
        self.pizza = pizza
        self.createdAt = createdAt
    }
}

struct User: Identifiable {
    let id: String
    var nickName: String
    var currentPizzaCount: Int
    var currentPizzaSlice: Int
    var pizzas: [Pizza]
    var currentPizzas: [CurrentPizza]
    var createdAt: Date  // 유저 계정 생성 날짜,시간
    
    init(id: String,
         nickName: String,
         currentPizzaCount: Int,
         currentPizzaSlice: Int,
         pizzas: [Pizza] = [],
         currentPizzas: [CurrentPizza],
         createdAt: Date) {
        self.id = id
        self.nickName = nickName
        self.currentPizzaCount = currentPizzaCount
        self.currentPizzaSlice = currentPizzaSlice
        self.pizzas = pizzas
        self.currentPizzas = currentPizzas
        self.createdAt = createdAt
    }
}

extension User {
    static let defaultUser: User = .init(id: UUID().uuidString,
                                         nickName: "Guest",
                                         currentPizzaCount: 0,
                                         currentPizzaSlice: 0,
                                         pizzas: Pizza.allCasePizza,
                                         currentPizzas: [],
                                         createdAt: Date())
}
