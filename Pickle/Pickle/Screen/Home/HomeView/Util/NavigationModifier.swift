//
//  NavigationModifier.swift
//  Pickle
//
//  Created by 박형환 on 11/7/23.
//

import SwiftUI

struct NavigationModifier: ViewModifier {
    
    @Binding var tabBarvisibility: Visibility
    @EnvironmentObject var navigationStore: NavigationStore
        
    func body(content: Content) -> some View {
        content
            .navigationTitle(Date().format("MM월 dd일 EEEE"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarBuillder }
            .toolbar( tabBarvisibility, for: .tabBar)
    }
    
    // MARK: Navigation Tool Bar , MissionView, RegisterView
    @ToolbarContentBuilder
    var toolbarBuillder: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Image(systemName: "plus.circle")
                .foregroundStyle(Color.pickle)
                .onTapGesture {
                    navigationStore.pushHomeView(home: .pushRegisterTodo)
                }
        }
        ToolbarItem(placement: .navigationBarLeading) {
            Image("mission")
                .resizable()
                .scaledToFit()
                .frame(width: 24)
                .onTapGesture {
                    navigationStore.pushHomeView(home: .pushMission)
                }
        }
    }
}
