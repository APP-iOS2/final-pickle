//
//  Todo.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/26.
//

import Foundation

struct Todo: Identifiable {
    let id: String
    var content: String
    var startTime: Date     // 시작 시간 (15시부터)
    var targetTime: Date    // 목표 시간 (16시까지)
    var spendTime: Date     // 실제 종료 시간 (16시반까지)
    var status: Status
}

typealias TodoStatus = Status
enum Status: String {
    // 진행전 진행중 완료 포기
    case ready
    case ongoing
    case done
    case giveUp
}

let sampleTodoList: [Todo] = [
    Todo(id: UUID().uuidString,
         content: "이력서 작성하기",
         startTime: Date(),
         targetTime: Date() + 3600,
         spendTime: Date() + 5400,
         status: .ready),
    Todo(id: UUID().uuidString,
         content: "ADS 작성하기",
         startTime: Date(),
         targetTime: Date() + 1800,
         spendTime: Date() + 1800,
         status: .ready),
    Todo(id: UUID().uuidString,
         content: "Readme 작성하기",
         startTime: Date(),
         targetTime: Date() + 5400,
         spendTime: Date() + 3600,
         status: .ready),
]
