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
