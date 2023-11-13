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

// HomeView 에서 Prefenrence Change를 옵저브 하고 있었지만
// PizzaSeletedView는 modifier로 동일 계층에 ZStack에 올린 View로써 HOmeView가 상위뷰가 아니라 동일계층으로 인식되어
// onPreferenceChange가 호출되지 않음
//            .preference(key: PizzaPuchasePresentKey.self,
//                        value: isPizzaPuchasePresent)
//            .onPreferenceChange(PizzaPuchasePresentKey.self) {
//            bool in
//            Log.debug("onPreferenceChagne: \(bool)")
//            isPizzaPuchasePresent = bool
//        }

//                    .onPreferenceChange(PizzaPuchasePresentKey.self) { value in
//                        Log.error("onPreference value: \(value)")
//                    }
//                    .preference(key: PizzaPuchasePresentKey.self,
//                                value: isPizzaPuchasePresent)
