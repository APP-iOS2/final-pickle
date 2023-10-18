//
//  HealthKit.swift
//  Pickle
//
//  Created by Suji Jang on 10/16/23.
//

import Foundation
import HealthKit

class HealthKitStore {
    var stepCount: Int? = nil
    let healthStore = HKHealthStore()
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        // HealthKit 권한 요청
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
            completion(success)
        }
    }
    
    func fetchStepCount(_ completion: @escaping () -> Void = {}) {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        let stepType = HKSampleType.quantityType(forIdentifier: .stepCount)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            if let result = result, let sum = result.sumQuantity() {
                let stepCount = Int(sum.doubleValue(for: HKUnit.count()))
                DispatchQueue.main.async {
                    self.stepCount = stepCount
                    completion()
                }
            } else if let error = error {
                print("걸음 수 가져오기 실패: \(error.localizedDescription)")
            }
        }
        healthStore.execute(query)
    }
}
