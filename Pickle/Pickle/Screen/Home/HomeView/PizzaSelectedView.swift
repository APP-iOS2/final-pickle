//
//  PizzaSelectedView.swift
//  Pickle
//
//  Created by 박형환 on 10/14/23.
//

import SwiftUI

struct PizzaSelectedView: View {
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    @Binding var pizzas: [Pizza]
    @Binding var seletedPizza: Pizza
    @Binding var isPizzaPuchasePresented: Bool
    
    var body: some View {
        VStack {    // ScrollView 
            Text("피자 메뉴")
                .font(.pizzaBoldSmallTitle)
                .padding(.top, 20)
            
            Text("만들고 싶은 피자를 선택해주세요")
                .font(.pizzaRegularSmallTitle)
                .padding(.top, 10)
            
            LazyVGrid(columns: columns) {
                ForEach(pizzas.indices, id: \.self) { index in
                    PizzaItemView(pizza: $pizzas[safe: index] ?? .constant(.potato))
                    .frame(width: CGFloat.screenWidth / 3 - 40)
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        seletedPizza = pizzas[safe: index] ?? .defaultPizza
                        isPizzaPuchasePresented.toggle()
                    }
                }
            }
            Spacer()
        }
        .modeBackground()  // MARK: safe Area 까지 확장되는 이슈 [] 해겨
    }
}

struct PizzaItemView: View {
    
    @Binding var pizza: Pizza
    
    var body: some View {
        VStack {
            ZStack {
                if pizza.lock {
                    Image(systemName: "lock.fill")
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
                    }
            }
            .frame(width: CGFloat.screenWidth / 3 - 40,
                   height: CGFloat.screenWidth / 3 - 40)
            
            Text("\(pizza.name)")
                .font(.pizzaDescription)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
    }
}

#Preview {
    PizzaSelectedView(columns: Array(repeating: .init(.flexible()), count: 3),
                      pizzas: .constant( [Pizza(name: "고구마", image: "baconPotato", lock: false, createdAt: Date())]),
                      seletedPizza: .constant(Pizza(name: "고구마", image: "baconPotato", lock: false, createdAt: Date())),
                      isPizzaPuchasePresented: .constant(false))
}
