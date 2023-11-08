//
//  NavigationModifier.swift
//  Pickle
//
//  Created by 박형환 on 11/7/23.
//

import SwiftUI

struct NavigationModifier: ViewModifier {
    
    @Binding var tabBarvisibility: Visibility
        
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
            NavigationLink {
                RegisterView(willUpdateTodo: .constant(Todo.sample),
                             successDelete: .constant(false),
                             isShowingEditTodo: .constant(false),
                             isModify: false)
                .backKeyModifier(tabBarvisibility: $tabBarvisibility)
            } label: {
                Image(systemName: "plus.circle")
                    .foregroundStyle(Color.pickle)
            }
        }
        ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink {
                MissionView()
                    .backKeyModifier(tabBarvisibility: $tabBarvisibility)
            } label: {
                Image("mission")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
            }
        }
    }
}
