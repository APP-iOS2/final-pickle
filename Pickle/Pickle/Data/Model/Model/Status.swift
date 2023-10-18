//
//  Status.swift
//  Pickle
//
//  Created by 박형환 on 10/18/23.
//

import Foundation

typealias TodoStatus = Status
typealias MissionStatus = Status

enum Status: String {
    // 진행전 진행중 완료 포기
    case ready
    case ongoing
    case complete
    case done
    case giveUp
    
    var value: String {
        self.rawValue
    }
    
    var string: String {
        switch self {
        case .ready:
            return "아직"
        case .ongoing:
            return "진행중"
        case .complete:
            return "성공"
        case .done:
            return "완료"
        case .giveUp:
            return "포기"
        }
    }
}
