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
    let visible: Bool
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundColor(.black)
                }
            }
            .toolbar(visible ? .visible : .hidden, for: .tabBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(title)
            .navigationBarBackButtonHidden()
    }
}
