//
//  BehaviorMissionRepository.swift
//  Pickle
//
//  Created by 박형환 on 10/6/23.
//

import Foundation

final class BehaviorMissionRepository: BaseRepository<BehaviorMissionObject>, BehaviorRepositoryProtocol {
    typealias DTO = BehaviorMission
    typealias Persisted = BehaviorMissionObject
    
    func fetch(sorted: Sorted) async -> [BehaviorMission] {
        await withCheckedContinuation { continuation in
            super.fetch(BehaviorMissionObject.self, predicate: nil, sorted: Sorted(key: "date", ascending: true)) { missions in
                let results = missions.map { BehaviorMission.mapFromPersistenceObject($0) }
                continuation.resume(returning: results)
            }
        }
    }
    
    func fetch(sorted: Sorted) -> [BehaviorMission] {
        do {
            let behaviorMissionObject = try super.fetch(BehaviorMissionObject.self, predicate: nil, sorted: Sorted(key: "date", ascending: true))
            let results = behaviorMissionObject.map { BehaviorMission.mapFromPersistenceObject($0) }
            return results
        } catch {
            assert(false)
        }
    }
    
    func create(_ completion: @escaping (BehaviorMissionObject) -> Void) {
        do {
            try super.create(BehaviorMissionObject.self, completion: completion)
        } catch {
            Log.error("error occur : \(error)")
        }
    }
    
    func save<T>(model: T) where T: Mission {
        let persistent = model.mapToPersistenceObject()
        do {
            guard let data = persistent as? Persisted else { throw MissionError.castingError }
            try super.save(object: data)
        } catch {
            Log.error("error occur: \(error)")
        }
    }
    
    func update(model: BehaviorMission) {
        let persistent = model.mapToPersistenceObject()
        do {
            try super.update(object: persistent)
        } catch {
            Log.error("error occur: \(error)")
        }
    }
    
    func delete(model: BehaviorMission) {
        let persistent = model.mapToPersistenceObject()
        do {
            try super.delete(object: persistent, id: persistent.id.stringValue)
        } catch {
            Log.error("error: occur: \(error)")
        }
    }
    
    func deleteAll() {
        do {
            try super.deleteAll(BehaviorMissionObject.self)
        } catch {
            Log.error("error occur: \(error)")
        }
    }
}
