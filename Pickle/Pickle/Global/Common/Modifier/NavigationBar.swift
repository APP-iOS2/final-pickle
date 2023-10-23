//
//  NavigationBar.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct NavigationBar: ViewModifier {
    @Environment(\.dismiss) var dismiss
    
    let title: String
    @Binding var tabBarvisibility: Visibility
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            dismiss()
                            tabBarvisibility = .visible
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundColor(.primary)
                }
            }
            .onAppear {
                withAnimation {
                    tabBarvisibility = .hidden
                }
            }
            .toolbar(tabBarvisibility, for: .tabBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(title)
            .navigationBarBackButtonHidden()
    }
}
