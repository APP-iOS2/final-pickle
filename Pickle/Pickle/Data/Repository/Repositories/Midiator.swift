//
//  Adapter.swift
//  Pickle
//
//  Created by 박형환 on 10/7/23.
//

import Foundation

enum Adpater {
    static weak var repository: (any MissionRepositoryProtocol)?
    static var type: MissionRepositoryType = .none
}

enum MissionError: Error {
    case castingError
}

struct MissionMediator {
    @Injected(TimeRepoKey.self) var timeRespository: any TimeRepositoryProtocol
    @Injected(BehaviorRepoKey.self) var behaviorRepository: any BehaviorRepositoryProtocol
    
    typealias DTO = Mission
    typealias Persisted = MissionObject
    typealias A = Adpater
    
    private func setRepository(mission: MissionType) {
        let missionType = mission.type
        if Adpater.type == missionType { return }
        else { Adpater.type = missionType }
        
        switch missionType {
        case .time:
            Adpater.repository = timeRespository
        case .behavior:
            Adpater.repository = behaviorRepository
        default:
            return
        }
    }
    
    func fetch<T: Persisted>(sorted: Sorted, type: MissionType) async throws -> T {
        setRepository(mission: type)
        let value = await A.repository?.fetch(sorted: sorted)
        guard let value = value as? T
        else { throw MissionError.castingError }
        return value
    }
    
    func create<T: Persisted>(type: MissionType, _ completion: @escaping (T) -> Void) {
        // TODO: 추후 수정
//        A.repository?.create(item: .init()) { value in
//            Log.debug("create: \(value)")
//        }
    }
    
    func add(type: MissionType, value: some Mission) {
        setRepository(mission: type)
        A.repository?.save(model: value)
    }
    
    func delete<T: DTO>(type: MissionType, value: T) where T: MappableProtocol {
        setRepository(mission: type)
        if let repo = A.repository {
        }
    }
}
