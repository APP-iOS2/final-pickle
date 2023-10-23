//
//  TextFieldModifier.swift
//  Pickle
//
//  Created by 박형환 on 9/25/23.
//

import SwiftUI
 
struct TextFieldModifier: ViewModifier {
    
    let completion: () -> Void
    
    @Environment(\.colorScheme) var scheme
    
    private var filteredColor: Color {
        switch scheme {
        case .dark:
            return .secondary
        case .light:
            return .lightGray
        @unknown default:
            fatalError()
        }
    }
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
    }

    func body(content: Content) -> some View {
        content
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(filteredColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .background(
                RoundedRectangle(cornerRadius: 12) // storke
                    .stroke(Color.gray.opacity(0.2), lineWidth: 2)
            )
            .tint(Color(.black).opacity(0.4))
            .onSubmit {
                completion()
            }
    }
}
