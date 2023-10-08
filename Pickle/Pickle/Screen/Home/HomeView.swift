//
//  HomeView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/25.
//

import SwiftUI

struct HomeView: View {
    @State private var goalProgress: Double = 0.0
    @State private var userTotalPizza: Int = 0 // 사용자 프로퍼티로 추가 필요
    @State private var pizzaText: String = "첫 피자를 만들어볼까요?"
    @State private var tabBarVisibility: Visibility = .visible
    @State private var isShowingEditTodo: Bool = false
    let goalTotal: Double = 8
    
    @EnvironmentObject var todoStore: TodoStore
    
    var body: some View {
        ScrollView {
            PizzaView(taskPercentage: goalProgress/goalTotal)
                .frame(width: 200, height: 200)
                .padding()
            
            // MARK: 테스트용, 추후 삭제
            Button("할일 완료") {
                if goalProgress < 8 {
                    withAnimation {
                        goalProgress += 1
                    }
                } else {
                    userTotalPizza += 1
                    goalProgress = 0
                }
            }
            .foregroundStyle(.secondary)
            
            VStack(spacing: 8) {
                Text("\(Int(goalProgress)) / \(Int(goalTotal))")
                    .font(.pizzaTitleBold)
                
                Text(pizzaText)
                    .font(.pizzaHeadline)
                
                ProgressView(value: goalProgress, total: goalTotal)
                    .progressViewStyle(LinearProgressViewStyle(tint: .primary))
                    .padding()
            }
            .padding(.horizontal)
            
            // MARK: 편집 일단 풀시트로 올라오게 했는데 네비게이션 링크로 바꿔도 댐
            ForEach(todoStore.todos, id: \.id) { todo in
                TodoCellView(todo: todo)
                    .onTapGesture {
                        isShowingEditTodo = true
                    }
            }
        }
        .task {
            await todoStore.fetch()
        }
        .navigationTitle(Date().format("MM월 dd일 EEEE"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarBuillder
        }
        .toolbar(tabBarVisibility, for: .tabBar)
        .fullScreenCover(isPresented: $isShowingEditTodo) {
            AddTodoView(isShowingEditTodo: $isShowingEditTodo)
        }
    }
    
    @ToolbarContentBuilder
    var toolbarBuillder: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink {
                RegisterView()
                    .backKeyModifier(visible: false)
            } label: {
                Image(systemName: "plus.circle")
                    .foregroundColor(.primary)
            }
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink {
                MissionView()
                    .backKeyModifier(visible: false)
            } label: {
                // TODO: 다크모드 대응
                Image("mission")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(TodoStore())
    }
}
