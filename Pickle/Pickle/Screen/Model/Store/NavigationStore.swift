//
//  NavigationStore.swift
//  Pickle
//
//  Created by 박형환 on 10/29/23.
//

import SwiftUI

enum PZRouting: Identifiable, Hashable {
    var id: Self {
        self
    }
    
    case home(HomeView.Routing)
    case home_register
    case home_pizza
    case home_mission
    case home_timer
    case calendar
    case analyize
    case setting
    case timer
}

final class NavigationStore: ObservableObject {
    
    @Published var path: NavigationPath = .init()
    
    func navigateToScreen() {
        path.append(PZRouting.home(.isShowingEditTodo))
    }
}
