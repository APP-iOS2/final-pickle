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
    @Persisted var status1: TodoStatusPersisted
    @Persisted var status2: TodoStatusPersisted
    @Persisted var date: Date  // 투두 생성 날짜,시간
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    convenience init(title: String, status: TodoStatusPersisted, status1: TodoStatusPersisted, status2: TodoStatusPersisted, date: Date) {
        self.init()
        self.title = title
        self.status = status
        self.date = date
    }
    
    convenience init(id: String, title: String, status: TodoStatusPersisted, status1: TodoStatusPersisted, status2: TodoStatusPersisted, date: Date) {
        self.init(title: title, status: status, status1: status1, status2: status2, date: date)
        self.id = try! ObjectId(string: id)
    }
}
