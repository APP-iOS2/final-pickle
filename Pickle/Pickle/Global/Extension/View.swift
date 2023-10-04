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
        modifier(NavigationBar(title: title,visible: true))
    }
    
    func hSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
}

extension View {
    func backKeyModifier(_ title: String = "", visible: Bool = true) -> some View {
        modifier(NavigationBar(title: title, visible: visible))
    }
}

extension View {
    func cornerRadiusModifier(frame width: CGFloat = 200,
                              cornerRadius: CGFloat = 12) -> some View {
        modifier(CornerButtonModifier(width: width ,
                                      cornerRadius: cornerRadius))
    }
}

extension View {
    func makeTextField(_ completion: @escaping () -> Void) -> some View {
        modifier(TextFieldModifier(completion: completion))
    }
}
