//
//  MissionCompleteAlert.swift
//  Pickle
//
//  Created by Suji Jang on 10/6/23.
//

import SwiftUI

extension View {
    func getRewardAlert(
        isPresented: Binding<Bool>,
        title: String,
        point: Int,
        primaryButtonTitle: String,
        primaryAction: @escaping () -> Void
    ) -> some View {
        return modifier(
            RewardAlertModifier(
                isPresented: isPresented,
                title: title,
                point: point,
                primaryButtonTitle: primaryButtonTitle,
                primaryAction: primaryAction
            )
        )
    }
}

struct RewardAlertModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    let title: String
    let point: Int
    let primaryButtonTitle: String
    let primaryAction: () -> Void
    
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
                    
                    RewardAlert(
                        isPresented: self.$isPresented,
                        title: self.title,
                        point: self.point,
                        primaryButtonTitle: self.primaryButtonTitle,
                        primaryAction: self.primaryAction
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

struct RewardAlert: View {
    
    @Binding var isPresented: Bool
    let title: String
    let point: Int
    let primaryButtonTitle: String
    let primaryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 22) {
            Image("smilePizza")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: CGFloat.screenWidth * 0.5)
            
            Text(title)
                .font(.pizzaRegularTitle)
                .bold()
                .foregroundColor(.black)
            
            Divider()
            
            HStack {
                Text("P")
                    .font(.body)
                    .bold()
                    .foregroundColor(.white)
                    .padding(6)
                    .background(
                        Circle()
                            .fill(Color.black)
                    )
                
                Text("피자")
                    .foregroundColor(.black)
                    .bold()
                
                Spacer()
                
                Text("+\(point) 조각")
                    .bold()
                    .foregroundColor(.black)
            }
            .font(.title2)
            
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
            .tint(Color.pickle)
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
        .modifier(
            RewardAlertModifier(
                isPresented: .constant(true),
                title: "제목",
                point: 1,
                primaryButtonTitle: "버튼 이름",
                primaryAction: { })
        )
}
