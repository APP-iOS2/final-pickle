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
    @Persisted var targetTime: Date
    @Persisted var spendTime: Date
    @Persisted var status: TodoStatusPersisted
//    @objc dynamic var heelo: String
    
    convenience init(content: String,
                     startTime: Date,
                     targetTime: Date,
                     spendTime: Date,
                     status: TodoStatusPersisted) {
        self.init()
        self.id = id
        self.content = content
        self.startTime = startTime
        self.targetTime = targetTime
        self.spendTime = spendTime
        self.status = status
    }
    
    class override func primaryKey() -> String? {
        "id"
    }
}

enum TodoStatusPersisted: String, PersistableEnum {
    case ready
    case ongoing
    case done
    case giveUp
}

extension TodoObject{
    static let todo: TodoObject = .init(value: ["id": ObjectId.generate(),
                                                "content": "안녕하세요",
                                                "startTime": Date(),
                                                "targetTime": Date(),
                                                "spendTime": Date(),
                                                "status": TodoStatus(rawValue: "ongoing")!.rawValue])
}
