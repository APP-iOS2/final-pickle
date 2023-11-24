//
//  TodoStore.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import SwiftUI

// TODO: Mission Notification Observer 달기
@MainActor
final class MissionStore: ObservableObject {
    
    @Published var timeMissions: [TimeMission] = [] // 보라색에
    @Published var behaviorMissions: [BehaviorMission] = []
    
    private var timeMissionToken: RNotificationToken?
    private var behaviorMissionToken: RNotificationToken?
    
    @Injected(TimeRepoKey.self) var timeMissionRepository: any TimeRepositoryProtocol
    @Injected(BehaviorRepoKey.self) var behaviorMissionRepository: any BehaviorRepositoryProtocol
    
    init() {
        self.missionSetting()
        //self.fetch()
    }
    
    func fetch() -> ([TimeMission], [BehaviorMission]) {
        let _timeMissions = timeMissionRepository.fetch(sorted: Sorted.missionAscending)
        let _behaviorMissions = behaviorMissionRepository.fetch(sorted: Sorted.missionAscending)
         
        self.timeMissions = _timeMissions
        self.behaviorMissions = _behaviorMissions
        
        return (_timeMissions, _behaviorMissions)
    }
    
    func add(mission: MissionType) {
        switch mission {
        case .time(let timeMission):
            timeMissionRepository.save(model: timeMission)
        case .behavior(let behaviorMission):
            behaviorMissionRepository.save(model: behaviorMission)
        }
        self.fetch()
    }
    
    func delete(mission: MissionType) {
        switch mission {
        case .time(let timeMission):
            timeMissionRepository.delete(model: timeMission)
        case .behavior(let behaviorMission):
            behaviorMissionRepository.delete(model: behaviorMission)
        }
    }
    
    /// 전체 목록 Delete
    /// - Parameter todo: todo Struct
    func deleteAll(mission: MissionType) {
        switch mission {
        case .time(let value):
            Log.debug(value)
            timeMissionRepository.deleteAll()
        case .behavior(let value):
            Log.debug(value)
            behaviorMissionRepository.deleteAll()
        }
    }
    
    func update(mission: MissionType) {
        switch mission {
        case .time(let timeMission):
            timeMissionRepository.update(model: timeMission)
        case .behavior(let behaviorMission):
            behaviorMissionRepository.update(model: behaviorMission)
        }
    }
    
    func observe(mission: MissionType) {
        let timeMissionKeypaths = TimeMissionObject.allKeyPath()
        let behaviorMissionKeypaths = BehaviorMissionObject.allKeyPath()
        do {
            switch mission {
            case .time(let timeMission):
                timeMissionToken = try timeMissionRepository.notification(id: timeMission.id,
                                                                   keyPaths: timeMissionKeypaths) {
                    [weak self] tiemMission in
                    Task.detached {
                            await MainActor.run {
                                self?.updateTimeMission(timeMission)
                            }
                        }
                }
            case .behavior(let behaviorMission):
                behaviorMissionToken
                = try behaviorMissionRepository.notification(id: behaviorMission.id,
                                                             keyPaths: behaviorMissionKeypaths) {
                    [weak self] behaviorMission in
                    Task.detached {
                        await MainActor.run {
                            self?.updateBehaviorMission(behaviorMission)
                        }
                    }
                }
            }
        } catch {
            assert(false)
        }
    }
    
    private func updateTimeMission(_ timeMission: TimeMission) {
        timeMissions = timeMissions.map { mission in
            return mission.id == timeMission.id ? timeMission : mission
        }
    }
    
    private func updateBehaviorMission(_ behaviorMission: BehaviorMission) {
        behaviorMissions = behaviorMissions.map { mission in
            return mission.id == behaviorMission.id ? behaviorMission : mission
        }
    }
    
    func missionSetting() {
        let (t, b) = self.fetch()
       //        if t.isEmpty {
//            let time = TimeMission(title: "기상 미션", status: .ready, date: Date(), wakeupTime: Date())
//            self.add(mission: .time(time))
//        }
        var hasTodaysData = false
        
        if behaviorMissions.isEmpty {
            let behavior = BehaviorMission()
            self.add(mission: .behavior(behavior))
        }
            
        for i in behaviorMissions {
            if i.date.isToday {
                hasTodaysData = true
                break
            }
        }
        
        
        if hasTodaysData == false {
            let behavior = BehaviorMission()
            self.add(mission: .behavior(behavior))
        }


    }
}
