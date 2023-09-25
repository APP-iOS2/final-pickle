//
//  View.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

extension View {
    /// MainView들을 제외한 View 에서 사용가능한 공통 네비게이션 바 수정자
    func infanNavigationBar(title: String) -> some View {
        modifier(NavigationBar(title: title))
    }
}
