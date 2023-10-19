//
//  View.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

extension View {
    /// MainView들을 제외한 View 에서 사용가능한 공통 네비게이션 바 수정자
    func pizzaNavigationBar(title: String) -> some View {
        modifier(NavigationBar(title: title, visible: true))
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
        modifier(CornerButtonModifier(width: width,
                                      cornerRadius: cornerRadius))
    }
}

extension View {
    func primaryButtonModifier(frame width: CGFloat = 300, 
                               cornerRadius: CGFloat = 12) -> some View {
        modifier(PrimaryButtonModifier(width: width, 
                                       cornerRadius: cornerRadius))
    }
}

extension View {
    func makeTextField(_ completion: @escaping () -> Void) -> some View {
        modifier(TextFieldModifier(completion: completion))
    }

}

extension View {

    /// Navigation Bar의 Appearence를 셋팅하는 함수, 현재는 고정값으로 되어있어서 함수 내부를 직접 수정해야함
    func navigationAppearenceSetting() {
        let appear = UINavigationBarAppearance()
        
        let atters: [NSAttributedString.Key: Any] = [
            .font: UIFont.init(name: "NanumSquareNeo-aLt", size: 16)!
        ]
        
        let large: [NSAttributedString.Key: Any]  = [.font: UIFont(name: "NanumSquareNeo-cBd", size: 27)!]

        appear.largeTitleTextAttributes = large
        appear.titleTextAttributes = atters
        
        UINavigationBar.appearance().standardAppearance = appear
        UINavigationBar.appearance().compactAppearance = appear
    }
}
