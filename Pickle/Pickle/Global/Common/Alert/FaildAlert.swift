//
//  FaildAlert.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//

import SwiftUI

extension View {
    func failedAlert(
        isPresented: Binding<Bool>,
        title: String,
        alertContent: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        _ externalTapAction: (() -> Void)?  = nil
    ) -> some View {
        return modifier(
            FaildAlertModifier(
                isPresented: isPresented,
                title: title,
                alertContent: alertContent,
                primaryButtonTitle: primaryButtonTitle,
                secondaryButtonTitle: secondaryButtonTitle,
                primaryAction: primaryAction,
                secondaryAction: secondaryAction,
                externalAction: externalTapAction
            )
        )
    }
    
    func successAlert(
        isPresented: Binding<Bool>,
        title: String,
        alertContent: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        _ externalTapAction: (() -> Void)? = nil
    ) -> some View {
        return modifier(
            FaildAlertModifier(
                isPresented: isPresented,
                title: title,
                alertContent: alertContent,
                primaryButtonTitle: primaryButtonTitle,
                secondaryButtonTitle: secondaryButtonTitle,
                primaryAction: primaryAction,
                secondaryAction: secondaryAction,
                externalAction: externalTapAction
            )
        )
    }
}

struct FaildAlertModifier: ViewModifier {
    
    @Environment(\.dismiss) var dissmiss
    @Binding var isPresented: Bool
    let title: String
    let alertContent: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String
    let primaryAction: () -> Void
    let secondaryAction: (() -> Void)?
    let externalAction: (() -> Void)?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            ZStack {
                if isPresented {
                    Rectangle()
                        .fill(.black.opacity(0.5))
                                            .blur(radius: isPresented ? 2 : 0)
                        .ignoresSafeArea(.all)
                        .onTapGesture {
                            self.isPresented = false // 외부 영역 터치 시 내려감
                            if let externalAction {
                                externalAction()
                            } else {
                                dissmiss()
                            }
                        }
                    RegisterAlert(isPresented: $isPresented,
                                  title: title,
                                  contents: alertContent,
                                  primaryButtonTitle: primaryButtonTitle,
                                  primaryAction: { _ in primaryAction() },
                                  primaryparameter: 0,
                                  secondaryButton: secondaryButtonTitle,
                                  secondaryAction: secondaryAction ?? { dissmiss() })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                }
            }
            .animation(
                isPresented
                ? .spring(response: 0.3)
                : .none,
                value: isPresented
            )
        }
    }
}

struct FaildAlert: View {
    
    @Binding var isPresented: Bool
    let title: String
    let content: String
    let primaryButtonTitle: String
    let primaryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 22) {
            Text(title)
                .font(.title)
                .bold()
                .foregroundColor(.red.opacity(0.5))
            
            Text("\(content)")
                .font(.pizzaBody)
                .foregroundStyle(.primary)
            
            Button {
                primaryAction()
                isPresented = false
            } label: {
                Text(primaryButtonTitle)
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .bold()
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.pickle)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
        .frame(width: 300)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.white)
        )
        
    }
}

#Preview {
    Text("미션 완료 알럿 테스트")
        .modifier(
            FaildAlertModifier(isPresented: .constant(true),
                               title: "",
                               alertContent: "",
                               primaryButtonTitle: "",
                               secondaryButtonTitle: "", 
                               primaryAction: { },
                               secondaryAction: nil,
                               externalAction: nil)
        )
}
