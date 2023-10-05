//
//  BehaviorMissionObject.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import Foundation
import RealmSwift

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
