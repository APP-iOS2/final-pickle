//
//  CurrentPizza.swift
//  Pickle
//
//  Created by 박형환 on 11/13/23.
//

import Foundation

struct CurrentPizza: Identifiable {
    let id: String
    var currentPizzaCount: Int
    var currentPizzaSlice: Int
    var pizza: Pizza?
    var createdAt: Date  // 유저 계정 생성 날짜,시간
    
    init(id: String = UUID().uuidString,
         currentPizzaCount: Int = .init(),
         currentPizzaSlice: Int = .init(),
         pizza: Pizza?,
         createdAt: Date = .init()) {
        
        self.id = id
        self.currentPizzaCount = currentPizzaCount
        self.currentPizzaSlice = currentPizzaSlice
        self.pizza = pizza
        self.createdAt = createdAt
    }
    
    // TODO: 변경 필요 - current Pizza로 변경함에 따라 변경 필요
    var goalTotal: Double {
        8 // 피자 완성 카운트
    }
    var taskPercentage: Double {
        Double(self.currentPizzaSlice) / goalTotal
    }
    var pizzaTaskSlice: String {
        /// Pizza  ex) 1 / 8 - 유저의 완료한 피자조각 갯수....
        "\(Int(self.currentPizzaSlice)) / \(Int(goalTotal))"
    }
    var content: String {
        self.currentPizzaSlice > 0 ? "" : "?"
    }
    
}
