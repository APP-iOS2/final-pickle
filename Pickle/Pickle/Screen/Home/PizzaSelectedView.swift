//
//  PizzaSelectedView.swift
//  Pickle
//
//  Created by 박형환 on 10/14/23.
//

import SwiftUI

struct PizzaSelectedView: View {
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    let tempNames: [String] = ["포테이토 피자",
                               "하와이안 피자",
                               "페퍼로니 피자",
                               "치즈 피자",
                               "고구마 피자",
                               "루꼴라 피자"]
    
    private let images: [String] = []
    
    @Binding var isPresented: Bool
    
    var body: some View {
        //        ScrollView {
        VStack {
            Text("피자 메뉴")
                .font(.pizzaBoldSmallTitle)
                .padding(.top, 20)
            
            Text("만들고 싶은 피자를 선택해주세요")
                .font(.pizzaRegularSmallTitle)
                .padding(.top, 10)
            
            LazyVGrid(columns: columns) {
                ForEach((0...5), id: \.self) { value in
                    PizzaItemView(pizzaImage: "potatoPizza",
                                  pizzaName: tempNames[value])
                    .frame(width: CGFloat.screenWidth / 3 - 40)
                    .padding(.horizontal, 10)
                    .onTapGesture { isPresented.toggle() }
                }
            }
            Spacer()
        }
        .background(Color.white, ignoresSafeAreaEdges: []) //MARK: safe Area 까지 확장되는 이슈 [] 해겨
    }
}

struct PizzaItemView: View {
    
    let pizzaImage: String
    let pizzaName: String
    
    var body: some View {
        VStack {
            ZStack {
                Image("lock.fill")
                    .frame(width: 30, height: 30, alignment: .center)
                    .zIndex(1)
                
                Image("\(pizzaImage)")
                    .resizable()
                    .renderingMode(.template)
                    .opacity(0.4)
                    .scaledToFit()
            }
            Text("\(pizzaName)")
                .font(.pizzaDescription)
        }
    }
}
