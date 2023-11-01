//
//  TaskRowForSheetView.swift
//  Pickle
//
//  Created by kaikim on 2023/11/01.
//

import SwiftUI

struct TaskRowForSheetView: View {
    
    var tasks: [Todo]
    
    var body: some View {
        
        HStack {
            
            if tasks == [] {
                Text("✅")
                Text("오늘 할일을 추가해주세요")
                Spacer()
                Text("x" + " 0")
            } else {
                ForEach(tasks) { task in
                    Text("✅")
                    Text(task.content)
                        .foregroundStyle(.primary)
                        .fontWeight(.regular)
                    Spacer()
                    Text("x" + " 1")
                }
            }
        }
        .font(.nanumRg)
    }
}
//
//#Preview {
//    TaskRowForSheetView(task: Todo.sample)
//}
