//
//  PreferenceKey.swift
//  Pickle
//
//  Created by 박형환 on 11/7/23.
//

import SwiftUI

struct PizzaPuchasePresentKey: PreferenceKey {
    static var defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}
