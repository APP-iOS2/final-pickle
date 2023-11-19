//
//  EnvironmentValues.swift
//  Pickle
//
//  Created by 박형환 on 11/16/23.
//

import SwiftUI

struct ScrollContainer: EnvironmentKey {
    static var defaultValue: Binding<ScrollEnableKey> = .constant(.init())
}

struct ScrollEnableKey {
    var root: Bool = false
    var setting: Bool = false
    var calendar: Bool = false
}

extension EnvironmentValues {
    var scrollEnable: Binding<ScrollEnableKey> {
        get { self[ScrollContainer.self] }
        set { self[ScrollContainer.self] = newValue }
    }
}

extension View {
    func scrollEnableInject(_ container: Binding<ScrollEnableKey>) -> some View {
        self.environment(\.scrollEnable, container)
    }
}
