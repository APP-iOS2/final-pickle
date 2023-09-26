//
//  Mission.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/26.
//

import Foundation

protocol Mission {
    var title: String { get }
    var status: Status { get }
}

struct TimeMission: Mission {
    let title: String
    var status: Status
    var wakeupTime: Date    // 기상 목표 시간
}

struct BehaviorMission: Mission {
    let title: String
    var status: Status
    var myStep: Double      // 사용자 걸음수
    var missionStep: Double // 미션 걸음수
}
