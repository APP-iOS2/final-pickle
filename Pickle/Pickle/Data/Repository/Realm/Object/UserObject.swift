//
//  UserObject.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//

import SwiftUI
import RealmSwift

class UserObject: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var nickName: String
    @Persisted var currentPizzaCount: Int
    @Persisted var currentPizzaSlice: Int
    @Persisted var createdAt: Date  // 유저 계정 생성 날짜,시간
    
    convenience init(nickName: String,
                     currentPizzaCount: Int,
                     currentPizzaSlice: Int,
                     createdAt: Date) {
        self.init()
        
        self.nickName = nickName
        self.currentPizzaCount = currentPizzaCount
        self.currentPizzaSlice = currentPizzaSlice
        self.createdAt = createdAt
    }
    
    class override func primaryKey() -> String? {
        "id"
    }
}


extension UserObject: Storable {
    static let user: UserObject = .init(nickName: "",
                                        currentPizzaCount: 100,
                                        currentPizzaSlice: 100,
                                        createdAt: Date())
}

