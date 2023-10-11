//
//  BehaviorMissionObject.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import Foundation
import RealmSwift

class BehaviorMissionObject: Object, MissionObject, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var status: TodoStatusPersisted
    @Persisted var myStep: Double      // 사용자 걸음수
    @Persisted var missionStep: Double // 미션 걸음수
    @Persisted var date: Date  // 투두 생성 날짜,시간
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    convenience init(title: String, status: TodoStatusPersisted, myStep: Double, missionStep: Double, date: Date) {
        self.init()
        self.title = title
        self.status = status
        self.myStep = myStep
        self.missionStep = missionStep
        self.date = date
    }
    
    convenience init(id: String, title: String, status: TodoStatusPersisted, myStep: Double, missionStep: Double, date: Date) {
        self.init(title: title, status: status, myStep: myStep, missionStep: missionStep, date: date)
        self.id = try! ObjectId(string: id)
    }
}
