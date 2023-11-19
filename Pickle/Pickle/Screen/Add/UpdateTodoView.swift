//
//  AddTodoView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct UpdateTodoView: View {
    
    struct Selection {
        var isShowing: Bool = false
        var seleted: Todo = Todo.sample
    }
    
    @EnvironmentObject var navigationStore: NavigationStore
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var notificationManager: NotificationManager
    
    @Binding var selection: Selection
    @State private var successDelete: Bool = false
    
    var body: some View {
        NavigationStack {
            RegisterView(willUpdateTodo: $selection.seleted,
                         successDelete: $successDelete,
                         isShowingEditTodo: $selection.isShowing,
                         isModify: true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        navigationStore.dismiss(home: .isShowingEditTodo(false, selection.seleted))
                    } label: {
                        Text("닫기")
                            .tint(.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        todoStore.delete(todo: selection.seleted)
                        todoStore.deleteNotificaton(todo: selection.seleted, noti: notificationManager)
                        
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
            UpdateTodoView(selection: .constant(.init()))
            .environmentObject(TodoStore())
        }
    }
}
