//
//  PizzaSummaryView.swift
//  Pickle
//
//  Created by kaikim on 2023/10/18.
//

import SwiftUI

struct PizzaSummaryView: View {
    
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var userStore: UserStore
    
    var myTotalPizza: Int {
        return userStore.pizzaCount * 8 + Int(userStore.pizzaSlice)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                HStack {
                    myPizzaView()
                        .modifier(PizzaSummaryModifier())
                    
                    myPieceOfPizzaView()
                        .modifier(PizzaSummaryModifier())
                   
                }
                .padding(.horizontal)
                HStack {
                    myTotalSpendTimeForPizzaView()
                        .modifier(PizzaSummaryModifier())
                    // myPizzaCollectionView()
                }
                .padding(.horizontal)
            }

            Spacer()
            
                .task {
                    await todoStore.fetch()
                }
               
        }


        .navigationTitle("통계")
        
    }
    
    // MARK: - 나의 피자
    func myPizzaView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("나의 피자")
                    .font(.pizzaBoldSmallTitle)
                Text("\(userStore.pizzaCount) 판")
                    .font(.nanumEbTitle)
                    .foregroundStyle(Color.pickle)
                
            }
            Spacer()
        }
    }
    
    // MARK: - 나의 피자 조각, 8조각 완성하면 0으로 초기화 되어버림
    func myPieceOfPizzaView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("나의 피자 조각")
                    .font(.pizzaBoldSmallTitle)
                Text("\(myTotalPizza) 조각")
                    .font(.nanumEbTitle)
                    .foregroundStyle(Color.pickle)
            }
            Spacer()
            
        }
    }
    
    // MARK: - 피자 구운시간이 아니라 집중한 시간 -> SpendTime 활용하기, 시간이 왔다갔다 난리도 안임
    func myTotalSpendTimeForPizzaView() -> some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                
                Text("피자 구운 시간")
                    .font(.pizzaBoldSmallTitle)
                
                let tempResult = todoStore.todos.map { $0.spendTime }.reduce(0) { $0 + $1}
               // let _ =  print("\(tempResult)")
                let finalSpendTime = convertSecondsToTime(timeInSecond: tempResult)
                
                Text("\(finalSpendTime)")
                    .font(.nanumEbTitle)
                    .foregroundStyle(Color.pickle)
                
            }
            //  .padding()
            Spacer()
        }
        
        //.modifier(PizzaSummaryModifier())
    }
    
    // MARK: - 피자 컬렉션
    //    func myPizzaCollectionView() -> some View {
    //
    //
    //    }
    func convertSecondsToTime(timeInSecond: Double) -> String {
        let hours: Int = Int(timeInSecond / 3600)
        let minutes: Int = Int(timeInSecond - Double(hours) * 3600) / 60
        let seconds: Int = Int(timeInSecond.truncatingRemainder(dividingBy: 60))
        
        return String(format: "%02i시간 %02i분 %02i초", hours, minutes, seconds)
        
    }
}

struct PizzaSummaryModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(.clear)
            .frame(minWidth: 0, maxWidth: .infinity)
            .cornerRadius(20.0)
            .overlay(RoundedRectangle(cornerRadius: 20.0)
                .stroke(Color(.lightGray), lineWidth: 1))
//            .padding(.horizontal)
            .padding(.top, 15)
    }
}

#Preview {
    NavigationStack {
        PizzaSummaryView()
            .environmentObject(TodoStore())
            .environmentObject(UserStore())
    }
}
