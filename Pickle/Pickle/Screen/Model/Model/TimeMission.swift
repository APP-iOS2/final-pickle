//
//  TimeMission.swift
//  Pickle
//
//  Created by 박형환 on 11/13/23.
//

import Foundation

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

extension TimeMission: Equatable { }
