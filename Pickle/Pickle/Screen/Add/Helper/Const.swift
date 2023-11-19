//
//  Const.swift
//  Pickle
//
//  Created by 박형환 on 11/20/23.
//

import Foundation

enum Const: CaseIterable {
    static let ALL: [[String]] = [WELCOME1, WELCOME2, WELCOME3, WELCOME4]
    static let WELCOME1 = "오늘은 무슨일을 하실 생각 이세여?".map { String($0) }
    static let WELCOME2 = "피자가 드시고 싶으시다구요?".map { String($0) }
    static let WELCOME3 = "피자가 먹고 싶어요.........".map { String($0) }
    static let WELCOME4 = "할일을 완료하고 피자를 획득하세요!".map { String($0) }
}
