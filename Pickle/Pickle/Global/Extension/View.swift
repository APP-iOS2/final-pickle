//
//  View.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

extension View {
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
    func fixSize(_ width: CGFloat) -> some View {
        self.frame(width: width,
                height: width,
                alignment: .center)
    }
    func fixSize(_ geo: GeometryProxy,
                 diffX x: CGFloat = 0,
                 diffY y: CGFloat = 0) -> some View {
        
        self.frame(width: geo.size.width + x,
                height: geo.size.height + y,
                alignment: .center)
    }
}

extension View {
    func backKeyModifier(_ title: String = "", tabBarvisibility: Binding<Visibility>) -> some View {
        modifier(NavigationBar(title: title, tabBarvisibility: tabBarvisibility))
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
