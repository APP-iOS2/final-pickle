//
//  TimerReportView.swift
//  Pickle
//
//  Created by 여성은 on 2023/10/04.
//

import SwiftUI

struct TimerReportView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var todoStore: TodoStore
    
    @Binding var isShowingReportSheet: Bool
    @Binding var isComplete: Bool
    @Binding var isShowingTimerView: Bool
    
    @AppStorage("is24HourClock") var is24HourClock: Bool = true
    @AppStorage("timeFormat") var timeFormat: String = "HH:mm"
    
    var todo: Todo
    
    var body: some View {
        VStack {
            // TODO: 60 *5 (5분)으로 바꾸기
            if todo.spendTime >= 60{
                Text("대단해요! 피자 한 조각을 얻었어요!!🍕")
                    .font(.pizzaBody)
                    .padding()
                
                Image("smilePizza")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .screenWidth * 0.75)
            } else {
                Text("다음에는 피자 조각을 얻어봐요")
                    .font(.pizzaBody)
                    .padding()
                Image("sadPizza")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .screenWidth * 0.75)
            }
            
            VStack {
                VStack {
                    Group {
                        HStack {
                            Text("목표 시간")
                            Spacer()
                            Text(convertSecondsToTime(timeInSecond: Int(todo.targetTime)))
                        }
                        HStack {
                            Text("소요 시간")
                            Spacer()
                            Text(convertSecondsToTime(timeInSecond: Int(todo.spendTime)))
                        }
                    }
                    .font(.pizzaBody)
                    .padding(.horizontal, 5)
                    .padding()
                }
                .clipShape(RoundedRectangle(cornerRadius: 12)) // clip corners
                .background(
                    RoundedRectangle(cornerRadius: 12) // stroke border
                        .stroke(.quaternary, lineWidth: 1)
                )
                .padding(.horizontal, .screenWidth * 0.1)
                .padding(.bottom)
                
                VStack {
                    Group {
                        HStack {
                            Text("시작 시간")
                            Spacer()
                            Text("\(todo.startTime.format(timeFormat))")
                        }
                        HStack {
                            Text("종료 시간")
                            Spacer()
                            Text("\((todo.startTime + todo.spendTime).format(timeFormat))")
                        }
                    }
                    .font(.pizzaBody)
                    .padding(.horizontal, 5)
                    .padding()
                }
                .clipShape(RoundedRectangle(cornerRadius: 12)) // clip corners
                .background(
                    RoundedRectangle(cornerRadius: 12) // stroke border
                        .stroke(.quaternary, lineWidth: 1)
                )
                .padding(.horizontal, .screenWidth * 0.1)
                .padding(.bottom)
                
            }
            
            Button(action: {
                isShowingTimerView = false
                isShowingReportSheet = false
                dismiss()
            }, label: {
                Text("확인")
                    .font(.pizzaBody)
                    .bold()
                    .padding(.vertical, 8)
                    .frame(width: .screenWidth * 0.2)
                    .foregroundColor(.primary)
                    .colorInvert()
            })
            .buttonStyle(.borderedProminent)
            .tint(.pickle)
        }
        .onAppear {
            isComplete = true
            timeFormat = is24HourClock ? "HH:mm" : "a h:mm"
        }
        .task {
            await todoStore.fetch()
        }
    }
    
    func convertSecondsToTime(timeInSecond: Int) -> String {
        let minutes = timeInSecond / 60 // 분
        return String(format: "%02i분 ", minutes)
        
    }
}

struct TimerReportView_Previews: PreviewProvider {
    static var previews: some View {
        TimerReportView(isShowingReportSheet: .constant(false),
                        isComplete: .constant(false),
                        isShowingTimerView: .constant(false),
                        todo: Todo(id: UUID().uuidString,
                                   content: "이력서 작성하기",
                                   startTime: Date(),
                                   targetTime: 60,
                                   spendTime: 5400,
                                   status: .ready))
        .environmentObject(TodoStore())
        
    }
}
