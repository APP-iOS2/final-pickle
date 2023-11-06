//
//  TodoRepository.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import Foundation
import Combine

protocol TodoRepositoryProtocol: Dependency {
    func fetchTodo(sorted: Sorted, _ completion: @escaping ([Todo]) -> Void)
    func create(item: Todo, _ completion: @escaping (TodoObject) -> Void)
    func saveTodo(todo: Todo) -> TodoObject
    func deleteTodo(model: Todo)
    func deleteAll()
    func updateTodo(todo: Todo) -> TodoObject
    
    func fetcthFuture<T: Storable>(model: T.Type) -> Future<[T], Error>
}


final class TodoRepository: BaseRepository<TodoObject>, TodoRepositoryProtocol {
    
    func fetchTodo(sorted: Sorted = Sorted(key: "startTime", ascending: true), _ completion: @escaping ([Todo]) -> Void) {
        // MARK: Example -> NSPredicate(format: "id == %@", id)
        // MARK: Example -> Sorted(key: <#T##String#>, ascending: <#T##Bool#>)
        super.fetch(TodoObject.self, predicate: nil, sorted: sorted) {
            let value = $0
            let todos = value.map { Todo.mapFromPersistenceObject($0) }
            completion(todos)
        }
    }
    
    func create(item: Todo, _ completion: @escaping (TodoObject) -> Void) {
        let object = item.mapToPersistenceObject()
        do {
            try super.create(TodoObject.self, item: object) { completion($0) }
        } catch {
            Log.error("error: \(error)")
        }
    }
    
    func saveTodo(todo: Todo) -> TodoObject {
        let object = todo.mapToPersistenceObject()
        
        do {
            try super.save(object: object)
            return object
        } catch {
            Log.error("error \(error)")
            assert(false)
        }
    }
    
    func deleteTodo(model: Todo) {
        let id = model.id
        let object = model.mapToPersistenceObject()
        do {
            try super.delete(object: object, id: id)
        } catch {
            Log.error("error \(error)")
        }
    }
    
    func deleteAll() {
        do {
            try super.deleteAll(TodoObject.self)
        } catch {
            Log.error("error: \(error)")
        }
    }
    
    func updateTodo(todo: Todo) -> TodoObject {
        let object = todo.mapToPersistenceObject()
        do {
            try super.update(object: object)
            return object
        } catch {
            Log.error("error: \(error)")
            assert(false)
        }
    }
    
    func fetcthFuture<T: Storable>(model: T.Type) -> Future<[T], Error> {
        Future<[T], Error> { promise in
            DispatchQueue(label: "Custom Queue").async {
                do {
                    let value = try super.dbStore.fetch(model, predicate: nil, sorted: nil)
                    promise(.success(value))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
