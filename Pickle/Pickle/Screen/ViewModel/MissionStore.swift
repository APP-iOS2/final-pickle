//
//  TodoStore.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import SwiftUI

//                              UserRepository                                            CoreData
// TodoStore --->-protocol-<-- TodoRepository ---상속---> BaseRepository --->protocol <--- RealmStore (입출력)
// MissionStore               MissionRepository                                           FireStore

enum MissionType {
    case time(TimeMission)
    case behavior(BehaviorMission)
    
    var anyMission: any Mission {
        switch self {
        case .time(let timeMission):
            return timeMission
        case .behavior(let behaviorMission):
            return behaviorMission
        }
    }
    
    var type: MissionRepositoryType {
        switch self {
        case .time(_):
            return .time
        case .behavior(_):
            return .behavior
        }
    }
}

enum MissionRepositoryType {
    case time
    case behavior
    case none
}

enum CommandType {
    case create
    case delete
    case deleteAll
    case add
    case fetch
}

struct Command {
    var command: () -> ()
}

final class MissionStore: ObservableObject {
    
    @Published var timeMissions: [TimeMission] = []
    @Published var behaviorMissions: [BehaviorMission] = []
    
    // MARK: DI - propertywrapper OR init, dicontainer
    //    struct Dependency {
    //        var todoRepository: TodoRepository
    //    }
    //    private let repository: TodoRepositoryProtocol
    //
    //    init(repository: TodoRepositoryProtocol) {
    //        self.repository = repository
    //    }
    
    @Injected(TimeRepoKey.self) var timeMissionRepository: any TimeRepositoryProtocol
    @Injected(BehaviorRepoKey.self) var behaviorMissionRepository: any BehaviorRepositoryProtocol
    
    struct Command {
        var command: (() -> Void)?
    }
    
    lazy var commandMap: [() -> ()] = [
        timeMissionRepository.deleteAll
    ]
    //    @Injected(MissionMediator.self) var mediator: MissionMediator
    
    // MARK: 1안 그냥 되는대로 하다가 나중에 생각한다. 너무 처음부터 빡세게 생각하는것 같다.
    // MARK: 2안 enum으로 그냥 한다.
    // MARK: 3안 mediator ?
    // MARK: 4안 command를 딕셔너리로 ?
    // MARK: 5안 store(viewModel)를 쪼갠다
    
    @MainActor
    func fetch() async -> ([TimeMission],[BehaviorMission]) {
        async let timeMission = timeMissionRepository.fetch(sorted: Sorted.missionAscending)
        async let behaviorMission = behaviorMissionRepository.fetch(sorted: Sorted.missionAscending)
        
        let (timeMissions, behaviorMissions) = await (timeMission, behaviorMission)
        self.timeMissions = timeMissions
        self.behaviorMissions = behaviorMissions
        return (self.timeMissions,self.behaviorMissions)
    }
    
    func add(mission: MissionType) {
        switch mission {
        case .time(let timeMission):
            timeMissionRepository.save(model: timeMission)
        case .behavior(let behaviorMission):
            behaviorMissionRepository.save(model: behaviorMission)
        }
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
        case .time(_):
            timeMissionRepository.deleteAll()
        case .behavior(_):
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
    
    /// 빈 모델 생성
    func create(mission: MissionType) {
        switch mission {
        case .time(_):
            timeMissionRepository.create { _ in }
        case .behavior(_):
            behaviorMissionRepository.create { _ in }
        }
    }
    
    //    private func command(mission type1: MissionType, command type2: CommandType) {
    //        switch type1 {
    //        case .time(let timeMission):
    //            break
    //        case .behavior(let behaviorMission):
    //            <#code#>
    //        }
    //    }
    //
    //    private func command(command type: CommandType) {
    //        switch type {
    //        case .create:
    //            <#code#>
    //        case .delete:
    //            <#code#>
    //        case .deleteAll:
    //            <#code#>
    //        case .add:
    //            <#code#>
    //        case .fetch:
    //            <#code#>
    //        }
    //    }
}
