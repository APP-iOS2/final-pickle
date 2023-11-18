//
//  HomeViewModel.swift
//  Pickle
//
//  Created by 박형환 on 11/17/23.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    typealias PizzaSelection = PizzaSelectedView.Selection
    typealias PositionID = HomeView.ScrollPizzaID
    
    @Published var offset: CGFloat = 0
    @Published var scrollViewDifference: CGFloat = 0
    @Published var pizzaSelection: PizzaSelection = .init()
    @Published var pizzaPosition: PositionID?
    @Published var currentPositionPizza: CurrentPizza = .init(pizza: .defaultPizza)
    
    var isPositionChange: Bool {
        self.offset.remainder(dividingBy: self.scrollViewDifference) == 0
    }
    
    func nextPizzaScrollPosition(user: User, direction: Bool = true) {
        let index = currentPizzaPosition(user: user)
        let count = user.currentPizzas.count
        
        let defaultPosition: Int
        let nextPosition: Int
        let condition: Bool
        defaultPosition = direction ? 0 : count - 1
        nextPosition = direction ? index + 1 : index - 1
        condition = direction ? index == count - 1 : index == 0
        
        let positionID = condition
        ?
        user.currentPizzas[safe: defaultPosition]?.pizza?.id ?? ""
        :
        user.currentPizzas[safe: nextPosition]?.pizza?.id ?? ""
        
        pizzaPosition = .pizza(positionID)
        // updatePositionPizza(user: user, positionID: positionID)
    }
    
    func gesturePositionUpdate(user: User) {
        let positionIndex: Int = Int(offset / scrollViewDifference)
        guard let positionID = user.currentPizzas[safe: positionIndex]?.pizza?.id else { return }
        
        pizzaPosition = .pizza(positionID)
        updatePositionPizza(user: user, positionID: positionID)
    }
    
    private func updatePositionPizza(user: User, positionID: String) {
        let pizza = user.getCurrentPizza(using: positionID)
        if let pizza {
            currentPositionPizza = pizza
        }
    }
    
    private func pizzasIDs(user: User) -> [String] {
        user.currentPizzas.compactMap(\.pizza).map(\.id)
    }
    
    private func currentPizzaPosition(user: User) -> Int {
        guard let position = pizzaPosition else { return 0 }
        
        if case let .pizza(ID) = position {
            guard let index = pizzasIDs(user: user).firstIndex(of: ID) else { return 0 }
            return index
        }
        return 0
    }
    
}
