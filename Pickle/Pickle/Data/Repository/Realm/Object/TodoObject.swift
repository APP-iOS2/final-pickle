//
//  TodoObject.swift
//  Pickle
//
//  Created by 박형환 on 9/27/23.
//

import SwiftUI
import RealmSwift

class TodoObject: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var content: String
    @Persisted var startTime: Date
    @Persisted var targetTime: TimeInterval
    @Persisted var spendTime: TimeInterval
    @Persisted var status: TodoStatusPersisted
    
    convenience init(content: String,
                     startTime: Date,
                     targetTime: TimeInterval,
                     spendTime: TimeInterval,
                     status: TodoStatusPersisted) {
        self.init()
        self.content = content
        self.startTime = startTime
        self.targetTime = targetTime
        self.spendTime = spendTime
        self.status = status
    }
    
    convenience init(id: String,
                     content: String,
                     startTime: Date,
                     targetTime: TimeInterval,
                     spendTime: TimeInterval,
                     status: TodoStatusPersisted) {
        self.init(content: content,
                  startTime: startTime,
                  targetTime: targetTime,
                  spendTime: spendTime,
                  status: status)
        
        self.id = try! ObjectId(string: id)
    }
    
    class override func primaryKey() -> String? {
        "id"
    }
}

enum TodoStatusPersisted: String, PersistableEnum {
    case ready
    case ongoing
    case complete
    case done
    case giveUp
    case fail
}

extension TodoObject{
    static let todo: TodoObject = .init(value: ["id": ObjectId.generate(),
                                                "content": "안녕하세요",
                                                "startTime": Date(),
                                                "targetTime": 1000,
                                                "spendTime": Date(),
                                                "status": TodoStatus(rawValue: "ongoing")!.rawValue])
}
