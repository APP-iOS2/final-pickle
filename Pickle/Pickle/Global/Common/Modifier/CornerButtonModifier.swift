//
//  CornerRadiusButtonModifier.swift
//  Pickle
//
//  Created by 박형환 on 10/4/23.
//

import SwiftUI

struct CornerButtonModifier: ViewModifier {
    
    let width: CGFloat
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: width)
            .foregroundStyle(.primary)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.tertiary, lineWidth: 1)
            )
    }
}
