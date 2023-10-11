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

final class TodoStore: ObservableObject {
    
    @Published var todos: [Todo] = []
    
    // MARK: DI - propertywrapper OR init, dicontainer
    //    struct Dependency {
    //        var todoRepository: TodoRepository
    //    }
    //    private let repository: TodoRepositoryProtocol
    //
    //    init(repository: TodoRepositoryProtocol) {
    //        self.repository = repository
    //    }
    
    @Injected(TodoRepoKey.self) var repository: TodoRepositoryProtocol
    //    @Injected var repository: TodoRepositoryProtocol
    
    func getSeletedTodo(id: String) -> Todo {
        if let todo = self.todos.filter { $0.id == id }.first {
            return todo
        } else {
            assert(false, "getSeleted Todo Failed")
        }
    }
    
    @MainActor
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
        repository.saveTodo(todo: todo)
        todos.append(todo)
    }
    
    func delete(todo: Todo) {
//        repository.deleteTodo(todo: todo)
        repository.deleteTodo(model: todo)
        self.todos.removeAll(where: { $0.id == todo.id })
        // TODO: Delete가 실패 했을때 처리 해야함
    }
    
    /// 전체 목록 Delete
    /// - Parameter todo: todo Struct
    func deleteAll(todo: Todo) {
        repository.deleteAll()
    }
    
    func update(todo: Todo) {
        repository.updateTodo(todo: todo)
    }
    
    /// 빈 모델 생성
    func create() {
        repository.create { value in
            Log.debug(value)
        }
    }
}
