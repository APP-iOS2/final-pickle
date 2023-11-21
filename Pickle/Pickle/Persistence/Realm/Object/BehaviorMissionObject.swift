//
//  BehaviorMissionObject.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import Foundation
import RealmSwift

class BehaviorMissionObject: Object, MissionObject, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var status: TodoStatusPersisted
    @Persisted var status1: TodoStatusPersisted
    @Persisted var status2: TodoStatusPersisted
    @Persisted var date: Date  // 생성 날짜,시간
    
    convenience init(id: String,
                     title: String,
                     status: TodoStatusPersisted,
                     status1: TodoStatusPersisted,
                     status2: TodoStatusPersisted,
                     date: Date) {
        self.init()
        self.id = id
        self.title = title
        self.status = status
        self.status1 = status1
        self.status2 = status2
        self.date = date
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}

extension BehaviorMissionObject {
    static func allKeyPath() -> [PartialKeyPath<BehaviorMissionObject>] {
        [\.status,
          \.status1,
          \.status2,
          \.date]
    }
}
