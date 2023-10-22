//
//  Mission.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/26.
//

import Foundation

protocol Mission: MappableProtocol {
    var id: String { get }
    var title: String { get }
    var status: MissionStatus { get }
    var date: Date { get }
}

struct TimeMission: Mission, Identifiable {
    let id: String
    let title: String
    var status: MissionStatus
    var date: Date // 타임미션 생성 날짜,시간 -> 생성날짜와 지금 날짜 비교해서 초기화할 때 쓸 것
    var wakeupTime: Date // 기상 목표 시간
    var changeWakeupTime: Date
    
    init(id: String = UUID().uuidString,
         title: String = "",
         status: MissionStatus = .ready,
         date: Date = Date(),
         wakeupTime: Date = Date(),
         changeWakeupTime: Date = Date()) {
        
        self.id = id
        self.title = title
        self.status = status
        self.date = date
        self.wakeupTime = wakeupTime
        self.changeWakeupTime = changeWakeupTime
    }
}

struct BehaviorMission: Mission, Identifiable {
    let id: String
    let title: String
    var status: MissionStatus
    var status1: MissionStatus
    var status2: MissionStatus
    var date: Date  // 투두 생성 날짜,시간
    
    init(id: String = UUID().uuidString,
         title: String = "",
         status: MissionStatus = .ready,
         status1: MissionStatus = .ready,
         status2: MissionStatus = .ready,
         date: Date = Date()) {
        self.id = id
        self.title = title
        self.status = status
        self.status1 = status1
        self.status2 = status2
        self.date = date
    }
}
