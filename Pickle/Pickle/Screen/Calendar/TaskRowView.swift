//
//  TaskRowView.swift
//  Pickle
//
//  Created by kaikim on 2023/09/27.
//

import SwiftUI

struct TaskRowView: View {
    
    @State private var isShowingReportSheet: Bool = false
    @AppStorage("is24HourClock") private var is24HourClock: Bool = true
    @AppStorage("timeFormat") private var timeFormat: String = "HH:mm"
    
    var task: Todo
    var indicatorColor: Color {
        switch task.status {
        case .done:
            return .pickle
        case .giveUp:
            return .gray
        default:
            return .pickle
        }
    }
    
    var taskSymbol: Image {
        switch task.status {
        case .done:
            return Image(systemName: "checkmark.circle.fill")
        case .giveUp:
            return Image(systemName: "xmark.circle.fill")
        default:
            return Image(systemName: "circle.dotted")
        }
    }
    
    var body: some View {
        
        if task.status == .done || task.status == .giveUp {
            
            Button {
                isShowingReportSheet = true
            } label: {
                taskRowView
            }
            .foregroundColor(.primary)
            
        } else { taskRowView }
    }
    
    @ViewBuilder
    private var taskContent: some View {
            Text(task.content)
                .font(.callout)
                .fontWeight(.light)
    }
    
    @ViewBuilder
    private var taskRowView: some View {
        HStack(alignment: .center) {
            taskSymbol
                .font(.caption)
                .foregroundStyle(indicatorColor)
            
            taskContent
                    
            HStack {
                if task.status == .ready && task.startTime.isSameHour {
                    Image(systemName: "clock.badge")
                        .foregroundColor(.pickle)
                }
                Text(task.startTime.format(timeFormat))
            }
                .font(.caption)
                .padding(.horizontal)
                .hSpacing(.trailing)
                .frame(maxWidth: .infinity)
  
        }
        .onAppear {
            timeFormat = is24HourClock ? "HH:mm" : "a h:mm"
        }
        .hSpacing(.leading)
        .padding(.bottom, 5)
        .padding(.leading, 18)
        .padding(.trailing, 5)
        
        .sheet(isPresented: $isShowingReportSheet) {
            TimerReportView(isShowingReportSheet: $isShowingReportSheet,
                            isShowingTimerView: .constant(false),
                            todo: task)
        }
        
    }
    
}

#Preview {
    TaskRowView(task: Todo.sample)
}
