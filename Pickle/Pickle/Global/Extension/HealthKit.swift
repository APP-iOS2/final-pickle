//
//  HealthKit.swift
//  Pickle
//
//  Created by Suji Jang on 10/14/23.
//

import Foundation
import HealthKit

final class HealthKitStorage {
    static let shared = HealthKitStorage()
    
    private let store = HKHealthStore()
    
    // 접근할 카테고리
    private let typesToShare: Set<HKSampleType> = [
        HKObjectType.quantityType(forIdentifier: .stepCount)!
    ]
    
    private var concurrecy: Concurrency?
    
    private init() {
        self.concurrecy = Concurrency(store, toShare: typesToShare)
    }
    
    func requestAuthorizationIfNeeded() async throws -> Bool {
        // 헬스킷 사용 가능 여부 확인
        // 헬스킷은 아이패드에서 사용할 수 없다.
        guard HKHealthStore.isHealthDataAvailable() else {
            print("아이폰 외 다른 기기에서는 사용할 수 없습니다.")
            return false
        }
        
        guard let concurrecy = concurrecy else {
            fatalError("Concurrency is not supported.")
        }
        
        return try await concurrecy.requestAuthorization()
    }
    
    func retrieveStepCount(withStart start: Date?,
                           end: Date?,
                           options: HKQueryOptions) async throws -> (HKSampleQuery, [HKSample]?) {
        let predicate = HKQuery.predicateForSamples(withStart: start,
                                                    end: end,
                                                    options: options)
        guard let concurrecy = concurrecy else {
            fatalError("Concurrency is not supported.")
        }
        
        return try await concurrecy.retrieveStepCount(predicate: predicate)
    }
}

// MARK: - HealthKitStorage.Concurrency
extension HealthKitStorage {
    
    final class Concurrency {
        private let store: HKHealthStore
        private let typesToShare: Set<HKSampleType>
        
        init(_ store: HKHealthStore, toShare typesToShare: Set<HKSampleType>) {
            self.store = store
            self.typesToShare = typesToShare
        }
        
        func requestAuthorization() async throws -> Bool {
            return try await withCheckedThrowingContinuation { continuation in
                /*
                 The success parameter of the completion indicates whether prompting the user, if necessary, completed
                 successfully and was not cancelled by the user.  It does NOT indicate whether the application was
                 granted authorization.
                 */
                store.requestAuthorization(toShare: typesToShare, read: typesToShare) { isSuccess, error in
                    if let error = error {
                        continuation.resume(with: .failure(error))
                    } else {
                        continuation.resume(with: .success(isSuccess))
                    }
                }
            }
        }
        
        // (HKSampleQuery, [HKSample]?, Error?)
        func retrieveStepCount(predicate: NSPredicate) async throws -> (HKSampleQuery, [HKSample]?) {
            return try await withCheckedThrowingContinuation { continuation in
                guard let stepType = HKSampleType.quantityType(forIdentifier: .stepCount) else {
                    let error = NSError(domain: "Invalid a HKQuantityType", code: 500, userInfo: nil)
                    continuation.resume(throwing: error)
                    return
                }
                
                let query = HKSampleQuery(sampleType: stepType,
                                          predicate: predicate,
                                          limit: 0,
                                          sortDescriptors: nil) {query, sample, error in
                    continuation.resume(with: .success((query, sample)))
                }
                store.execute(query)
            }
        }
    }
}
