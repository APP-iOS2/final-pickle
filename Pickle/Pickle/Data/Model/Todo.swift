//
//  Todo.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/26.
//

import Foundation
import RealmSwift

struct Todo: Identifiable {
    let id: String
    var content: String
    var startTime: Date     // 시작 시간 (15시부터)
    var targetTime: TimeInterval    // 목표 소요 시간 ex) 30분
    var spendTime: TimeInterval     // 실제 소요 시간 ex) 32분
    var status: TodoStatus
}

extension Todo: Equatable {
    func isEqualContent(todo: Self) -> Bool {
        self.content == todo.content &&
        self.startTime == todo.startTime &&
        self.targetTime == todo.targetTime
    }
    
    func isNotPersisted() -> Bool {
        self.id == ""
    }
}

typealias TodoStatus = Status
typealias MissionStatus = Status

enum Status: String {
    // 진행전 진행중 완료 포기
    case ready
    case ongoing
    case done
    case giveUp
    
    var value: String {
        self.rawValue
    }
    
    var string: String {
        switch self {
        case .ready:
            return "아직"
        case .ongoing:
            return "진행중"
        case .done:
            return "완료"
        case .giveUp:
            return "포기"
        }
    }
}

extension Todo: MappableProtocol {
    
    typealias PersistenceType = TodoObject
    
    func mapToPersistenceObject() -> TodoObject {
        if let id = UUID(uuidString: self.id) {
            return TodoObject(content: self.content,
                              startTime: self.startTime,
                              targetTime: self.targetTime, //self.targetTime,
                              spendTime: self.spendTime,
                              status: TodoStatusPersisted(rawValue: self.status.value) ?? .ready)
        } else {
            return TodoObject(id: self.id,
                              content: self.content,
                              startTime: self.startTime,
                              targetTime: self.targetTime, //self.targetTime,
                              spendTime: self.spendTime,
                              status: TodoStatusPersisted(rawValue: self.status.value) ?? .ready)
        }
    }
    
    static func mapFromPersistenceObject(_ object: TodoObject) -> Todo {
        let todo: Todo = Todo(id: object.id.stringValue,
                              content: object.content,
                              startTime: object.startTime,
                              targetTime: object.targetTime,
                              spendTime: object.spendTime,
                              status: TodoStatus(rawValue: object.status.rawValue) ?? .ready)
        return todo
    }
}

extension Todo {
    static var sample: Todo = .init(id: "",
                                    content: "",
                                    startTime: Date(),
                                    targetTime: 0,
                                    spendTime: 10,
                                    status: .ready)
}
let sampleTodoList: [Todo] = [
    Todo(id: UUID().uuidString,
         content: "이력서 작성하기",
         startTime: Date(),
         targetTime: 3600,
         spendTime: 5400,
         status: .ready),
    Todo(id: UUID().uuidString,
         content: "ADS 작성하기",
         startTime: Date(),
         targetTime: 1800,
         spendTime: 1800,
         status: .ready),
    Todo(id: UUID().uuidString,
         content: "Readme 작성하기",
         startTime: Date(),
         targetTime: 5400,
         spendTime: 3600,
         status: .ready),
]
