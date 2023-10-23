//
//  UserObject.swift
//  Pickle
//
//  Created by 박형환 on 10/10/23.
//
import Foundation
import RealmSwift

class CurrentPizzaObject: Object, Identifiable {
    
    @Persisted var currentPizzaCount: Int
    @Persisted var currentPizzaSlice: Int
    @Persisted var pizza: String
    @Persisted var createdAt: Date
    
    convenience init(currentPizzaCount: Int,
                     currentPizzaSlice: Int,
                     pizza name: String,
                     createdAt: Date) {
        self.init()
        self.currentPizzaCount = currentPizzaCount
        self.currentPizzaSlice = currentPizzaSlice
        self.createdAt = createdAt
        self.pizza = name
    }
}

extension CurrentPizzaObject: Storable {}

class UserObject: Object, Identifiable {

    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var nickName: String
    @Persisted var currentPizzaCount: Int
    @Persisted var currentPizzaSlice: Int
    
    @Persisted var pizza: RealmSwift.List<PizzaObject>
    @Persisted var currentPizzaList: RealmSwift.List<CurrentPizzaObject>
    
    @Persisted var createdAt: Date  // 유저 계정 생성 날짜,시간
    
    convenience init(nickName: String,
                     currentPizzaCount: Int,
                     currentPizzaSlice: Int,
                     pizzaList: [PizzaObject],
                     currentPizzaList: [CurrentPizzaObject],
                     createdAt: Date) {
        self.init()
        self.nickName = nickName
        self.currentPizzaCount = currentPizzaCount
        self.currentPizzaSlice = currentPizzaSlice
        self.createdAt = createdAt
        
        let value = RealmSwift.List<PizzaObject>()
        let currents = RealmSwift.List<CurrentPizzaObject>()
        pizzaList.forEach { value.append($0) }
        currents.forEach { currents.append($0) }
        self.pizza = value
        self.currentPizzaList = currents
    }
    
    convenience init(id: String,
                     nickName: String,
                     currentPizzaCount: Int,
                     currentPizzaSlice: Int,
                     pizzaList: [PizzaObject],
                     currentPizzaList: [CurrentPizzaObject],
                     createdAt: Date) {
        
        self.init(nickName: nickName,
                  currentPizzaCount: currentPizzaCount,
                  currentPizzaSlice: currentPizzaSlice,
                  pizzaList: pizzaList, 
                  currentPizzaList: currentPizzaList,
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
                                        currentPizzaList: [],
                                        createdAt: Date())
}
