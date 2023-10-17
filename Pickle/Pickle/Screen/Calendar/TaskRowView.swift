//
//  TaskRowView.swift
//  Pickle
//
//  Created by kaikim on 2023/09/27.
//

import SwiftUI

struct TaskRowView: View {
    
    var task: CalendarSampleTask
    
    var indicatorColor: Color {
        if task.isCompleted {
            return .green
        }
        return task.creationDate.isSameHour ? .blue : (task.creationDate.isPastHour ? .red : .black)
    }
    var body: some View {
       
            HStack(alignment: .top, spacing: 15) {
                
                Circle()
                    .fill(indicatorColor)
                    .frame(width: 10, height: 10)
                    .padding(4)
                    .background(.white)
                    .background(.white.shadow(.drop(color: .black.opacity(0.1),radius: 3)), in: .circle)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.calendarTitle)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .strikethrough(task.isCompleted, pattern: .solid, color: .black)
                    
                }
                
                if task.creationDate.isSameHour {
                    Text("이제 할일")
                        .font(.pizzaCaption)
                        .foregroundStyle(.primary)
                }
                
                Label(task.creationDate.format("HH:mm a"), systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .hSpacing(.trailing)
            }
            .hSpacing(.leading)
        
    }
}

#Preview {
    CalendarView()
}
