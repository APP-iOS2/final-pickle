//
//  PizzaDescriptionView.swift
//  Pickle
//
//  Created by 박형환 on 1/12/24.
//

import SwiftUI

struct PizzaSliceDescriptionView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @EnvironmentObject var userStore: UserStore
    @State private var animatedText = ""
    @State private var currentIndex = 0
    private let fullText = "할일을 완료하고 피자를 모아보아요"
    
    var body: some View {
        VStack(spacing: 0) {
            Text("\(viewModel.currentPositionPizza.pizza?.name ?? "N/A")")
                .font(.pizzaStoreMiddle)
                .padding(.bottom, 10)
            
            #if DEBUG
            tempButton
            #endif
            
            Text("\(viewModel.currentPositionPizza.pizzaTaskSlice)")
                .font(.chab)
                .foregroundStyle(Color.pickle)
            
            Text(animatedText)
                .font(.pizzaHeadline)
                .onAppear {
                    currentIndex = 0
                    animatedText = ""
                    startTyping()
                }
                .padding(.vertical, 8)
                .padding(.bottom, 20)
        }
        .padding(.horizontal)
    }
    
    private var tempButton: some View {
        Button("할일 완료") {
            withAnimation {
                do {
                    try userStore.addPizzaSlice(slice: 1)
                } catch {
                    Log.error("❌피자 조각 추가 실패❌")
                }
            }
        }
        .foregroundStyle(.secondary)
    }
    
    private func startTyping() {
        if currentIndex < fullText.count {
            let index = fullText.index(fullText.startIndex, offsetBy: currentIndex)
            animatedText.append(fullText[index])
            currentIndex += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                startTyping()
            }
        }
    }
}
