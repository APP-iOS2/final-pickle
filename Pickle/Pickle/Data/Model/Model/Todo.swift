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

extension Todo {
    static var sample: Todo = .init(id: UUID().uuidString,
                                    content: "오늘 할일을 추가해주세요",
                                    startTime: Date(),
                                    targetTime: 0,
                                    spendTime: 10,
                                    status: .done)
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
