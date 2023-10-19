//
//  TimerViewModel.swift
//  Pickle
//
//  Created by 여성은 on 2023/10/19.
//

import SwiftUI

class TimerViewModel: ObservableObject {
    
    @Published var timeRemaining: TimeInterval = 0
    @Published var timeExtra: TimeInterval = 0
    @Published var spendTime: TimeInterval = 0
    
    @Published var backgroundTimeStemp: Date = Date()
    
    @Published var isDecresing: Bool = true // 목표시간 줄어드는

}
