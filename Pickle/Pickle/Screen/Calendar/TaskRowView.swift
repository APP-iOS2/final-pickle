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
    var body: some View {
       
        HStack(alignment: .center, spacing: 15) {
//            switch task.status {
//            case .ready:
//                
//            case .ongoing:
//                
//            case .giveUp:
//                
//            case .done,.complete:
//  
//            }
                Circle()
                    .fill(indicatorColor)
                    .frame(width: 15, height: 15)
                    .padding(4)
                    .background(.white)
                    .background(.white.shadow(.inner(color: .primary, radius: 3)), in: .circle)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.content)
                        .font(.pizzaStoreSmall)
                        .fontWeight(.regular)
                        .strikethrough(task.status == .complete, pattern: .solid, color: .black)
                
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
