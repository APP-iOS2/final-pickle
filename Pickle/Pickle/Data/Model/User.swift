//
//  User.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/26.
//

import Foundation

struct User {
    let id: String
    var nickName: String
    var currentPizzaCount: Int
    var currentPizzaSlice: Int
    var createdAt: Date  // 유저 계정 생성 날짜,시간
    
    init(id: String, nickName: String, currentPizzaCount: Int, currentPizzaSlice: Int, createdAt: Date) {
        self.id = id
        self.nickName = nickName
        self.currentPizzaCount = currentPizzaCount
        self.currentPizzaSlice = currentPizzaSlice
        self.createdAt = createdAt
    }
    
    /// 피자 조각을 추가하고 , 8조각 이상일시 슬라이스를 0으로 만들고 피자카운트를 (1 = defaut) 증가 시키는 메서드
    /// - Parameter count: 피자 조각갯수
    mutating func addPizzaSliceValidation(count: Int = 1) -> Self {
        currentPizzaSlice += count
        if currentPizzaSlice >= 8 {
            currentPizzaSlice = 0
            currentPizzaCount += 1
        }
        return self
    }
}

extension User {
    static let defaultUser: User = .init(id: UUID().uuidString,
                                         nickName: "Guest",
                                         currentPizzaCount: 0,
                                         currentPizzaSlice: 0,
                                         createdAt: Date())
}
/*
 - 포인트
 - 통계
 */

extension User: MappableProtocol {
    typealias PersistenceType = UserObject
    
    func mapToPersistenceObject() -> PersistenceType {
        if let _ = UUID(uuidString: self.id) {
            return UserObject(nickName: self.nickName,
                              currentPizzaCount: self.currentPizzaCount,
                              currentPizzaSlice: self.currentPizzaSlice,
                              createdAt: self.createdAt)
        } else {
            return UserObject(id: self.id,
                              nickName: self.nickName,
                              currentPizzaCount: self.currentPizzaCount,
                              currentPizzaSlice: self.currentPizzaSlice,
                              createdAt: self.createdAt)
        }
    }
    
    static func mapFromPersistenceObject(_ object: PersistenceType) -> Self {
        User(id: object.id.stringValue,
             nickName: object.nickName,
             currentPizzaCount: object.currentPizzaCount,
             currentPizzaSlice: object.currentPizzaSlice,
             createdAt: object.createdAt)
    }
}

extension User: Equatable {
    
}
