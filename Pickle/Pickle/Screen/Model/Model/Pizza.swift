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
    var lock: Bool
    var createdAt: Date  // 피자 생성 날짜,시간
    
    init(id: String = UUID().uuidString, name: String, image: String, lock: Bool, createdAt: Date) {
        self.id = id
        self.name = name
        self.image = image
        self.lock = lock
        self.createdAt = createdAt
    }
    
    /// 피자 잠금해제 메소드
    mutating func lockToggle() {
        self.lock.toggle()
    }
}

extension Pizza: Codable { }
extension Pizza: Equatable { }

extension Pizza {
    
    static let defaultPizza: Pizza = .init(name: "페퍼로니 피자",
                                           image: "pepperoni",
                                           lock: false,
                                           createdAt: Date())
    
    static let allCasePizza: [Pizza] =
    [
        pepperoni,
        cheese,
        potato,
        baconPotato,
        hawaian,
        sweetPotato,
        margherita
    ]
    
    static func filtered(_ name: String) -> Pizza {
        allCasePizza.filter { $0.name == name}.first!
    }
    
    static let pepperoni: Pizza = .init(name: "페퍼로니 피자",
                                        image: "pepperoni",
                                        lock: false,
                                        createdAt: Date())
    
    static let cheese: Pizza = .init( name: "치즈 피자",
                                      image: "cheese",
                                      lock: true,
                                      createdAt: Date())
    
    static let potato: Pizza = .init(name: "포테이토 피자",
                                     image: "potato",
                                     lock: true,
                                     createdAt: Date())
    
    static let baconPotato: Pizza = .init( name: "베이컨 포테이토 피자",
                                           image: "baconPotato",
                                           lock: true,
                                           createdAt: Date())
    
    static let sweetPotato: Pizza = .init(name: "고구마 피자",
                                          image: "sweetPotato",
                                          lock: true,
                                          createdAt: Date())
    
    static let hawaian: Pizza = .init( name: "하와이안 피자",
                                       image: "hawaiian",
                                       lock: true,
                                       createdAt: Date())
    
    static let margherita: Pizza = .init(name: "마르게리타 피자",
                                         image: "margherita",
                                         lock: true,
                                         createdAt: Date())
}
