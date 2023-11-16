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

extension User {
    static var defaultUser: User {
        let currentPizza = CurrentPizza(pizza: .defaultPizza)
        return .init(id: UUID().uuidString,
                     nickName: "Guest",
                     currentPizzaCount: 0,
                     currentPizzaSlice: 0,
                     pizzaID: currentPizza.pizza!.id,
                     currentPizzas: [currentPizza],
                     createdAt: Date())
    }
    
}
