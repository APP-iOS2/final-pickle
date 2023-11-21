//
//  Mission-extension.swift
//  Pickle
//
//  Created by 박형환 on 10/18/23.
//

import Foundation

extension TimeMission {
    typealias PersistenceType = TimeMissionObject
    
    func mapToPersistenceObject() -> TimeMissionObject {
        TimeMissionObject(id: self.id,
                          title: self.title,
                          status: .init(rawValue: self.status.value) ?? .ready,
                          date: self.date,
                          wakeupTime: self.wakeupTime,
                          changeWakeupTime: self.changeWakeupTime)
    }
    
    static func mapFromPersistenceObject(_ object: TimeMissionObject) -> TimeMission {
        TimeMission(id: object.id,
                    title: object.title,
                    status: .init(rawValue: object.status.rawValue) ?? .ready,
                    date: object.date,
                    wakeupTime: object.wakeupTime,
                    changeWakeupTime: object.changeWakeupTime)

    }
}

extension TimeMission {
    func updateStatus(_ status: MissionStatus) -> Self {
        TimeMission(id: self.id,
                    title: self.title,
                    status: status,
                    date: self.date,
                    wakeupTime: self.wakeupTime,
                    changeWakeupTime: self.changeWakeupTime)
    }
}
