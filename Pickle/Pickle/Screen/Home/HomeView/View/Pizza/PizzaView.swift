//
//  PizzaView.swift
//  Pickle
//
//  Created by 최소정 on 10/9/23.
//

import SwiftUI

struct PizzaView: View {
    
    var currentPizza: CurrentPizza
    
    var content: String {
        currentPizza.content
    }
    
    var taskPercentage: Double {
        currentPizza.taskPercentage // 0 ~ 1 사이 값이 들어옴 (바깥에서 퍼센트 계산을 해서 넣어주는 게 편함)
    }
    
    var pizza: Pizza {
        self.currentPizza.pizza ?? .defaultPizza
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("\(pizza.image)")
                    .resizable()
                    .scaledToFit()
                
                DotCircleView(content: content,
                              taskPercentage: taskPercentage)
                .fixSize(geo)
                .zIndex(1)
                
                Circle()
                    .trim(from: taskPercentage, to: 1)
                    .stroke(Color.primary, lineWidth: geo.size.width)
                    .colorInvert() // View 자체에 적용하는 메서드. View에 걸린 모든 컬러를 뒤집음
                    .rotationEffect(.degrees(-90))
            }
        }
    }
}

#Preview {
    PizzaView(currentPizza: .init(pizza: .defaultPizza))
}
