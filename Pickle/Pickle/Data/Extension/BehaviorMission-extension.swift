//
//  BehaviorMission-extension.swift
//  Pickle
//
//  Created by 박형환 on 10/18/23.
//

import Foundation

extension BehaviorMission {
    typealias PersistenceType = BehaviorMissionObject
    
    func mapToPersistenceObject() -> BehaviorMissionObject {
        if let id = UUID(uuidString: self.id) {
            return BehaviorMissionObject(title: self.title,
                                         status: .init(rawValue: self.status.value) ?? .ready,
                                         date: self.date)
        } else {
            return BehaviorMissionObject(id: self.id,
                                         title: self.title,
                                         status: .init(rawValue: self.status.value) ?? .ready,
                                         date: self.date)
        }
    }
    
    static func mapFromPersistenceObject(_ object: BehaviorMissionObject) -> BehaviorMission {
        BehaviorMission(id: object.id.stringValue,
                        title: object.title,
                        status: .init(rawValue: object.status.rawValue) ?? .ready,
                        status2: .init(rawValue: object.status.rawValue) ?? .ready,
                        status3: .init(rawValue: object.status.rawValue) ?? .ready,
                        date: object.date)
    }
}

extension BehaviorMission {
    func updateStatus(_ status: MissionStatus) -> Self {
        BehaviorMission(id: self.id,
                        title: self.title,
                        status: status,
                        status2: status,
                        status3: status,
                        date: self.date)
    }
}
