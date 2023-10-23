//
//  TodoStore.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import SwiftUI

//                              UserRepository                                            CoreData
// TodoStore --->-protocol-<-- TodoRepository ---상속---> BaseRepository --->protocol <--- RealmStore (입출력)
// MissionStore               MissionRepository                                           FireStore
@MainActor
final class TodoStore: ObservableObject {
    
    @Published var todos: [Todo] = []
    
    var readyTodos: [Todo] {
        todos.filter { $0.status == .ready && $0.startTime.isToday }
    }
    
    var complteTodos: [Todo] {
        todos.filter { $0.status == .complete }
    }
    
    var giveUpTodos: [Todo] {
        todos.filter { $0.status == .giveUp }
    }
    
    var ongoingTodos: [Todo] {
        todos.filter { $0.status == .ongoing }
    }
    
    var doneTodos: [Todo] {
        todos.filter { $0.status == .done }
    }
    /// 완료한 todos
    @Published var complteTask: Int = 0
    
    // MARK: DI - propertywrapper OR init, dicontainer
    //    struct Dependency {
    //        var todoRepository: TodoRepository
    //    }
    //    private let repository: TodoRepositoryProtocol
    //
    //    init(repository: TodoRepositoryProtocol) {
    //        self.repository = repository
    //    }
    //    @Injected var repository: TodoRepositoryProtocol
    
    @Injected(TodoRepoKey.self) var repository: TodoRepositoryProtocol
    @Injected(UserRepoKey.self) var userRepository: UserRepositoryProtocol
    
    func getSeletedTodo(id: String) -> Todo {
        if let todo = self.todos.filter { $0.id == id }.first {
            return todo
        } else {
            assert(false, "getSeleted Todo Failed")
        }
    }
    
    @discardableResult
    func fetch() async -> [Todo] {
        await withCheckedContinuation { continuation in
            repository.fetchTodo(sorted: Sorted(key: "startTime", ascending: true)) { value in
                self.todos = value
                continuation.resume(with: .success(value))
            }
        }
    }
    
    func add(todo: Todo) {
        do {
            try repository.saveTodo(todo: todo)
            todos.append(todo)
        } catch {
            Log.error("failed")
        }
    }
    
    func delete(todo: Todo) {                               // TODO: Delete가 실패 했을때 처리 해야함
        repository.deleteTodo(model: todo)                  // repository.deleteTodo(todo: todo)
        self.todos.removeAll(where: { $0.id == todo.id })
    }
    
    /// 전체 목록 Delete
    /// - Parameter todo: todo Struct
    func deleteAll(todo: Todo) {
        repository.deleteAll()
    }

    func update(todo: Todo) {
        repository.updateTodo(todo: todo)
    }
    
    func updateStatus(status: TodoStatus) {
        
    }
    
    /// 빈 모델 생성
    func create() {
        repository.create { value in
            Log.debug(value)
        }
    }
}
