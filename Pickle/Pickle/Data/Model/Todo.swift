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
    var startTime: Date     // 시작 시간 (15시)
    var targetTime: Date    // 목표 시간 (30분)
    var spendTime: Date     // 실제 소요 시간 (35분)
    var status: Status
}

enum Status: String {
    // 진행전 진행중 완료 포기
    case ready
    case ongoing
    case done
    case giveUp
}
