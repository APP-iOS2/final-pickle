//
//  HealthKit.swift
//  Pickle
//
//  Created by Suji Jang on 10/16/23.
//

import Foundation
import HealthKit

class HealthKitStore: ObservableObject {

    var stepCount: Int? = nil
    private let healthStore: HKHealthStore? = HKHealthStore()

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            completion(false)
            return
        }

        healthStore?.requestAuthorization(toShare: [], read: [stepType]) { success, error in
            completion(success)
        }
    }

    func fetchStepCount(_ completion: @escaping () -> Void = {}) {
        guard let healthStore = healthStore else {
            completion()
            return
        }

        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)

        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion()
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            if let result = result, let sum = result.sumQuantity() {
                let stepCount = Int(sum.doubleValue(for: HKUnit.count()))
                DispatchQueue.main.async {
                    self.stepCount = stepCount
                    completion()
                }
            } else if let error = error {
                Log.error("걸음 수 가져오기 실패: \(error.localizedDescription)")
            }
        }
        healthStore.execute(query)
    }
}
