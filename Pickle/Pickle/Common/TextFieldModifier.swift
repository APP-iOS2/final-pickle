//
//  TextFieldModifier.swift
//  Pickle
//
//  Created by 박형환 on 9/25/23.
//

import SwiftUI
 
struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .tint(Color(.black).opacity(0.4))
    }
}

struct TextFieldModifier: ViewModifier {
    
    let completion: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 16)
            .background(RoundedRectangle(cornerRadius: 5).fill(Color.lightGray))
            .textFieldStyle(MyTextFieldStyle())
            .onSubmit {
                completion()
            }
    }
}

extension View {
    func makeTextField(_ completion: @escaping () -> Void) -> some View {
        modifier(TextFieldModifier(completion: completion))
    }
}
