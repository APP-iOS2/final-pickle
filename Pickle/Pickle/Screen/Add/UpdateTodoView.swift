//
//  AddTodoView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct UpdateTodoView: View {
    
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var notificationManager: NotificationManager
    @Binding var isShowingEditTodo: Bool
    @Binding var todo: Todo
    @State private var successDelete: Bool = false

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                RegisterView(willUpdateTodo: $todo,
                             successDelete: $successDelete,
                             isShowingEditTodo: $isShowingEditTodo,
                             isModify: true)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingEditTodo.toggle()
                    } label: {
                        Text("닫기")
                            .tint(.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        todoStore.delete(todo: todo)
                        
                        //4번 할일이 삭제 되었을 경우, 해당 등록된 알림도 삭제해야함. 해당 할일의 아이디 넣어줘야함
                        notificationManager.removeSpecificNotification(id: [todo.id])
                        
                        successDelete.toggle()
                    } label: {
                        Text("삭제")
                            .tint(.red)
                    }
                }
            }
        }
    }
}

struct UpdateTodoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UpdateTodoView(isShowingEditTodo: .constant(true),
                        todo: .constant(Todo.sample))
            .environmentObject(TodoStore())
        }
    }
}
