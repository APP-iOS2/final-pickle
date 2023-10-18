//
//  Pizza.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/26.
//

import Foundation

struct Pizza: Identifiable {
    let id: String
    let name: String
    let image: String
    let lock: Bool
    var createdAt: Date  // 피자 생성 날짜,시간
    
    init(id: String = UUID().uuidString, name: String, image: String, lock: Bool, createdAt: Date) {
        self.id = id
        self.name = name
        self.image = image
        self.lock = lock
        self.createdAt = createdAt
    }
}

extension Pizza: Codable { }

extension Pizza {
    
    static let defaultPizza: Pizza = .init(name: "Guest",
                                           image: "potatoPizza",
                                           lock: false,
                                           createdAt: Date())
    
    static let allCasePizza: [Pizza] = [potatoPizza,
                                        baconPotatoPizza,
                                        hawaianPizza,
                                        pepperoniPizza,
                                        cheesePizza]
    
    static let potatoPizza: Pizza = .init(name: "포테이토 피자",
                                          image: "potatoPizza",
                                          lock: false,
                                          createdAt: Date())
    
    static let baconPotatoPizza: Pizza = .init( name: "베이컨 포테이토 피자",
                                                image: "baconPotatoPizza",
                                                lock: true,
                                                createdAt: Date())
    
    static let hawaianPizza: Pizza = .init( name: "하와이안 피자",
                                            image: "hawaianPizza",
                                            lock: true,
                                            createdAt: Date())
    
    static let pepperoniPizza: Pizza = .init(name: "페퍼로니 피자",
                                             image: "pepperoniPizza",
                                             lock: true,
                                             createdAt: Date())
    
    static let cheesePizza: Pizza = .init( name: "치즈 피자",
                                           image: "cheesePizza",
                                           lock: true,
                                           createdAt: Date())
}

