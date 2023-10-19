//
//  TaskRowView.swift
//  Pickle
//
//  Created by kaikim on 2023/09/27.
//

import SwiftUI

struct TaskRowView: View {
    
    var task: Todo

    var indicatorColor: Color {
        return task.startTime.isSameHour ? .pickle : .primary
//        {
//            return .green
//        }
//        return task.creationDate.isSameHour ? .blue : (task.creationDate.isPastHour ? .red : .black)
    }
    
    var taskColor: Color {
        
        switch task.status {
        case .ready:
            return Color.pickle.opacity(0.4)
        case .done:
            return Color.pickle
        case .giveUp:
            return Color.secondary
        default:
            return Color.primary
        }
    }

    var body: some View {
       
        HStack(alignment: .center, spacing: 15) {
                Circle()
                    .fill(taskColor)
                    .frame(width: 15, height: 15)
                    .padding(4)
//                    .background(.white)
                    .background(.white, in: .circle)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.content)
                        .font(.pizzaStoreSmall)
                        .foregroundStyle(taskColor)
                        .fontWeight(.regular)
                        //.strikethrough(task.status == .giveUp, pattern: .solid, color: .black)
                
                }
                
//                if task.startTime.isSameHour {
//                    Text("이제 할일")
//                        .font(.pizzaCaption)
//                        .fontWeight(.semibold)
//                        .foregroundStyle(indicatorColor)
//                }
                
                Label(task.startTime.format("HH:mm a"), systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(indicatorColor)
                    .padding(.horizontal)
                    .hSpacing(.trailing)
            }
            .hSpacing(.leading)
        
    }
}

#Preview {
    TaskRowView(task: Todo.sample)
}
