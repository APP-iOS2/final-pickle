//
//  UserObject.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//
import Foundation
import RealmSwift

class UserObject: Object, Identifiable {

    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var nickName: String
    @Persisted var currentPizzaCount: Int
    @Persisted var currentPizzaSlice: Int
    @Persisted var pizza: RealmSwift.List<PizzaObject>
    @Persisted var createdAt: Date  // 유저 계정 생성 날짜,시간
    
    convenience init(nickName: String,
                     currentPizzaCount: Int,
                     currentPizzaSlice: Int,
                     pizzaList: [PizzaObject],
                     createdAt: Date) {
        self.init()
        self.nickName = nickName
        self.currentPizzaCount = currentPizzaCount
        self.currentPizzaSlice = currentPizzaSlice
        self.createdAt = createdAt
        
        let value = RealmSwift.List<PizzaObject>()
        pizzaList.forEach { value.append($0) }
        self.pizza = value
    }
    
    convenience init(id: String,
                     nickName: String,
                     currentPizzaCount: Int,
                     currentPizzaSlice: Int,
                     pizzaList: [PizzaObject],
                     createdAt: Date) {
        
        self.init(nickName: nickName,
                  currentPizzaCount: currentPizzaCount,
                  currentPizzaSlice: currentPizzaSlice,
                  pizzaList: pizzaList,
                  createdAt: createdAt)
        self.id = try! ObjectId(string: id)
    }
    
    class override func primaryKey() -> String? {
        "id"
    }
}

extension UserObject {
    static let user: UserObject = .init(nickName: "",
                                        currentPizzaCount: 100,
                                        currentPizzaSlice: 100,
                                        pizzaList: [],
                                        createdAt: Date())
}
