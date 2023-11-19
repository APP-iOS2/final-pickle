//
//  UserObject.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//
import Foundation
import RealmSwift

class UserObject: Object, Identifiable {

    @Persisted(primaryKey: true) var id: String
    @Persisted var nickName: String
    @Persisted var currentPizzaCount: Int
    @Persisted var currentPizzaSlice: Int
    
    typealias PizzaID = String
    @Persisted var currentPizzaID: PizzaID
    @Persisted var currentPizzaList: RealmSwift.List<CurrentPizzaObject>
    @Persisted var createdAt: Date  // 유저 계정 생성 날짜,시간
    
    convenience init(id: String,
                     nickName: String,
                     currentPizzaCount: Int,
                     currentPizzaSlice: Int,
                     currentPizzaID: PizzaID,
                     currentPizzaList: [CurrentPizzaObject],
                     createdAt: Date) {
        self.init()
        self.id = id
        self.nickName = nickName
        self.currentPizzaCount = currentPizzaCount
        self.currentPizzaSlice = currentPizzaSlice
        self.currentPizzaID = currentPizzaID
        self.currentPizzaList.append(objectsIn: currentPizzaList)
        self.createdAt = createdAt
        
        // let currents = RealmSwift.List<CurrentPizzaObject>()
        // currents.forEach { currents.append($0) }
        // let value = RealmSwift.List<PizzaObject>()
        // pizzaList.forEach { value.append($0) }
        // self.pizza = value
    }
    
    class override func primaryKey() -> String? {
        "id"
    }
}

extension UserObject {
    static let user: UserObject = .init(id: UUID().uuidString,
                                        nickName: "",
                                        currentPizzaCount: 100,
                                        currentPizzaSlice: 100,
                                        currentPizzaID: "",
                                        currentPizzaList: [],
                                        createdAt: Date())
}
