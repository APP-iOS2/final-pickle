//
//  UpdatePreferenceKey.swift
//  Pickle
//
//  Created by 박형환 on 11/20/23.
//

import SwiftUI

struct SuccessUpdateKey: PreferenceKey {
    
    static var defaultValue: Bool = true
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        defaultValue = nextValue()
    }
}
