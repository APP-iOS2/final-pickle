//
//  BackgroundColorModifier.swift
//  Pickle
//
//  Created by 박형환 on 9/25/23.
//

import SwiftUI

struct BackColorModifier: ViewModifier {
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
    
    func body(content: Content) -> some View {
        content
            .background(filteredColor)
            .clipShape(RoundedRectangle(cornerRadius: 12)) // clip corners
            .background(
                RoundedRectangle(cornerRadius: 12) // stroke border
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal, 12)
    }
}

extension View {
    func asRoundBackground() -> some View {
        modifier(BackColorModifier())
    }
}
