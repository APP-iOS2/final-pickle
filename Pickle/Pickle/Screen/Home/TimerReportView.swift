//
//  TimerReportView.swift
//  Pickle
//
//  Created by 여성은 on 2023/10/04.
//

import SwiftUI

struct TimerReportView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isShowingReportSheet: Bool
    @Binding var isComplete: Bool
    @Binding var isShowingTimerView: Bool
    
    var todo: Todo
    var spendTime: TimeInterval
    
    var body: some View {
        VStack {
            Text("대단해요! 피자 한 조각을 얻었어요!!🍕")
                .font(Font.pizzaHeadlineBold)
                .padding()
            
            Image("smilePizza")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .screenWidth * 0.75)

            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.quaternary)
                        .frame(height: 80)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    Group {
                        HStack {
                            Text("총 소요 시간")
                            Spacer()
                            Text(convertSecondsToTime(timeInSecond: Int(spendTime)))
                        }
                    }
                    .font(.pizzaTitle2Bold)
                    .padding(.horizontal, 40)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.quaternary)
                        .frame(height: 80)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    Group {
                        HStack {
                            Text("시작 시간")
                            Spacer()
                            Text("\(todo.startTime.format("a hh:mm"))")
                        }
                    }
                    .font(.pizzaTitle2Bold)
                    .padding(.horizontal, 40)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.quaternary)
                        .frame(height: 80)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    Group {
                        HStack {
                            Text("종료 시간")
                            Spacer()
                            Text("\((todo.startTime + spendTime).format("a hh:mm"))")
                        }
                    }
                    .font(.pizzaTitle2Bold)
                    .padding(.horizontal, 40)
                }
            }
            
            Button(action: {
                isShowingTimerView = false
                isShowingReportSheet = false
                dismiss()
            }, label: {
                Text("확인")
                    .font(.title3)
                    .bold()
                    .padding(.vertical, 8)
                    .frame(width: .screenWidth * 0.2)
                    .foregroundColor(.primary)
                    .colorInvert()
            })
            .buttonStyle(.borderedProminent)
            .tint(.primary)
        }
        .onAppear {
            isComplete = true
        }
    }
    func convertSecondsToTime(timeInSecond: Int) -> String {
        let hours = timeInSecond / 3600 // 시
        let minutes = (timeInSecond - hours*3600) / 60 // 분
        let seconds = timeInSecond % 60 // 초
        
        if timeInSecond >= 3600 {
            return String(format: "%02i시간 %02i분 %02i초", hours, minutes, seconds)
        } else {
            return String(format: "%02i분 %02i초", minutes, seconds)
        }
    }
}

struct TimerReportView_Previews: PreviewProvider {
    static var previews: some View {
        TimerReportView(isShowingReportSheet: .constant(false), isComplete: .constant(false), isShowingTimerView: .constant(false), todo: Todo(id: UUID().uuidString,
                                   content: "이력서 작성하기",
                                   startTime: Date(),
                                   targetTime: 60,
                                   spendTime: 5400,
                                   status: .ready),
                        spendTime: 603)
        
    }
}
