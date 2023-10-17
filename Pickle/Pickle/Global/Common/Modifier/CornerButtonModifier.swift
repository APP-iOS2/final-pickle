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
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
            )
    }
}
