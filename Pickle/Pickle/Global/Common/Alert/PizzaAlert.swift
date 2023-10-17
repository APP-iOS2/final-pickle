//
//  PizzaAlert.swift
//  Pickle
//
//  Created by 박형환 on 10/15/23.
//

import SwiftUI
       
extension View {
    func showPizzaAlert(
        isPresented: Binding<Bool>,
        title: String,
        price: String,
        descripation: String,
        image: String,
        puchaseButtonTitle: String,
        primaryButtonTitle: String,
        primaryAction: @escaping () -> Void
    ) -> some View {
        return modifier(
            PizzaAlertModifier(isPresented: isPresented,
                               title: title,
                               price: price,
                               descripation: descripation,
                               image: image,
                               puchaseButtonTitle: puchaseButtonTitle,
                               primaryButtonTitle: primaryButtonTitle,
                               primaryAction: primaryAction)
        )
    }
}

struct PizzaAlertModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    let title: String
    let price: String
    let descripation: String
    let image: String
    let puchaseButtonTitle: String
    let primaryButtonTitle: String
    let primaryAction: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
            ZStack {
                if isPresented {
                    Rectangle()
                        .fill(.black.opacity(0.5))
                        .ignoresSafeArea(.all)
                        .onTapGesture {
                            self.isPresented = false // 외부 영역 터치 시 내려감
                        }
                    
                    PizzaAlert(isPresented: $isPresented,
                               title: title,
                               price: price,
                               descripation: descripation,
                               image: image,
                               puchaseButtonTitle: puchaseButtonTitle,
                               primaryButtonTitle: primaryButtonTitle,
                               primaryAction: primaryAction)
                    
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(
                isPresented
                ? .spring(response: 0.3)
                : .none,
                value: isPresented
            )
            .zIndex(2)
        }
    }
}

struct PizzaAlert: View {
    @Binding var isPresented: Bool
    let title: String
    let price: String
    let descripation: String
    let image: String
    let puchaseButtonTitle: String
    let primaryButtonTitle: String
    let primaryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 22) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.red.opacity(0.5))
                
                Text("\(price)")
                    .font(.pizzaRegularSmallTitle)
                
                Text("\(descripation)")
                    .font(.pizzaRegularSmallTitle)
            }
            
            Image("\(image)")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            
            Button {
                primaryAction()
                isPresented = false
            } label: {
                Text(primaryButtonTitle)
                    .font(.title3)
                    .bold()
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.primary)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
        .frame(width: 300)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .stroke(.black.opacity(0.5))
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.white)
                )
        )
    }
}

#Preview {
    Text("미션 완료 알럿 테스트")
        .modifier(PizzaAlertModifier(isPresented: .constant(true),
                             title: "안녕하세요",
                             price: "안녕하세요",
                             descripation: "안녕하세요",
                             image: "potatoPizza",
                             puchaseButtonTitle: "안녕하세요",
                             primaryButtonTitle: "안녕하세요", primaryAction: { } ))
}
