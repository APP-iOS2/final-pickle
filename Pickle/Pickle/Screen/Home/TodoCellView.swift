//
//  TodoCellView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

// TODO: 종료 시간 표시 여부, 재생 심볼 확정하기

import SwiftUI

struct TodoCellView: View {
    
    var todo: Todo
    
    @State var isShowingTimerView: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.quaternary)
                .frame(height: 80)
                .padding(.horizontal)
                .padding(.vertical, 4)
            
            HStack {

                VStack(alignment: .leading, spacing: 4) {
                    Text(todo.content)
                        .font(.pizzaBody)
                    
                    Text("\(todo.startTime.format("a h:mm")) (10분)")
//                    Text("\(startTime.format("a h:mm")) - \(startTime.adding(minutes: 10).format("a h:mm")) (10분)")
                        .font(.pizzaFootnote)
                }
                
                Spacer()
                
                Button {
                    isShowingTimerView = true
//                    TimerView(todo: todo)
//                        .backKeyModifier(visible: false)
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.clear)
                        
                        Image(systemName: "play.fill")
//                        Image(systemName: "play.circle")
//                            .font(.pizzaTitle2)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.horizontal, 40)
        }
        .fullScreenCover(isPresented: $isShowingTimerView) {
            TimerView(todo: todo, isShowingTimerView: $isShowingTimerView)
        }
    }
    
}

struct TodoCellView_Previews: PreviewProvider {
    static var previews: some View {

        TodoCellView(todo: Todo(id: UUID().uuidString,
                                content: "이력서 작성하기",
                                startTime: Date(),
                                targetTime: 3600,
                                spendTime: Date() + 5400,
                                status: .ready))
    }
}
