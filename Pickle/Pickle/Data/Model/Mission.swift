//
//  Mission.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/26.
//

import Foundation

protocol Mission: MappableProtocol {
    var title: String { get }
    var status: MissionStatus { get }
    var date: Date { get }
}

struct TimeMission: Mission {
    let title: String
    var status: MissionStatus
    var date: Date // 타임미션 생성 날짜,시간 -> 생성날짜와 지금 날짜 비교해서 초기화할 때 쓸 것
    var wakeupTime: Date // 기상 목표 시간
    
    init(title: String = "", status: MissionStatus = .ready, date: Date = Date(), wakeupTime: Date = Date()) {
        self.title = title
        self.status = status
        self.date = date
        self.wakeupTime = wakeupTime
    }
}

struct BehaviorMission: Mission {
    let title: String
    var status: MissionStatus
    var date: Date  // 투두 생성 날짜,시간
    var myStep: Double      // 사용자 걸음수
    var missionStep: Double // 미션 걸음수
    
    init(title: String = "", status: MissionStatus = .ready, date: Date = Date(), myStep: Double = 0, missionStep: Double = 0) {
        self.title = title
        self.status = status
        self.date = date
        self.myStep = myStep
        self.missionStep = missionStep
    }
}

extension TimeMission {
    typealias PersistenceType = TimeMissionObject
    
    func mapToPersistenceObject() -> TimeMissionObject {
        TimeMissionObject(title: self.title,
                          status: .init(rawValue: self.status.value) ?? .ready,
                          date: self.date,
                          wakeupTime: self.wakeupTime)
    }
    
    static func mapFromPersistenceObject(_ object: TimeMissionObject) -> TimeMission {
        TimeMission(title: object.title,
                    status: .init(rawValue: object.status.rawValue) ?? .ready,
                    date: object.date,
                    wakeupTime: object.wakeupTime)
    }
}

extension BehaviorMission {
    typealias PersistenceType = BehaviorMissionObject
    
    func mapToPersistenceObject() -> BehaviorMissionObject {
        BehaviorMissionObject(title: self.title,
                              status: .init(rawValue: self.status.value) ?? .ready,
                              myStep: self.myStep,
                              missionStep: self.missionStep,
                              date: self.date)
    }
    
    static func mapFromPersistenceObject(_ object: BehaviorMissionObject) -> BehaviorMission {
        BehaviorMission(title: object.title,
                        status: .init(rawValue: object.status.rawValue) ?? .ready,
                        date: object.date,
                        myStep: object.myStep,
                        missionStep: object.missionStep)
    }
}
