//
//  OffsetKey.swift
//  Pickle
//
//  Created by kaikim on 2023/09/26.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
