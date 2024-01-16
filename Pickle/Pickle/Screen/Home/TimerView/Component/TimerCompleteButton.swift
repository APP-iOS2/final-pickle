//
//  TimerButton.swift
//  Pickle
//
//  Created by 박형환 on 1/16/24.
//

import SwiftUI

struct TimerCompleteButton: View {
    
    @EnvironmentObject var timerVM: TimerViewModel
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var notificationManager: NotificationManager
    
    var todo: Todo
    @Binding var state: TimerView.TimerState
    @Binding var isRunTimer: Bool
    @Binding var backgroundNumber: Int
    
    var body: some View {
        HStack {
            // 완료 버튼
            Button {
                state.isComplete = true
                updateDone(spendTime: timerVM.spendTime)
                state.isShowingReportSheet = true
            } label: {
                Text("완료")
                    .font(.pizzaHeadline)
                    .frame(width: 75, height: 75)
                    .foregroundColor(state.isDisabled ? .secondary : .green)
                    .background(state.isDisabled ? Color(.secondarySystemBackground) : Color(hex: 0xDAFFD9))
                    .clipShape(Circle())
            }
            .disabled(state.isDisabled)
            .opacity(state.isStart ? 0.5 : 1)
            .padding([.leading, .trailing], 75)
            
            // 포기버튼
            Button(action: {
                state.isComplete = true
                state.isGiveupSign = true
                state.showingAlert = true
            }, label: {
                Text("포기")
                    .font(.pizzaHeadline)
                    .frame(width: 75, height: 75)
                    .foregroundColor(state.isStart ? .secondary : .red)
                    .background(state.isStart ? Color(.secondarySystemBackground) :Color(hex: 0xFFDBDB))
                    .clipShape(Circle())
            })
            .disabled(state.isStart)
            .opacity(state.isStart ? 0.5 : 1)
            .padding([.leading, .trailing], 75)
        }
        .padding(.top, 10)
    }
    
    // 완료 + 피자겟챠
    func updateDone(spendTime: TimeInterval) {
        let todo = Todo(id: todo.id,
                        content: todo.content,
                        startTime: state.realStartTime,
                        targetTime: todo.targetTime,
                        spendTime: spendTime,
                        status: .done)
        todoStore.update(todo: todo)
        timerVM.updateTodo(spendTime: spendTime, status: .done)
        isRunTimer = false
        backgroundNumber = 0
        
        do {
            try userStore.addPizzaSlice(slice: 1)
        } catch {
            Log.error("❌피자 조각 추가 실패❌")
        }
        
        if spendTime < todo.targetTime {
            todoStore.deleteNotificaton(todo: todo, noti: notificationManager)
        }
    }
}
