//
//  TaskRowView.swift
//  Pickle
//
//  Created by kaikim on 2023/09/27.
//

import SwiftUI

struct TaskRowView: View {
    
    var task: Todo
    
    @AppStorage("is24HourClock") var is24HourClock: Bool = true
    @AppStorage("timeFormat") var timeFormat: String = "HH:mm"
    
    var indicatorColor: Color {
        return task.startTime.isSameHour && task.status == .ready ? .pickle : .primary
        //        {
        //            return .green
        //        }
        //        return task.creationDate.isSameHour ? .blue : (task.creationDate.isPastHour ? .red : .black)
    }
    
    var taskSymbol: Image {
        
        switch task.status {
        case .ready:
            return Image(systemName: "circle.dotted")
        case .done:
            return Image(systemName: "checkmark.circle.fill")
        case .giveUp:
            return Image(systemName: "xmark.circle.fill")
        default:
            return Image(systemName: "circle.dotted")
        }
    }
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 5) {
            taskSymbol
                .foregroundStyle(Color.pickle)
                .frame(width: 15, height: 15)
                .padding(4)
            //                    .background(.white)
            //    .background(.white, in: .circle)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(task.content)
                    .font(.pizzaStoreSmall)
                    .foregroundStyle(.primary)
                    .fontWeight(.regular)
                //.strikethrough(task.status == .giveUp, pattern: .solid, color: .black)
                
            }
            
            //                if task.startTime.isSameHour {
            //                    Text("이제 할일")
            //                        .font(.pizzaCaption)
            //                        .fontWeight(.semibold)
            //                        .foregroundStyle(indicatorColor)
            //                }
   
            Label(task.startTime.format(timeFormat), systemImage: "clock")
                .font(.caption)
                .foregroundColor(indicatorColor)
                .padding(.horizontal)
                .hSpacing(.trailing)
        }
        .onAppear {
            timeFormat = is24HourClock ? "HH:mm" : "a h:mm"
        }
        .hSpacing(.leading)
        
    }
}

#Preview {
    TaskRowView(task: Todo.sample)
}
