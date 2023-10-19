//
//  TodoCellView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct TodoCellView: View {
    
    @AppStorage("is24HourClock") var is24HourClock: Bool = true
    @AppStorage("timeFormat") var timeFormat: String = "HH:mm"
    
    var todo: Todo
    
    @State var isShowingTimerView: Bool = false
        
    var body: some View {
        ZStack {
            HStack {

                VStack(alignment: .leading, spacing: 4) {
                    Text(todo.content)
                        .font(.pizzaBody)
                    
                    Text("\(todo.startTime.format(timeFormat)) (\(convertSecondsToTime(timeInSecond: Int(todo.targetTime))))")
                        .font(.pizzaFootnote)
                }
                
                Spacer()
                
                Button {
                    isShowingTimerView = true
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.clear)

                        Image(systemName: "play.fill")
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.horizontal)
            .frame(height: 80)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8)) // clip corners
            .background(
                RoundedRectangle(cornerRadius: 8) // stroke border
                    .stroke(Color.defaultGray, lineWidth: 2)
            )
//            .padding(.horizontal, 12)
        }
        .onAppear {
            timeFormat = is24HourClock ? "HH:mm" : "a h:mm"
        }
        .fullScreenCover(isPresented: $isShowingTimerView) {
            TimerView(todo: todo, isShowingTimerView: $isShowingTimerView)
        }
    }
    
    func convertSecondsToTime(timeInSecond: Int) -> String {
        let minutes = timeInSecond / 60 // 분
        return String(format: "%02i분", minutes)
        
    }
}

struct TodoCellView_Previews: PreviewProvider {
    static var previews: some View {

        TodoCellView(todo: Todo(id: UUID().uuidString,
                                content: "이력서 작성하기",
                                startTime: Date(),
                                targetTime: 3600,
                                spendTime: 5400,
                                status: .ready))
    }
}
