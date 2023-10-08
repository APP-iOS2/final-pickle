//
//  AddTodoView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct AddTodoView: View {
    @Binding var isShowingEditTodo: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                RegisterView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingEditTodo = false
                    } label: {
                        Text("닫기")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingEditTodo = false
                    } label: {
                        Text("수정")
                    }
                }
            }
        }
    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddTodoView(isShowingEditTodo: .constant(true))
        }
    }
}
