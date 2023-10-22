//
//  AddTodoView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct AddTodoView: View {
    
    @EnvironmentObject var todoStore: TodoStore
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

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddTodoView(isShowingEditTodo: .constant(true),
                        todo: .constant(Todo.sample))
            .environmentObject(TodoStore())
        }
    }
}
