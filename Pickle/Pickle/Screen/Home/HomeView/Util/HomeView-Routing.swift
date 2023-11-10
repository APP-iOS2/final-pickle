//
//  HomeView-Routing.swift
//  Pickle
//
//  Created by 박형환 on 11/9/23.
//

import Foundation

extension HomeView {
    enum Routing: Hashable, Identifiable {
        var id: Self {
            return self
        }
        case pushMission                     // stack
        case pushRegisterTodo                // stack
        case isShowingEditTodo(Bool, Todo)   // modal  homeView -> isShoiwingEditTodo
        case isPizzaSeleted(Bool)            // sheet  homeView -> ispizzaSeleted
        case showCompleteAlert(Bool)         // sheet  homeView -> ShowCompleteAlert
        case isShowingTimerView(Todo)
        case none
    }
}
