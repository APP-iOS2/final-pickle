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
    @Published var fromBackground: Bool = false
    
    @Published var isDecresing: Bool = true // 목표시간 줄어드는거 관련 변수
    
    private let wiseSayingArray: [String] = [
        "게으름은 즐겁지만 괴로운 상태다. \n 우리는 행복해지기 위해서 무엇인가 하고 있어야 한다 \n -마하마트 간디-",
        "신은 우리가 성공할 것을 요구하지 않는다. \n 우리가 노력할 것을 요구할 뿐이다 \n -마더 테레사-",
        "어떤 것이 당신이 계획대로 되지 않는 다고 해서 그것이 불필요한 것은 아니다. \n -토마스 에디슨-"
    ]
    @Published var wiseSaying: String = ""
    
    func timerVMreset() {
        self.timeRemaining = 0
        self.timeExtra = 0
        self.spendTime = 0
        self.isDecresing = true
    }
    
    func makeRandomSaying() -> String {
        wiseSaying = wiseSayingArray.randomElement()!
        return wiseSaying
    }
}
