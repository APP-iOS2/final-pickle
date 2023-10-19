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
                            .tint(.primary)
                    }
                }
            }
            .successAlert(
                isPresented: $successDelete,
                title: "삭제 성공",
                alertContent: "성공적으로 수정했습니다",
                primaryButtonTitle: "뒤로가기",
                primaryAction: { isShowingEditTodo.toggle() }
            )
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
