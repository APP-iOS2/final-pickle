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
        lock: Bool,
        puchaseButtonTitle: String,
        primaryButtonTitle: String,
        primaryAction: @escaping () -> Void,
        pizzaMakeNavAction: @escaping () -> Void
    ) -> some View {
        return modifier(
            PizzaAlertModifier(isPresented: isPresented,
                               title: title,
                               price: price,
                               descripation: descripation,
                               image: image,
                               lock: lock,
                               puchaseButtonTitle: puchaseButtonTitle,
                               primaryButtonTitle: primaryButtonTitle,
                               primaryAction: primaryAction,
                               pizzaMakeNavAction: pizzaMakeNavAction)
        )
    }
}

struct PizzaAlertModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    let title: String
    let price: String
    let descripation: String
    let image: String
    let lock: Bool
    let puchaseButtonTitle: String
    let primaryButtonTitle: String
    let primaryAction: () -> Void
    let pizzaMakeNavAction: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
            ZStack {
                if isPresented {
                    Rectangle()
                        .fill(.black.opacity(0.5))
                        .ignoresSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                self.isPresented.toggle() // 외부 영역 터치 시 내려감
                            }
                        }
                    
                    PizzaAlert(isPresented: $isPresented,
                               title: title,
                               price: price,
                               descripation: descripation,
                               image: image,
                               lock: lock,
                               puchaseButtonTitle: puchaseButtonTitle,
                               primaryButtonTitle: primaryButtonTitle,
                               puchaseAction: primaryAction,
                               pizzaMakeNavAction: pizzaMakeNavAction)
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
    let lock: Bool
    let puchaseButtonTitle: String
    let primaryButtonTitle: String
    let puchaseAction: () -> Void
    let pizzaMakeNavAction: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(alignment: .center, spacing: 8) {
                HStack(alignment: .center) {
                    ZStack {
                        Text(title)
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Button(action: {
                            withAnimation {
                                isPresented.toggle()
                            }
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .tint(Color.defaultGray)
                                .frame(width: 28, height: 28)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        })
                    }
                }
                
                Text("\(price)")
                    .font(.pizzaRegularSmallTitle)
                
                Text("\(descripation)")
                    .font(.pizzaRegularSmallTitle)
            }
            
            ZStack {
                if lock {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white)
                        .frame(width: CGFloat.screenWidth / 5,
                               height: CGFloat.screenWidth / 5,
                               alignment: .center)
                        .zIndex(3)
                }
                
                Image("\(image)")
                    .resizable()
                    .frame(width: CGFloat.screenWidth / 2,
                           height: CGFloat.screenWidth / 2, alignment: .center)
                    .clipShape( Circle() )
                    .overlay {
                        Circle()
                            .fill(lock ? .black.opacity(0.4) : .clear )
                    }
            }
            
            Button {
                withAnimation {
                    isPresented.toggle()
                }
                puchaseAction()
            } label: {
                Text(puchaseButtonTitle)
                    .font(.pizzaBody)
                    .bold()
                    .tint(.primary).colorInvert()
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.defaultGray)
            
            Button {
                withAnimation {
                    isPresented.toggle()
                }
                pizzaMakeNavAction()
            } label: {
                Text("\(primaryButtonTitle)")
                    .font(.pizzaBody)
                    .tint(Color.pickle)
                    .padding(.bottom, 10)
            }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 18)
        .frame(width: CGFloat.screenWidth - 40)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .stroke(.white.opacity(0.5))
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.primary)
                        .colorInvert()
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
                                     lock: false,
                                     puchaseButtonTitle: "안녕하세요",
                                     primaryButtonTitle: "안녕하세요", 
                                     primaryAction: { },
                                     pizzaMakeNavAction: { } ))
}
