//
//  ColorModifier.swift
//  Pickle
//
//  Created by 박형환 on 10/18/23.
//

import SwiftUI

extension View {
    func modeBackground() -> some View {
        modifier(BackgroundModifier())
    }
}

struct BackgroundModifier: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    var colorMode: Color {
        switch colorScheme {
        case .light:
            return .white
        case .dark:
            return .gray
        @unknown default:
            return .secondary
        }
    }
    func body(content: Content) -> some View {
        content
            .background(colorMode, ignoresSafeAreaEdges: [])
    }
}


enum Theme {
    static func colorMode(_ scheme: ColorScheme) -> Color {
        let lightColor = Color.white
        let darckColor = Color.gray
        
        switch scheme {
        case .light: return lightColor
        case .dark: return darckColor
        @unknown default: return lightColor
        }
    }
    
    static func colorMode2(_ scheme: ColorScheme) -> Color {
        let lightColor = Color.gray
        let darckColor = Color.white
        
        switch scheme {
        case .light: return lightColor
        case .dark: return darckColor
        @unknown default: return lightColor
        }
    }
}
