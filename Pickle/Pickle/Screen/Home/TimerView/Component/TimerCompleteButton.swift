//
//  TimerButton.swift
//  Pickle
//
//  Created by 박형환 on 1/16/24.
//

import SwiftUI
import PickleCommon

typealias DoneType = TimerCompleteButton.DoneType

struct TimerCompleteButton: View, Equatable {
    
    enum DoneType {
        case complete
        case pauseResume
        case giveUp
    }
    
    @Binding var state: TimerView.TimerState
    var action: (DoneType) -> Void
    
    var body: some View {
        HStack(spacing: 18) {
            // 완료 버튼
            timerButton(
                title: "완료",
                foreground: state.isDisabled ? .secondary : .green,
                background: state.isDisabled ? Color(.secondarySystemBackground) : Color(hex: 0xDAFFD9),
                isDisabled: state.isDisabled,
                opacity: state.isStart ? 0.5 : 1
            ) {
                action(.complete)
            }
            
            // 일시정지 / 재개 버튼
            timerButton(
                title: state.isPaused ? "재개" : "일시정지",
                foreground: state.isStart ? .secondary : .pickle,
                background: state.isStart ? Color(.secondarySystemBackground) : Color.pickle.opacity(0.18),
                isDisabled: state.isStart || state.isComplete,
                opacity: state.isStart ? 0.5 : 1
            ) {
                action(.pauseResume)
            }
            
            // 포기버튼
            timerButton(
                title: "포기",
                foreground: state.isStart ? .secondary : .red,
                background: state.isStart ? Color(.secondarySystemBackground) : Color(hex: 0xFFDBDB),
                isDisabled: state.isStart,
                opacity: state.isStart ? 0.5 : 1
            ) {
                action(.giveUp)
            }
        }
        .padding(.top, 10)
    }
    
    private func timerButton(title: String,
                             foreground: Color,
                             background: Color,
                             isDisabled: Bool,
                             opacity: Double,
                             action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.pizzaHeadline)
                .minimumScaleFactor(0.65)
                .lineLimit(1)
                .frame(width: 76, height: 76)
                .foregroundColor(foreground)
                .background(background)
                .clipShape(Circle())
        }
        .disabled(isDisabled)
        .opacity(opacity)
    }
    
    static func == (lhs: TimerCompleteButton, rhs: TimerCompleteButton) -> Bool {
        lhs.state.isStart == rhs.state.isStart && 
        lhs.state.isDisabled == rhs.state.isDisabled &&
        lhs.state.isPaused == rhs.state.isPaused
    }
}
