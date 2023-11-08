//
//  CompleteAlert.swift
//  Pickle
//
//  Created by Suji Jang on 10/23/23.
//

import SwiftUI

struct CompleteMessage {
    let isPresented: Binding<Bool>
    let pizzaName: String
    let title: String
    let contents: String
}

extension View {
    func completePizzaAlert(
        message: CompleteMessage
    ) -> some View {
        return modifier(
            CompleteAlertModifier(
                isPresented: message.isPresented,
                pizzaName: message.pizzaName,
                title: message.title,
                contents: message.contents
            )
        )
    }
}

struct CompleteAlertModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    let pizzaName: String
    let title: String
    let contents: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            ZStack {
                if isPresented {
                    Rectangle()
                        .fill(.black.opacity(0.5))
                        .blur(radius: isPresented ? 2 : 0)
                        .ignoresSafeArea()
                        .onTapGesture {
                            self.isPresented = false // 외부 영역 터치 시 내려감
                        }
                    
                    CompleteAlert(
                        isPresented: self.$isPresented,
                        pizzaName: self.pizzaName,
                        title: self.title,
                        contents: self.contents
                    )
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

struct CompleteAlert: View {
    
    @Binding var isPresented: Bool
    let pizzaName: String
    let title: String
    let contents: String
    
    var body: some View {
        VStack(spacing: 22) {
            Image(pizzaName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: CGFloat.screenWidth * 0.5)
                .padding(.top, 20)
            
            Text(title)
                .font(.title)
                .bold()
                .foregroundColor(.black)
            
            Text("\(contents) 완성")
                .font(.pizzaBody)
                .foregroundStyle(.black)
                .padding(.bottom, 20)
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
            CompleteAlertModifier(
                isPresented: .constant(true),
                pizzaName: "smilePizza",
                title: "축하합니다",
            contents: "포테이토")
        )
}
