//
//  TimerReportView.swift
//  Pickle
//
//  Created by 여성은 on 2023/10/04.
//

import SwiftUI

struct TimerReportView: View {
    var body: some View {
        VStack {
            Text("대단해요! 피자 한 조각을 얻었어요!!🍕")
                .font(Font.pizzaHeadlineBold)
                .padding()
            
           ZStack {
               Rectangle()
                   .foregroundColor(Color.lightGray)
                   .padding()
               VStack(alignment: .leading) {
                   Text("총 소요시간")
                   Text("시작 시간")
                   Text("완료 시간")
               }
            }
        }
    }
}

struct TimerReportView_Previews: PreviewProvider {
    static var previews: some View {
        TimerReportView()
        
    }
}
