//
//  GiveupAlert.swift
//  Pickle
//
//  Created by 여성은 on 2023/10/20.
//

import SwiftUI

extension View {
    func showGiveupAlert (
        isPresented: Binding<Bool>,
        title: String,
        contents: String,
        primaryButtonTitle: String,
        primaryAction: @escaping (Double) -> Void,
        primaryparameter: TimeInterval,
        secondaryButton: String,
        secondaryAction: @escaping () -> Void
    ) -> some View {
        return modifier(
            GiveupAlertModifier(isPresented: isPresented,
                                title: title,
                                contents: contents,
                                primaryButtonTitle: primaryButtonTitle,
                                primaryAction: primaryAction, 
                                primaryparameter: primaryparameter,
                                secondaryButton: secondaryButton,
                                secondaryAction: secondaryAction)
        )
    }
}

struct GiveupAlertModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    
    let title: String
    let contents: String
    let primaryButtonTitle: String
    let primaryAction: (Double) -> Void
    let primaryparameter: TimeInterval
    let secondaryButton: String
    let secondaryAction: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
            ZStack {
                if isPresented {
                    Rectangle()
                        .fill(.primary.opacity(0.3))
                        .blur(radius: isPresented ? 2 : 0)
                        .ignoresSafeArea()
                        .onTapGesture {
                            self.isPresented = false // 외부 영역 터치 시 내려감
                        }
                    
                    GiveupAlert(isPresented: $isPresented,
                                title: title,
                                contents: contents,
                                primaryButtonTitle: primaryButtonTitle,
                                primaryAction: primaryAction, 
                                primaryparameter: primaryparameter,
                                secondaryButton: secondaryButton,
                                secondaryAction: secondaryAction)
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

struct GiveupAlert: View {
    
    @Binding var isPresented: Bool
    
    let title: String
    let contents: String
    let primaryButtonTitle: String
    let primaryAction: (_ timeInterval: TimeInterval) -> Void
    let primaryparameter: TimeInterval
    let secondaryButton: String
    let secondaryAction: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
                Text(title)
                .font(.pizzaRegularTitle)
            
                Text(contents)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
                .font(.pizzaBody)
                .foregroundColor(.secondary)
                
                HStack {
                    
                    Button {
                        secondaryAction()
                        isPresented = false
                    } label: {
                        Text(secondaryButton)
                            .foregroundColor(.textGray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 2)
                    }
                    
                    Button {
                        primaryAction(primaryparameter)
                        isPresented = false
                    } label: {
                        Text(primaryButtonTitle)                            
                            .foregroundColor(.pepperoniRed)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 2)
                    }
                }
                .font(.pizzaBoldButton15)
                .buttonStyle(.borderedProminent)
                .tint(.lightGray)
                
        }
        .padding(.horizontal, 25)
        .frame(width: .screenWidth * 0.85, height: .screenWidth * 0.5)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .stroke(.black.opacity(0.5))
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.primary)
                        .colorInvert()
                )
        )
    }
}

#Preview {
    Text("포기하기 alert Test")
        .modifier(GiveupAlertModifier(isPresented: .constant(true),
                                      title: "포기하시겠어요?",
                                      contents: "지금 포기하면 피자조각을 얻지 못해요",
                                      primaryButtonTitle: "포기하기",
                                      primaryAction: { _ in }, 
                                      primaryparameter: 20,
                                      secondaryButton: "돌아가기",
                                      secondaryAction: { }))
}
