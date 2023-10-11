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
}

/*
 - 포인트
 - 통계
 */

extension User: MappableProtocol {
    typealias PersistenceType = UserObject
    
    func mapToPersistenceObject() -> PersistenceType {
        if let id = UUID(uuidString: self.id) {
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
