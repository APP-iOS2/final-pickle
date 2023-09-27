//
//  TodoObject.swift
//  Pickle
//
//  Created by 박형환 on 9/27/23.
//

import Foundation
import RealmSwift

class TodoObject: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var content: String
    @Persisted var startTime: Date
    @Persisted var targetTime: Date
    @Persisted var spendTime: Date
    @Persisted var status: String
    
    class override func primaryKey() -> String? {
        "id"
    }
}

extension TodoObject {
    static let todo: TodoObject = .init(value: ["id": ObjectId.generate(),
                                                "content": "안녕하세요",
                                                "startTime": Date(),
                                                "targetTime": Date(),
                                                "spendTime": Date(),
                                                "status": TodoStatus(rawValue: "ongoing")!.rawValue])
}
