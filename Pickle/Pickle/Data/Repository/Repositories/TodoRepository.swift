//
//  TodoRepository.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import Foundation

protocol TodoRepositoryProtocol: Dependency {
    func fetchTodo(sorted: Sorted, _ completion: @escaping ([Todo]) -> Void)
    func create(_ completion: @escaping (TodoObject) -> Void)
    func saveTodo(todo: Todo)
    func deleteTodo(todo: Todo)
    func deleteTodo(model: Todo)
    func deleteAll()
    func updateTodo(todo: Todo)
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
    
    func create(_ completion: @escaping (TodoObject) -> Void) {
        do {
            try super.create(TodoObject.self) { completion($0) }
        } catch {
            Log.error("error: \(error)")
        }
    }
    
    func saveTodo(todo: Todo) {
        Log.debug("todoValue : \(todo)")
        let object = todo.mapToPersistenceObject()
        
        do {
            try super.save(object: object)
        } catch {
            Log.error("error \(error)")
        }
//        do {  try super.save(object: object) }
//        catch { Log.error("error \(error)") }
    }
    
    func deleteTodo(todo: Todo) {
        Log.debug("todoValue : \(todo)")
        let object = todo.mapToPersistenceObject()
        do {
            try super.delete(object: object)
        } catch {
            Log.error("error \(error)")
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
    
    func updateTodo(todo: Todo) {
        let object = todo.mapToPersistenceObject()
        do {
            try super.update(object: object)
        } catch {
            Log.error("error: \(error)")
        }
    }
}

