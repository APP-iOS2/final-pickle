//
//  PizzaSelectedView.swift
//  Pickle
//
//  Created by 박형환 on 10/14/23.
//

import SwiftUI

// TODO: 인앱 puchase Mock으로 구현
// TODO: Deep Link 구현
    // 1. 피자 완성하러가기 -> 홈으로? 아니면 어디로
    // 2. 구매하러 가기
// TODO: Alert에 Unlock (lock.fill) 표시하기 - 완료
    // 1. 잠금상태 일때와, 비잠금상태 구분 - 콘텐츠의 내용을 구분해야 하나?
    // 1-1. 잠금,비잠금 상태 구분해서 action을 다르게 주기
    //
// TODO: Image Cache 현재 PizzaSeleted의 이미지 메모리량을 많이 잡아먹는 상태

struct PizzaSelectedView: View {
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    @EnvironmentObject var navigationStore: NavigationStore
    @State private var isPizzaPuchasePresent: Bool = false
    @Binding var selection: Selection
    
    struct Selection {
        var pizzas: [Pizza] = []
        var seletedPizza: Pizza = .defaultPizza
        var currentPizza: Pizza = .defaultPizza
        var isPizzaSelected: Bool = false
        var isPizzaPuchasePresent: Bool = false
    }
    
    var body: some View {
        VStack {    // ScrollView 
            Text("피자 메뉴")
                .font(.pizzaBoldSmallTitle)
                .padding(.top, 20)
            
            Text("만들고 싶은 피자를 선택해주세요")
                .font(.pizzaRegularSmallTitle)
                .padding(.top, 10)
            
            LazyVGrid(columns: columns) {
                ForEach(selection.pizzas.indices, id: \.self) { index in
                    PizzaItemView(pizza: $selection.pizzas[safe: index] ?? .constant(.potato),
                                  currentPizza: $selection.currentPizza)
                    .frame(width: CGFloat.screenWidth / 3 - 40)
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        selectionLogic(index: index)
                    }
                }
            }
            Spacer()
        }
        .modeBackground()  // MARK: safe Area 까지 확장되는 이슈 [] 해겨
    }
    
    private func selectionLogic(index: Int) {
        
        selection.seletedPizza = selection.pizzas[safe: index] ?? .defaultPizza
        
        if selection.seletedPizza.lock {
            selection.isPizzaPuchasePresent.toggle()
        }
    }
}

struct PizzaItemView: View {
    
    @Binding var pizza: Pizza
    @Binding var currentPizza: Pizza
    
    var selectedTrigger: Bool {
        if currentPizza.name == pizza.name,
           !currentPizza.lock {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                if pizza.lock {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30, alignment: .center)
                        .zIndex(2)
                }
                
                Image("\(pizza.image)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                    .clipShape( Circle() )
                    .overlay {
                        Circle()
                            .fill(pizza.lock ? .black.opacity(0.4) : .clear )
                        if selectedTrigger {
                            Circle()
                                .stroke(Color.pickle, lineWidth: 3)
                        }
                    }
            }
            .frame(width: CGFloat.screenWidth / 3 - 40,
                   height: CGFloat.screenWidth / 3 - 40)
            
            Text("\(pizza.name)")
                .font(.pizzaDescription)
                .foregroundStyle(selectedTrigger ? Color.pickle : .primary)
                .tint(selectedTrigger ? .pickle : .primary)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
    }
}

#Preview {
    Text("daf")
//    PizzaSelectedView(columns: Array(repeating: .init(.flexible()), count: 3),
//                      pizzas: .constant( [Pizza(name: "고구마", 
//                                                image: "baconPotato",
//                                                lock: false,
//                                                createdAt: Date())]),
//                      seletedPizza: .constant(Pizza(name: "고구마", 
//                                                    image: "baconPotato",
//                                                    lock: false,
//                                                    createdAt: Date())), 
//                      currentPizza: .constant(.baconPotato)
//    )
}
