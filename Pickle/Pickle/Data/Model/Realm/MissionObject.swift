//
//  MissionObject.swift
//  Pickle
//
//  Created by 박형환 on 9/27/23.
//

import Foundation
import RealmSwift

class TimeMissionObject: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var status: Status.RawValue
    @Persisted var wakeupTime: Date    // 기상 목표 시간
    
    override class func primaryKey() -> String? {
        "id"
    }
}

class BehaviorMissionObject: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var status: Status.RawValue
    @Persisted var myStep: Double      // 사용자 걸음수
    @Persisted var missionStep: Double // 미션 걸음수
    @Persisted var date: Date  // 투두 생성 날짜,시간
    
    override class func primaryKey() -> String? {
        "id"
    }
}
