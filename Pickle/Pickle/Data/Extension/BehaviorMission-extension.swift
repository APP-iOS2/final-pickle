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
        BehaviorMissionObject(id: self.id,
                              title: self.title,
                              status: .init(rawValue: self.status.value) ?? .ready,
                              status1: .init(rawValue: self.status1.value) ?? .ready,
                              status2: .init(rawValue: self.status2.value) ?? .ready,
                              date: self.date)
    }
    
    static func mapFromPersistenceObject(_ object: BehaviorMissionObject) -> BehaviorMission {
        BehaviorMission(id: object.id,
                        title: object.title,
                        status: .init(rawValue: object.status.rawValue) ?? .ready,
                        status1: .init(rawValue: object.status1.rawValue) ?? .ready,
                        status2: .init(rawValue: object.status2.rawValue) ?? .ready,
                        date: object.date)
    }
}

extension BehaviorMission {
    func updateStatus(_ status: MissionStatus) -> Self {
        BehaviorMission(id: self.id,
                        title: self.title,
                        status: status,
                        status1: status1,
                        status2: status2,
                        date: self.date)
    }
}
